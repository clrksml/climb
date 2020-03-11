
net.Receive("LastAction", function( l )
	local int = tonumber(net.ReadFloat())
	
	if int == 1 then
		surface.PlaySound("UI/buttonclick.wav")
	else
		surface.PlaySound("UI/buttonclickrelease.wav")
	end
end)

net.Receive("StartClimb", function( l )
	LocalPlayer().StartTime = CurTime()
	LocalPlayer().Safe = true
	LocalPlayer().EndTime = nil
	LocalPlayer().ThirdPerson = false
	
	net.Start("SendTime")
		net.WriteFloat(CurTime())
	net.SendToServer()
end)

net.Receive("ResumeClimb", function( l )
	local Time = tonumber(net.ReadFloat())
	
	LocalPlayer().StartTime = LocalPlayer().StartTime + Time
end)

net.Receive("UpdatePlayerTime", function( l )
	local SteamID, Time = net.ReadString(), tonumber(net.ReadFloat())
	
	CLIMB_PLAYERS[SteamID] = CLIMB_PLAYERS[SteamID] - Time
end)

net.Receive("PlayerTimes", function( l )
	CLIMB_PLAYERS = net.ReadTable() or {}
end)

net.Receive("EndClimb", function( l )
	LocalPlayer().EndTime = CurTime()
end)

net.Receive("ClientSaves", function( l )
	LocalPlayer().Saves = net.ReadString()
end)

net.Receive("ClimbMenu", function( l )
	ClimbMenu()
end)

net.Receive("ConfirmMenu", function( l )
	ConfirmMenu(net.ReadString(), net.ReadString())
end)

net.Receive("SendTop10", function( l )
	CLIMB_MAPTOP10 = net.ReadTable() or {}
end)
