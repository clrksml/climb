
local Player = FindMetaTable("Player")
local Entity = FindMetaTable("Entity")

function Player:GetData()
	local query1 = CLIMB_MYSQL:query("SELECT * FROM `players` WHERE `sid`='" .. self:SteamID64() .. "' LIMIT 1")
	query1.onSuccess = function( data )
		data = data:getData()[1]
		
		if data == nil then
			self:CreateData()
			return
		end
		
		self.Wins = data['wins']
		self.Time = data['time']
		self.Saves = data['saves']
		
		if self.Wins == nil then
			self.Wins = 0
		end
		if self.Time == nil then
			self.Time = 0
		end
		if self.Saves == nil then
			self.Saves = 0
		end
	end
	query1.onError = function( err, qry )
		print( "Player:GetData() failed to get row." )
		print( "Error:", err )
		print( "Query:", qry )
	end
	query1:start()
end

function Player:CreateData()
	local query1 = CLIMB_MYSQL:query("INSERT INTO `players` VALUES('" .. self:SteamID64() .. "', '" .. CLIMB_MYSQL:escape(self:Nick()) .. "', '" .. 0 .. "', '" .. 0 .. "', '" .. 0 .. "')")
	query1.onError = function( err, qry )
		print( "Player:CreateData() failed insert row." )
		print( "Error:", err )
		print( "Query:", qry )
	end
	query1:start()
end

function Player:SaveData()
	local time = 0
	
	if self.StartTime and self.EndTime then
		time = self.EndTime - self.StartTime
	end
	
	if self.Wins == nil then
		self.Wins = 0
	end
	if self.Time == nil then
		self.Time = 0
	end
	if self.Saves == nil then
		self.Saves = 0
	end
	
	local query1 = CLIMB_MYSQL:query("UPDATE `players` SET `name`='" .. CLIMB_MYSQL:escape(self:Nick()) .. "', `wins`='" .. self.Wins .. "', `time`='" .. time .. "', `saves`='" .. self:GetNWInt("saves", 0) .. "' WHERE `sid`='" .. self:SteamID64() .. "'")
	query1.onError = function( err, qry )
		print( "Player:SavaData() failed update row." )
		print( "Error:", err )
		print( "Query:", qry )
	end
	query1:start()
end

function Player:IsClimbing()
	if self:GetNWBool("finished", false) then
		return false
	else
		return true
	end
end

function Player:HasSaved()
	return self.Saved or false
end

function Player:SetSaved( bool )
	if !bool then
		self.Saved = false
	else
		self.Saved = true
	end
end

function Player:Completion()
	if self:GetNWBool("paused", false) == true then
		ply:Kick("Finished climb while paused.")
		
		return false
	end
	
	self.EndTime = CurTime()
	
	local num = GAMEMODE.MapPay
	
	if !self:HasSaved() then
		num = num * 2
	end
	
	self:SetNWBool("finished", true)
	self:SaveData()
	
	GAMEMODE:CheckMapTime( self )
	
	for k, v in pairs(player.GetAll()) do
		net.Start("PlayerTimes")
			net.WriteTable(CLIMB_PLAYERS)
		net.Send(v)
	end
	
	net.Start("EndClimb")
	net.Send(self)
	
	for k, v in pairs(player.GetAll()) do
		v:ChatPrint(self:Nick() .. " finished the map in " .. string.ToMinutesSeconds(self.EndTime - self.StartTime) .. ".")
	end
	
	if POINTSHOP then
		ply:PS_GivePoints(num, "You were awarded " .. tostring(num) .. " coins.")
	end
	
	hook.Call("FinishClimb", nil, {self, num})
end

function Player:Pause()
	if !self:GetNWBool("paused", false) then
		self:SetNWBool("paused", true)
		
		self:Freeze(true)
		
		self.PauseTime = CurTime()
		
		self:ChatPrint("Climb time has been paused.")
	else
		self:SetNWBool("paused", false)
		
		local time = CurTime() - self.PauseTime
		
		self:Freeze(false)
		
		self.StartTime = self.StartTime + time
		
		net.Start("ResumeClimb")
			net.WriteFloat(time)
		net.Send(self)
		
		for k, v in pairs(player.GetAll()) do
			net.Start("UpdatePlayerTime")
				net.WriteString(self:SteamID())
				net.WriteFloat(time)
			net.Send(v)
		end
		
		self:ChatPrint("You can now resume your climb.")
	end
