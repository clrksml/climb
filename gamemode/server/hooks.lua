
function GM:InitPostEntity()
	require("mysqloo")
	
	CLIMB_MYSQL = mysqloo.connect(CLIMB_HOST, CLIMB_USER, CLIMB_PASS, CLIMB_NAME, CLIMB_PORT)
	CLIMB_MYSQL.onConnectionFailed = function(db, err)
		print("Failed to connect to database -> " .. err)
	end
	CLIMB_MYSQL:connect()
	
	timer.Simple(4, function()
		GAMEMODE:GetMapData()
		GAMEMODE:GetMapList()
		GAMEMODE.Tops = {}
	end)
	
	timer.Simple(6, function()
		game.ConsoleCommand("ai_disabled 1\n")
		
		for k, v in pairs(ents.GetAll()) do 
			if IsValid(v) then
				if v:GetClass() == "func_breakable" or v:GetClass() == "func_breakable_surf" then
					v:Input("Break")
					
					if v:IsValid() then
						v:Remove()
					end
				end
			end
		end
	end)
end

function GM:PlayerInitialSpawn( ply )
	ply:SetTeam(TEAM_CLIMBER)
	ply:SetModel("models/player/group01/male_0" .. math.random(1,9) .. ".mdl")
	
	ply:GetData()
	
	ply:SetCustomCollisionCheck(true)
	
	ply:Spawn()
	
	ply.StartTime = CurTime()
	
	timer.Simple(1, function( )
		if !IsValid(ply) then return end
		net.Start("StartClimb")
		net.Send(ply)
		
		net.Start("SendTop10")
			net.WriteTable(GAMEMODE.Tops)
		net.Send(ply)
	end)
end

function GM:PlayerSpawn( ply )
	ply:SetCustomCollisionCheck(true)
	
	ply:Give("weapon_crowbar")
	
	ply:SetRunSpeed(220)
	ply:SetWalkSpeed(220)
	ply:SetMaxSpeed(220)
	ply:SetJumpPower(210)
	
	ply:SetGravity(1)
	
	ply:SetHull(Vector(-16, -16, 0), Vector(16, 16, 64))
	ply:SetHullDuck(Vector(-16, -16, 0), Vector(16, 16, 30))
	
	if ply:HasSaved() then
		ply:GotoLastSave( )
	end
end

function GM:PlayerDisconnected( ply )
	ply:SaveData()
end

function GM:PlayerSelectSpawn( ply )
	return table.Random(team.GetSpawnPoints(TEAM_CLIMBER))
end

function GM:PlayerDeathSound( )
	return true
end

function GM:PlayerShouldTakeDamage( ply, att )
	if att:IsPlayer() then return false end
	
	return true
end

function GM:GetFallDamage(ply, spd)
	return false
end

function GM:PlayerUse( ply, ent )
	if ent:IsNPC() and ent.End and !ply:GetNWBool("finished", false) then
		ply:Completion()
	end
	
	return true
end

function GM:PlayerCanJoinTeam( ply, idx )
	return false
end

function GM:EntityTakeDamage( ent, dmg )
	if ent:IsNPC() then
		dmg:ScaleDamage(0)
	end
	
	return dmg
end

function GM:CanPlayerSuicide( ply )
	return false
end

function GM:PlayerSwitchFlashlight( ply, bool )
	return true
end

