
local nodraw = {"CHudDeathNotice", "CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo", "CHudCrosshair", "CHudDamageIndicator", "CHudWeaponSelection"}
function GM:HUDShouldDraw( name )
	if table.HasValue(nodraw, name) then
		return false
	end
	return true
end

function GM:HUDPaint()
	if LocalPlayer().Safe then
		DrawPlayerInfo()
	end
	DrawSelectionMenu()
end

function DrawPlayerInfo()
	local time = 0
	local ply = LocalPlayer():GetEyeTrace().Entity
	
	if ply:IsValid() and ply:IsPlayer() and ply != LocalPlayer() then
		if !CLIMB_PLAYERS or table.Count(CLIMB_PLAYERS) == 0 then
			draw.DrawText(ply:Nick(), "DermaLarge", ScrW() / 2, ScrH() / 2, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
		elseif ply:GetNWBool("finished", false) then
			draw.DrawText(ply:Nick(), "DermaLarge", ScrW() / 2, ScrH() / 2, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
			draw.DrawText("Finished", "DermaLarge", ScrW() / 2, ScrH() / 2 + 25, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
		else
			if CLIMB_PLAYERS[ply:SteamID()] and LocalPlayer():SteamID() != ply:SteamID() then
				local time = CurTime() - tonumber(CLIMB_PLAYERS[ply:SteamID()])
				
				if time == CurTime() then
					time = CurTime()
				elseif time > CurTime() then
					time = tonumber(CLIMB_PLAYERS[ply:SteamID()]) - CurTime()
				else
					time = CurTime() - tonumber(CLIMB_PLAYERS[ply:SteamID()])
				end
				draw.DrawText(ply:Nick(), "DermaLarge", ScrW() / 2, ScrH() / 2, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
				draw.DrawText(string.ToMinutesSeconds(tonumber(time or 0)), "DermaLarge", ScrW() / 2, ScrH() / 2 + 25, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
			else
				draw.DrawText(ply:Nick(),  "DermaLarge", ScrW() / 2, ScrH() / 2, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
			end
		end
	end
end

function DrawSelectionMenu()
	local time = 0
	
	if !LocalPlayer().StartTime then
		time = string.ToMinutesSeconds(CurTime() - CurTime())
	else
		time = string.ToMinutesSeconds(CurTime() - LocalPlayer().StartTime)
	end
	
	if LocalPlayer().EndTime then
		time = string.ToMinutesSeconds(LocalPlayer().EndTime - LocalPlayer().StartTime)
	end
	
	// Climb Time
	draw.RoundedBox(4, 2, 1, 125, 50, Color(0, 0, 0, 200))
	
	if !LocalPlayer():GetNWBool("paused", false) then
		draw.SimpleText(time, "DermaLarge", 26, 10, Color(220, 220, 220), 0, 0)
	else
		draw.SimpleText("PAUSED", "DermaLarge", 8, 10, Color(220, 220, 220), 0, 0)
	end
	
	// Save
	if input.IsKeyDown(KEY_1) or input.IsMouseDown(MOUSE_LEFT) and !LocalPlayer().MouseDisabled then
		draw.RoundedBox(4, 2, 52, 25, 25, Color(0, 220, 0, 200))
		draw.SimpleText("1", "Trebuchet24", 8, 52, Color(200, 200, 200), 0, 0)
		
		draw.RoundedBox(4, 26, 52, 100, 25, Color(0, 0, 0, 200))
		draw.SimpleText("Save", "Trebuchet24", 30, 52, Color(0, 220, 0), 0, 0)
	else
		draw.RoundedBox(4, 2, 52, 25, 25, Color(200, 200, 200, 200))
		draw.SimpleText("1", "Trebuchet24", 8, 52, Color(200, 200, 200), 0, 0)
		
		draw.RoundedBox(4, 26, 52, 100, 25, Color(0, 0, 0, 200))
		draw.SimpleText("Save", "Trebuchet24", 30, 52, Color(200, 200, 200), 0, 0)
	end
	
	// Last
	if input.IsKeyDown(KEY_2) or input.IsMouseDown(MOUSE_RIGHT) and !LocalPlayer().MouseDisabled then
		draw.RoundedBox(4, 2, 78, 25, 25, Color(0, 220, 0, 200))
		draw.SimpleText("2", "Trebuchet24", 8, 78, Color(200, 200, 200), 0, 0)
		
		draw.RoundedBox(4, 26, 78, 100, 25, Color(0, 0, 0, 200))
		draw.SimpleText("Last", "Trebuchet24", 30, 78, Color(0, 220, 0), 0, 0)
	else
		draw.RoundedBox(4, 2, 78, 25, 25, Color(200, 200, 200, 200))
		draw.SimpleText("2", "Trebuchet24", 8, 78, Color(200, 200, 200), 0, 0)
		
		draw.RoundedBox(4, 26, 78, 100, 25, Color(0, 0, 0, 200))
		draw.SimpleText("Last", "Trebuchet24", 30, 78, Color(200, 200, 200), 0, 0)
	end
	
	// Previous
	if input.IsKeyDown(KEY_3) then
		draw.RoundedBox(4, 2, 104, 25, 25, Color(0, 220, 0, 200))
		draw.SimpleText("3", "Trebuchet24", 8, 104, Color(200, 200, 200), 0, 0)
		
		draw.RoundedBox(4, 26, 104, 100, 25, Color(0, 0, 0, 200))
		draw.SimpleText("Prev", "Trebuchet24", 30, 104, Color(0, 220, 0, 200), 0, 0)
	else
		draw.RoundedBox(4, 2, 104, 25, 25, Color(200, 200, 200, 200))
		draw.SimpleText("3", "Trebuchet24", 8, 104, Color(200, 200, 200), 0, 0)
		
		draw.RoundedBox(4, 26, 104, 100, 25, Color(0, 0, 0, 200))
		draw.SimpleText("Prev", "Trebuchet24", 30, 104, Color(200, 200, 200), 0, 0)
	end
	
	// Next
	if input.IsKeyDown(KEY_4) then
		draw.RoundedBox(4, 2, 130, 25, 25, Color(0, 220, 0, 200))
		draw.SimpleText("4", "Trebuchet24", 8, 130, Color(200, 200, 200), 0, 0)
		
		draw.RoundedBox(4, 26, 130, 100, 25, Color(0, 0, 0, 200))
		draw.SimpleText("Next", "Trebuchet24", 30, 130, Color(0, 220, 0, 200), 0, 0)
	else
		draw.RoundedBox(4, 2, 130, 25, 25, Color(200, 200, 200, 200))
		draw.SimpleText("4", "Trebuchet24", 8, 130, Color(200, 200, 200), 0, 0)
		
		draw.RoundedBox(4, 26, 130, 100, 25, Color(0, 0, 0, 200))
		draw.SimpleText("Next", "Trebuchet24", 30, 130, Color(200, 200, 200), 0, 0)
	end
	
	// Pause
	if input.IsKeyDown(KEY_5) then
		draw.RoundedBox(4, 2, 156, 25, 25, Color(0, 220, 0, 200))
		draw.SimpleText("5", "Trebuchet24", 8, 156, Color(200, 200, 200), 0, 0)
		
		draw.RoundedBox(4, 26, 156, 100, 25, Color(0, 0, 0, 200))
		draw.SimpleText("Pause", "Trebuchet24", 30, 156, Color(0, 220, 0, 200), 0, 0)
	else
		draw.RoundedBox(4, 2, 156, 25, 25, Color(200, 200, 200, 200))
		draw.SimpleText("5", "Trebuchet24", 8, 156, Color(200, 200, 200), 0, 0)
		
		draw.RoundedBox(4, 26, 156, 100, 25, Color(0, 0, 0, 200))
		draw.SimpleText("Pause", "Trebuchet24", 30, 156, Color(200, 200, 200), 0, 0)
	end
	
	// Restart
	if input.IsKeyDown(KEY_6) then
		draw.RoundedBox(4, 2, 182, 25, 25, Color(0, 220, 0, 200))
		draw.SimpleText("6", "Trebuchet24", 8, 182, Color(200, 200, 200), 0, 0)
		
		draw.RoundedBox(4, 26, 182, 100, 25, Color(0, 0, 0, 200))
		draw.SimpleText("Restart", "Trebuchet24", 30, 182, Color(0, 220, 0, 200), 0, 0)
	else
		draw.RoundedBox(4, 2, 182, 25, 25, Color(200, 200, 200, 200))
		draw.SimpleText("6", "Trebuchet24", 8, 182, Color(200, 200, 200), 0, 0)
		
		draw.RoundedBox(4, 26, 182, 100, 25, Color(0, 0, 0, 200))
		draw.SimpleText("Restart", "Trebuchet24", 30, 182, Color(200, 200, 200), 0, 0)
	end
end
