util.AddNetworkString("AddSave")
util.AddNetworkString("LastSave")
util.AddNetworkString("NextSave")
util.AddNetworkString("PrevSave")
util.AddNetworkString("ClearSaves")
util.AddNetworkString("Pause")
util.AddNetworkString("Restart")
util.AddNetworkString("LastAction")
util.AddNetworkString("StartClimb")
util.AddNetworkString("ResumeClimb")
util.AddNetworkString("EndClimb")
util.AddNetworkString("ClientSaves")
util.AddNetworkString("NPCMenu")
util.AddNetworkString("BoxMenu")
util.AddNetworkString("SpawnNPC")
util.AddNetworkString("SpawnBox")
util.AddNetworkString("SaveMapData")
util.AddNetworkString("SendTime")
util.AddNetworkString("PlayerTimes")
util.AddNetworkString("ClimbMenu")
util.AddNetworkString("ConfirmMenu")
util.AddNetworkString("UpdatePlayerTime")
util.AddNetworkString("SendTop10")

net.Receive("AddSave", function( l, ply )
	if ply:GetNWBool("paused", false) == true then
		ply:ChatPrint("Please unpause before trying to play.")
		
		net.Start("LastAction")
			net.WriteFloat(0)
		net.Send(self)
		
		return
	else
		if !ply:IsOnGround() then
			net.Start("LastAction")
				net.WriteFloat(0)
			net.Send(ply)
			
			ply:ChatPrint("You need to be on the ground to save your position.")
		else
			ply:AddSave( ply:GetPos(), ply:EyeAngles())
			
			net.Start("LastAction")
				net.WriteFloat(1)
			net.Send(ply)
		end
	end
end)

net.Receive("LastSave", function( l, ply )
	if ply:GetNWBool("paused", false) == true then
		ply:ChatPrint("Please unpause before trying to play.")
		
		net.Start("LastAction")
			net.WriteFloat(0)
		net.Send(self)
		
		return
	else
		ply:GotoLastSave()
		
		net.Start("LastAction")
			net.WriteFloat(1)
		net.Send(ply)
	end
end)

net.Receive("NextSave", function( l, ply )
	if ply:GetNWBool("paused", false) == true then
		ply:ChatPrint("Please unpause before trying to play.")
		
		net.Start("LastAction")
			net.WriteFloat(0)
		net.Send(self)
		
		return
	else
		ply:GotoNextSave()
		
		net.Start("LastAction")
			net.WriteFloat(1)
		net.Send(ply)
	end
end)

net.Receive("PrevSave", function( l, ply )
	if ply:GetNWBool("paused", false) == true then
		ply:ChatPrint("Please unpause before trying to play.")
		
		net.Start("LastAction")
			net.WriteFloat(0)
		net.Send(self)
		
		return
	else
		ply:GotoPrevSave()
		
		net.Start("LastAction")
			net.WriteFloat(1)
		net.Send(ply)
	end
end)

net.Receive("ClearSaves", function( l, ply )
	if ply:GetNWBool("paused", false) == true then
		ply:ChatPrint("Please unpause before trying to play.")
		
		net.Start("LastAction")
			net.WriteFloat(0)
		net.Send(self)
		
		return
	else
		ply:ClearSaves()
		
		net.Start("LastAction")
			net.WriteFloat(1)
		net.Send(ply)
	end
end)

net.Receive("Pause", function( l, ply )
	ply:Pause()
	
	net.Start("LastAction")
		net.WriteFloat(1)
	net.Send(ply)
end)

net.Receive("Restart", function( l, ply )
	if ply:GetNWBool("paused", false) == true then
		ply:ChatPrint("Please unpause before trying to play.")
		
		net.Start("LastAction")
			net.WriteFloat(0)
		net.Send(self)
		
		return
	else
		ply:Restart()
		
		net.Start("LastAction")
			net.WriteFloat(1)
		net.Send(ply)
	end
end)

CLIMB_PLAYERS = {}

net.Receive("SendTime", function( l, ply )
	CLIMB_PLAYERS[ply:SteamID()] = tonumber(net.ReadFloat())
	
	for k, v in pairs(player.GetAll()) do
		net.Start("PlayerTimes")
			net.WriteTable(CLIMB_PLAYERS)
		net.Send(v)
	end
end)