function GM:CheckMapTime( ply )
	local map = game.GetMap()
	
	local query1 = CLIMB_MYSQL:query("SELECT * FROM `maps` WHERE `name`='" .. map .. "'")
	query1.onSuccess = function( data )
		data = data:getData()[1]
		if data['tops'] == nil or data['tops'] == "" then
			local tbl = { }
			tbl[1] = { sid = ply:SteamID64(), time = math.Round(ply.EndTime - ply.StartTime), saves = tostring(ply:GetNWInt("saves", 0)) }
			
			local query2 = CLIMB_MYSQL:query("UPDATE `maps` SET `tops`='" .. CLIMB_MYSQL:escape(util.TableToJSON(tbl)) .. "' WHERE `name`='" .. map .. "'")
			query2.onError = function( err, qry )
				print( "GM:CheckMapTime() failed update row." )
				print( "Error:", err )
				print( "Query:", qry )
			end
			query2:start()
			
			local query3 = CLIMB_MYSQL:query("UPDATE `players` SET `wins`='" .. ply.Wins + 1 .. "', `time`='" .. ply.Time + math.Round(ply.EndTime - ply.StartTime) .. "', `saves`='" .. ply.Saves + ply:GetNWInt("saves", 0) .. "' WHERE `sid`='" .. ply:SteamID64() .. "'")
			query3.onError = function( err, qry )
				print( "GM:CheckMapTime() failed update row." )
				print( "Error:", err )
				print( "Query:", qry )
			end
			query3:start()
			
			for _k, _v in pairs(player.GetAll()) do
				_v:ChatPrint(ply:Nick() .. " just set a new top 5 record at " .. string.ToMinutesSeconds(ply.EndTime - ply.StartTime) .. ".")
			end
			
			net.Start("SendTop10")
				net.WriteTable(GAMEMODE.Tops)
			net.Send(ply)
		else
			data = util.JSONToTable(tostring(data['tops']))
			GAMEMODE.Tops = data
			
			for k, v in pairs(data) do
				if table.Count(data) == 10 then
					local key = GetWinningKey(data)
					
					if key and data[key].time >= math.Round(ply.EndTime - ply.StartTime) then
						data[key] = { sid = ply:SteamID64(), time = math.Round(ply.EndTime - ply.StartTime), saves = tostring(ply:GetNWInt("saves", 0)) }
						
						data = SortTable(data)
						
						GAMEMODE.Tops = data
						
						local query2 = CLIMB_MYSQL:query("UPDATE `maps` SET `tops`='" .. CLIMB_MYSQL:escape(util.TableToJSON(data)) .. "' WHERE `name`='" .. map .. "'")
						query2.onError = function( err, qry )
							print( "GM:CheckMapTime() failed update row." )
							print( "Error:", err )
							print( "Query:", qry )
						end
						query2:start()
						
						for _k, _v in pairs(player.GetAll()) do
							_v:ChatPrint(ply:Nick() .. " just set a new top 5 record at " .. string.ToMinutesSeconds(ply.EndTime - ply.StartTime) .. ".")
						end
						
						net.Start("SendTop10")
							net.WriteTable(GAMEMODE.Tops)
						net.Send(ply)
						
						break
					else
						local query2 = CLIMB_MYSQL:query("UPDATE `players` SET `wins`='" .. ply.Wins + 1 .. "', `time`='" .. ply.Time + math.Round(ply.EndTime - ply.StartTime) .. "', `saves`='" .. ply.Saves + ply:GetNWInt("saves", 0) .. "' WHERE `sid`='" .. ply:SteamID64() .. "'")
						query2.onError = function( err, qry )
							print( "GM:CheckMapTime() failed update row." )
							print( "Error:", err )
							print( "Query:", qry )
						end
						query2:start()
						
						net.Start("SendTop10")
							net.WriteTable(GAMEMODE.Tops)
						net.Send(ply)
						
						break
					end
					
				elseif table.Count(data) < 10 then
					data[table.Count(data) + 1] = { sid = ply:SteamID64(), time = math.Round(ply.EndTime - ply.StartTime), saves = tostring(ply:GetNWInt("saves", 0)) }
					
					GAMEMODE.Tops = data
					
					local query2 = CLIMB_MYSQL:query("UPDATE `maps` SET `tops`='" .. CLIMB_MYSQL:escape(util.TableToJSON(data)) .. "' WHERE `name`='" .. map .. "'")
					query2.onError = function( err, qry )
						print( "GM:CheckMapTime() failed update row." )
						print( "Error:", err )
						print( "Query:", qry )
					end
					query2:start()
					
					local query3 = CLIMB_MYSQL:query("UPDATE `players` SET `wins`='" .. ply.Wins + 1 .. "', `time`='" .. ply.Time + math.Round(ply.EndTime - ply.StartTime) .. "', `saves`='" .. ply.Saves + ply:GetNWInt("saves", 0) .. "' WHERE `sid`='" .. ply:SteamID64() .. "'")
					query3.onError = function( err, qry )
						print( "GM:CheckMapTime() failed update row." )
						print( "Error:", err )
						print( "Query:", qry )
					end
					query3:start()
					
					for _k, _v in pairs(player.GetAll()) do
						_v:ChatPrint(ply:Nick() .. " just set a new top 5 record at " .. string.ToMinutesSeconds(ply.EndTime - ply.StartTime) .. ".")
					end
					
					net.Start("SendTop10")
						net.WriteTable(GAMEMODE.Tops)
					net.Send(ply)
					
					break
				end
			end
		end
	end
	query1:start()
