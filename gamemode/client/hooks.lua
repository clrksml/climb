
ShowScoreBoard = false
function GM:ScoreboardShow()
	if CLIMB_SCOREBOARD then return end
	if !ShowScoreBoard then
		GAMEMODE:DrawScoreboard()
		ShowScoreBoard = true
	end
end

function GM:ScoreboardHide()
	if CLIMB_SCOREBOARD then return end
	if ShowScoreBoard then
		ShowScoreBoard = false
	end
end

function GM:PlayerBindPress( p, b, pr )
	if string.find(b, "menu") and !LocalPlayer().ThirdPersonDisabled  then
		if !LocalPlayer().ThirdPerson then
			LocalPlayer().ThirdPerson = true
		else
			LocalPlayer().ThirdPerson = false
		end
	end
	
	if string.find(b, "attack2") and !LocalPlayer().MouseDisabled then
		net.Start("LastSave")
		net.SendToServer()
	elseif string.find(b, "attack") and !LocalPlayer().MouseDisabled then
		net.Start("AddSave")
		net.SendToServer()
	end
	
	if string.find(b, "slot1") then
		net.Start("AddSave")
		net.SendToServer()
	elseif string.find(b, "slot2") then
		net.Start("LastSave")
		net.SendToServer()
	elseif string.find(b, "slot3") then
		net.Start("PrevSave")
		net.SendToServer()
	elseif string.find(b, "slot4") then
		net.Start("NextSave")
		net.SendToServer()
	elseif string.find(b, "slot5") then
		net.Start("Pause")
		net.SendToServer()
	elseif string.find(b, "slot6") then
		if LocalPlayer():GetNWBool("paused", false) then LocalPlayer():ChatPrint("Please unpause before trying to play.") return end
		ConfirmMenu("Restart", "Restart your climb?")
	end
end

function GM:ShouldDrawLocalPlayer()
	if LocalPlayer().ThirdPerson and !LocalPlayer().ThirdPersonDisabled then
		return true
	end
end

function GM:CalcView(ply, pos, angles, fov)
	if LocalPlayer().ThirdPerson and !LocalPlayer().ThirdPersonDisabled then
		local view = {}
		
		view.angles = Angle(90, angles.yaw, angles.roll)
		view.origin = pos - (view.angles:Forward() * 250)
		view.fox = fov
		
		return view
	end
end
