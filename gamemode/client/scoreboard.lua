
function GM:AddPlayer( ply, pnl, pnl2, y )
	if CLIMB_SCOREBOARD then return end
	
	local PlayerPanel = vgui.Create("DPanel", pnl)
	PlayerPanel:SetPos(0, y)
	PlayerPanel:SetSize(600, 28)
	PlayerPanel.Color = team.GetColor(ply:Team())
	PlayerPanel.Paint = function()
		draw.RoundedBox(4, 0, 0, PlayerPanel:GetWide(), PlayerPanel:GetTall(), PlayerPanel.Color)
		
		draw.DrawText(ply:Nick(), "CloseCaption_Normal", 32, 1, Color(255, 255, 255), TEXT_ALIGN_LEFT)
		
		local w, h = surface.GetTextSize("Finished")
		
		if ply:GetNWBool("finished", false) then
			w, h = surface.GetTextSize("Finished")
			
			draw.DrawText("Finished", "CloseCaption_Normal", (PlayerPanel:GetWide() / 2) - (w / 2), 1, Color(255, 255, 255), TEXT_ALIGN_LEFT)
		elseif ply:GetNWBool("paused", false) then
			w, h = surface.GetTextSize("Paused")
			
			draw.DrawText("Paused", "CloseCaption_Normal", (PlayerPanel:GetWide() / 2) - (w / 2), 1, Color(255, 255, 255), TEXT_ALIGN_LEFT)
		else
			if LocalPlayer():SteamID() == ply:SteamID() then
				w, h = surface.GetTextSize(string.ToMinutesSeconds(CurTime() - LocalPlayer().StartTime))
				
				draw.DrawText(string.ToMinutesSeconds(CurTime() - LocalPlayer().StartTime), "CloseCaption_Normal", (PlayerPanel:GetWide() / 2) - (w / 2), 1, Color(255, 255, 255), TEXT_ALIGN_LEFT)
			elseif CLIMB_PLAYERS[ply:SteamID()] and LocalPlayer():SteamID() != ply:SteamID() then
				local time = CurTime() - CLIMB_PLAYERS[ply:SteamID()]
				
				if time == CurTime() then
					time = CurTime()
				elseif time > CurTime() then
					time = CLIMB_PLAYERS[ply:SteamID()] - CurTime()
				else
					time = CurTime() - CLIMB_PLAYERS[ply:SteamID()]
				end
				
				w, h = surface.GetTextSize(string.ToMinutesSeconds(time))
				
				draw.DrawText(string.ToMinutesSeconds(time), "CloseCaption_Normal", (PlayerPanel:GetWide() / 2) - (w / 2), 1, Color(255, 255, 255), TEXT_ALIGN_LEFT)
			else
				w, h = surface.GetTextSize("00:00")
				
				draw.DrawText("00:00", "CloseCaption_Normal", (PlayerPanel:GetWide() / 2) - (w / 2), 1, Color(255, 255, 255), TEXT_ALIGN_LEFT)
			end
		end
		
		w, h = surface.GetTextSize(ply:GetNWInt("saves", 0))
		
		draw.DrawText(ply:GetNWInt("saves", 0), "CloseCaption_Normal", (PlayerPanel:GetWide() / 1.375) - (w / 2), 1, Color(255, 255, 255), TEXT_ALIGN_LEFT)
		
		w, h = surface.GetTextSize(ply:Ping())
		
		draw.DrawText(ply:Ping(), "CloseCaption_Normal", PlayerPanel:GetWide() - 38 - w, 1, Color(255, 255, 255), TEXT_ALIGN_LEFT)
	end
	
	local PlayerAvatar = vgui.Create("AvatarImage", PlayerPanel)
	PlayerAvatar:SetPos(4, 2)
	PlayerAvatar:SetSize(24, 24)
	PlayerAvatar:SetPlayer(ply, 24)
	
	local PlayerButton = vgui.Create("DButton", PlayerPanel)
	PlayerButton:SetPos(4, 2)
	PlayerButton:SetText("")
	PlayerButton:SetSize(24, 24)
	PlayerButton.OnCursorEntered = function()
		PlayerPanel.Color = Color(50, 50, 50)
	end
	PlayerButton.OnCursorExited = function()
		PlayerPanel.Color = team.GetColor(ply:Team())
	end
	PlayerButton.Paint = function()
		surface.SetDrawColor(Color(0, 0, 0, 0))
		surface.DrawRect(0, 0, PlayerButton:GetWide(), PlayerButton:GetTall())
	end
	PlayerButton.DoClick = function()
		timer.Simple(1, function()
			gui.OpenURL("http://steamcommunity.com/profiles/" .. ply:SteamID64())
		end)
	end
	
	local PlayerMuteButton = vgui.Create("DImageButton", PlayerPanel)
	PlayerMuteButton:SetSize(24, 24)
	PlayerMuteButton:SetPos(PlayerPanel:GetWide() - 28, 4)
	PlayerMuteButton:SetImage("icon16/sound.png")
	PlayerMuteButton:SetToolTip("Mute Player")
	PlayerMuteButton.Think = function()
		if ply:IsMuted() then
			PlayerMuteButton:SetImage("icon16/sound_mute.png")
		else
			PlayerMuteButton:SetImage("icon16/sound.png")
		end
	end
	PlayerMuteButton.DoClick = function()
		if ply:IsMuted() then
			ply:SetMuted(true)
			PlayerMuteButton:SetImage("icon16/sound_mute.png")
		else
			ply:SetMuted(true)
			PlayerMuteButton:SetImage("icon16/sound.png")
		end
	end
	
	pnl:SetSize(620, math.Clamp(y + 29, y + 29, ScrH() - 30))
	
	pnl2:SizeToChildren(false, true)
	pnl2:Center()
	
	return PlayerPanel