end

function GM:GetMapData()
	local map = game.GetMap()
	
	local query1 = CLIMB_MYSQL:query("SELECT * FROM `maps` WHERE `name`='" .. map .. "'")
	query1.onSuccess = function( data )
		data = data:getData()[1]
		
		data['pos'] = string.Explode(", ", data['pos'])
		data['ang'] = string.Explode(", ", data['ang'])
		
		data['pos'] = Vector(tonumber(data['pos'][1]), tonumber(data['pos'][2]), tonumber(data['pos'][3]))
		data['ang'] = Angle(tonumber(data['ang'][1]), tonumber(data['ang'][2]), tonumber(data['ang'][3]))
		
		GAMEMODE.MapPay = data['pay'] or 2500
		GAMEMODE.MapTops = util.JSONToTable(tostring(data['tops'])) or {}
		GAMEMODE.NPCPos = data['pos']
		GAMEMODE.NPCang = data['ang']
		
		RewardNPC = ents.Create("npc_citizen")
		RewardNPC:SetAngles(data['ang'])
		RewardNPC:Spawn()
		RewardNPC:SetPos(data['pos'])
		RewardNPC:SetMoveType(MOVETYPE_NONE)
		RewardNPC:SetSchedule(SCHED_IDLE_STAND)
		RewardNPC:Activate()
		RewardNPC.End = true
	end
	query1.onError = function( err, qry )
		print( "GM:GetMapData() failed update row." )
		print( "Error:", err )
		print( "Query:", qry )
	end
	query1:start()
end

function GM:GetMapList()
	local map = game.GetMap()
	
	GAMEMODE.Maps = {}
	
	local query1 = CLIMB_MYSQL:query("SELECT `name` FROM `maps` ORDER BY `name` ASC")
	query1.onSuccess = function( data )
		data = data:getData()
		
		local str = ""
		for k, v in pairs(data) do
			table.insert(GAMEMODE.Maps, v['name'])
		end
	end
	query1.onError = function( err, qry )
		print( "GM:GetMapList() failed get rows." )
		print( "Error:", err )
		print( "Query:", qry )
	end
	query1:start()
	
	if CLIMB_MAPCHANGE then
		timer.Simple(6, function()
			GAMEMODE.NextMap = table.FindNext(GAMEMODE.Maps, map)
			print(GAMEMODE.NextMap .. " has been selected for the next map.")
			
			for k, v in pairs(player.GetAll()) do
				v:ChatPrint(GAMEMODE.NextMap .. " has been selected for the next map.")
			end
		end)
		
		timer.Create("everyfive", 300, 0, function()
			CLIMB_MapTime = CLIMB_MapTime - 300
			
			for k, v in pairs(player.GetAll()) do
				v:ChatPrint(string.ToMinutesSeconds(CLIMB_MapTime) .." left before map(" .. GAMEMODE.NextMap .. ") change.")
			end
		end)
		
		timer.Simple(CLIMB_MapTime + 5, function()
			for k, v in pairs(player.GetAll()) do
				v:ChatPrint("Changing level to " .. GAMEMODE.NextMap .. ".")
			end
			
			game.ConsoleCommand("changelevel " .. GAMEMODE.NextMap .. "\n")
		end)
	end
end

function GM:ShowTeam( ply )
	net.Start("ClimbMenu")
	net.Send(ply)
end

function GM:PlayerSay( ply, txt, tm )
	if txt == "!r" or txt == "/r" then ply:ChatPrint("Instead of typing " .. txt .. " PRESS THE NUMBER 6.") return "" end
end