end

function Player:Restart()
	self:ClearSaves( )
	self:SetSaved( false )
	
	self:SetNWInt("saves", 0)
	self:SetNWBool("finished", false)
	
	self.LastSavePos = nil
	self.LastSaveAng = nil
	self.OurSavePos = nil
	self.OurSaveAng = nil
	
	self:Spawn()
	
	self.StartTime = CurTime()
	
	net.Start("StartClimb")
	net.Send(self)
	
	net.Start("ClientSaves")
		net.WriteString("0")
	net.Send(self)
end

function Player:AddSave( pos, ang )
	if !self.SavesPos then
		self.SavesPos = {}
	end
	
	if !self.SavesAng then
		self.SavesAng = {}
	end
	
	if CLIMB_MAXSAVES > 0 then
		if self:GetNWInt("saves", 0) >= CLIMB_MAXSAVES then
			self:ChatPrint("You reached the maxium number of saves (" .. self:GetNWInt("saves", 0) .. "/" .. CLIMB_MAXSAVES .. ").")
			
			net.Start("LastAction")
				net.WriteFloat(0)
			net.Send(self)
			return
		end
	end
	
	table.insert(self.SavesPos, pos)
	table.insert(self.SavesAng, ang)
	
	self:SetNWInt("saves", self:GetNWInt("saves", 0) + 1)
	
	if !self:HasSaved() then
		self:SetSaved(true)
	end
	
	self.LastSavePos = pos
	self.LastSaveAng = ang
	self.OurSavePos = pos
	self.OurSaveAng = ang
	
	net.Start("ClientSaves")
		net.WriteString(table.Count(self.SavesPos))
	net.Send(self)
end

function Player:GetSaves( )
	return self.SavesPos or {}, self.SavesAng or {}
end

function Player:ClearSaves( )
	self.SavesPos = {}
	self.SavesAng = {}
	
	self:SetNWInt("saves", 0)
	
	self:ChatPrint("Your climb saves have been cleared.")
	
	net.Start("ClientSaves")
		net.WriteString("0")
	net.Send(self)
end

function Player:GotoLastSave( )
	if !self.LastSavePos or !self.LastSaveAng then return false end
	
	local pos, ang = self.LastSavePos, self.LastSaveAng
	
	self:SetPos(pos)
	self:SetEyeAngles(ang)
	self:SetLocalVelocity(Vector(0,0,0))
end

function Player:GotoNextSave( )
	if table.Count(self.SavesPos) >= 1 and table.Count(self.SavesAng) >= 1 then
		if self.OurSavePos and self.OurSaveAng then
			self.OurSavePos = table.FindNext(self.SavesPos, self.OurSavePos)
			self.OurSaveAng = table.FindNext(self.SavesAng, self.OurSaveAng)
		end
		
		if self.OurSavePos == nil and self.OurSaveAng == nil then
			self.OurSavePos = table.FindNext(self.SavesPos, self.OurSavePos)
			self.OurSaveAng = table.FindNext(self.SavesAng, self.OurSaveAng)
		end
		
		self:SetPos(self.OurSavePos)
		self:SetEyeAngles(self.OurSaveAng)
		self:SetLocalVelocity(Vector(0,0,0))
	end
end

function Player:GotoPrevSave( )
	if table.Count(self.SavesPos) >= 1 and table.Count(self.SavesAng) >= 1 then
		if self.OurSavePos and self.OurSaveAng then
			self.OurSavePos = table.FindPrev(self.SavesPos, self.OurSavePos)
			self.OurSaveAng = table.FindPrev(self.SavesAng, self.OurSaveAng)
		end
		
		if self.OurSavePos == nil and self.OurSaveAng == nil then
			self.OurSavePos = table.FindPrev(self.SavesPos, self.OurSavePos)
			self.OurSaveAng = table.FindPrev(self.SavesAng, self.OurSaveAng)
		end
		
		self:SetPos(self.OurSavePos)
		self:SetEyeAngles(self.OurSaveAng)
		self:SetLocalVelocity(Vector(0,0,0))
	end
end