end

function GM:DrawScoreboard()
	if CLIMB_SCOREBOARD then return end
	
	local ScoreboardFrame = vgui.Create("DFrame")
	ScoreboardFrame:SetSize(600, 180)
	ScoreboardFrame:Center()
	ScoreboardFrame:SetTitle("")
	ScoreboardFrame:MakePopup()
	ScoreboardFrame:ShowCloseButton(false)
	ScoreboardFrame:SetMouseInputEnabled(true)
	ScoreboardFrame:SetKeyBoardInputEnabled(false)
	ScoreboardFrame.Think = function()
		if !ShowScoreBoard then
			ScoreboardFrame:Close()
		end
	end
	ScoreboardFrame.Paint = function()
		draw.RoundedBox(4, 0, 0, ScoreboardFrame:GetWide(), ScoreboardFrame:GetTall(), Color(0, 0, 0, 200))
		
		surface.SetFont("CloseCaption_Bold")
		
		local w, h = surface.GetTextSize(GetHostName())
		
		draw.DrawText(GetHostName(), "CloseCaption_Bold", (ScoreboardFrame:GetWide() / 2) - (w / 2), 32 - (h / 2), Color(255, 255, 255), TEXT_ALIGN_LEFT)
		
		draw.DrawText("Name", "Trebuchet24", 32, 59, Color(255, 255, 255), TEXT_ALIGN_LEFT)
		
		surface.SetFont("Trebuchet24")
		w, h = surface.GetTextSize("Time")
		
		draw.DrawText("Time", "Trebuchet24", (ScoreboardFrame:GetWide() / 2) - (w / 2), 59, Color(255, 255, 255), TEXT_ALIGN_LEFT)
		
		w, h = surface.GetTextSize("Saves")
		
		draw.DrawText("Saves", "Trebuchet24", (ScoreboardFrame:GetWide() / 1.375) - (w / 2), 59, Color(255, 255, 255), TEXT_ALIGN_LEFT)
		
		w, h = surface.GetTextSize("Ping")
		
		draw.DrawText("Ping", "Trebuchet24", ScoreboardFrame:GetWide() - 38 - w, 59, Color(255, 255, 255), TEXT_ALIGN_LEFT)
	end
	
	local PlayerScrollList = vgui.Create("DScrollPanel", ScoreboardFrame)
	PlayerScrollList:SetPos(0, 60)
	PlayerScrollList:SetSize(620, 87)
	PlayerScrollList.Paint = function() end
	
	local y = 0
	for k, v in pairs(player.GetAll()) do
		y = y + 29
		GAMEMODE:AddPlayer(v, PlayerScrollList, ScoreboardFrame, y)
	end
	
	PlayerScrollList.OnChildAdded = function()
		PlayerScrollList:SetSize(620, math.Clamp(y + 29, y + 29, ScrH() - 30))
	end
end
