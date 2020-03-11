
function ClimbMenu( )
	local DPanel1 = vgui.Create("DFrame")
	DPanel1:SetSize(200, 100)
	DPanel1:Center()
	DPanel1:SetTitle("Climb Settings")
	DPanel1:MakePopup()
	DPanel1:ShowCloseButton(false)
	DPanel1:SetSizable(false)
	DPanel1:SetDraggable(false)
	DPanel1:SetMouseInputEnabled(true)
	DPanel1:SetKeyBoardInputEnabled(false)
	DPanel1.Paint = function()
		draw.RoundedBox(4, 0, 0, DPanel1:GetWide(), DPanel1:GetTall(), Color(40, 40, 40))
	end
	
	local DImageButton1 = vgui.Create("DImageButton", DPanel1)
	DImageButton1:SetPos(DPanel1:GetWide() - 21, 5)
	DImageButton1:SetImage("icon16/exit.png")
	DImageButton1:SizeToContents()
	DImageButton1.DoClick = function() DPanel1:Remove() end
	
	local DCheckBox1 = vgui.Create("DCheckBoxLabel", DPanel1)
	DCheckBox1:SetPos(10, 30)
	DCheckBox1:SetText("Disable Mouse Binds")
	if !LocalPlayer().MouseDisabled then
		DCheckBox1:SetValue(0)
	else
		DCheckBox1:SetValue(1)
	end
	DCheckBox1.OnChange = function()
		if !LocalPlayer().MouseDisabled then
			LocalPlayer().MouseDisabled = true
		else
			LocalPlayer().MouseDisabled = false
		end
	end
	DCheckBox1:SizeToContents()
	
	local DCheckBox2 = vgui.Create("DCheckBoxLabel", DPanel1)
	DCheckBox2:SetPos(10, 55)
	DCheckBox2:SetText("Disable Third Person Bind")
	if !LocalPlayer().ThirdPersonDisabled then
		DCheckBox2:SetValue(0)
	else
		DCheckBox2:SetValue(1)
	end
	DCheckBox2.OnChange = function()
		if !LocalPlayer().ThirdPersonDisabled then
			LocalPlayer().ThirdPersonDisabled = true
		else
			LocalPlayer().ThirdPersonDisabled = false
		end
	end
	DCheckBox2:SizeToContents()
	
	local DCheckBox3 = vgui.Create("DCheckBoxLabel", DPanel1)
	DCheckBox3:SetPos(10, 80)
	DCheckBox3:SetText("Disable Voice Chat")
	if GetConVarNumber("voice_enable") == 1 then
		DCheckBox3:SetValue(0)
	else
		DCheckBox3:SetValue(1)
	end
	DCheckBox3.OnChange = function()
		if GetConVarNumber("voice_enable") == 1 then
			RunConsoleCommand("voice_enable", 0)
		else
			RunConsoleCommand("voice_enable", 1)
			RunConsoleCommand("+voicerecord")
			
			timer.Simple(0.2, function()
				RunConsoleCommand("-voicerecord")
			end)
		end
	end
	DCheckBox3:SizeToContents()
end

function ConfirmMenu( Title, Paragraph )
	gui.EnableScreenClicker(true)
	
	local Panel = vgui.Create("DPanel")
	Panel:SetSize(375, 200)
	Panel:SetPos(ScrW() / 2 - 187, ScrH() / 2 -112)
	Panel.Paint = function()
		draw.RoundedBox(2, 0, 0, 375, 200, Color(40, 40, 40))
	end
	
	local CloseImageButton = vgui.Create("DImageButton", Panel)
	CloseImageButton:SetSize(24, 24)
	CloseImageButton:SetPos(345, 15)
	CloseImageButton:SetImage("icon16/exit.png")
	CloseImageButton:SizeToContents()
	CloseImageButton.DoClick = function()
		gui.EnableScreenClicker(false)
		
		Panel:Remove()
	end
	
	local NoticeImage = vgui.Create("DImage", Panel)
	NoticeImage:SetSize(24, 24)
	NoticeImage:SetPos(10, 15)
	NoticeImage:SetImage("icon16/error.png")
	NoticeImage:SizeToContents()
	
	local DTitle = vgui.Create("DLabel", Panel)
	DTitle:SetSize(200, 25)
	DTitle:SetPos(35, 10)
	DTitle:SetText(Title)
	DTitle:SetFont("Trebuchet24")
	DTitle:SizeToContents()
	
	local DText = vgui.Create("DLabel", Panel)
	DText:SetSize(355, 75)
	DText:SetPos(10, 40)
	DText:SetText(Paragraph)
	DText:SetFont("Trebuchet24")
	DText.Paint = function()
		draw.RoundedBox(2, 0, 0, 355, 75, Color(0, 0, 0, 0))
	end
	
	local DPanel2 = vgui.Create("DPanel", Panel)
	DPanel2:SetSize(340, 4)
	DPanel2:SetPos(15, 125)
	DPanel2.Paint = function()
		draw.RoundedBox(2, 0, 0, 340, 15, Color(45, 45, 45))
	end
	
	local YesButton = vgui.Create("DButton", Panel)
	YesButton:SetSize(70, 34)
	YesButton:SetPos(190, 145)
	YesButton:SetText("")
	YesButton.Paint = function()
		surface.SetFont("Trebuchet24")
		local w, h = surface.GetTextSize("Yes")
		
		draw.WordBox(4, (YesButton:GetWide() / 2) - (w / 2), (YesButton:GetTall() / 2) - (h / 2), "Yes", "Trebuchet24", Color(48, 48, 48), Color(255, 255, 255))
	end
	YesButton.DoClick = function()
		if string.find(Title, "Restart") then
			net.Start("Restart")
			net.SendToServer()
		end
		
		gui.EnableScreenClicker(false)
		surface.PlaySound("UI/buttonclick.wav")
		
		Panel:Remove()
	end
	
	local NoButton = vgui.Create("DButton", Panel)
	NoButton:SetSize(70, 34)
	NoButton:SetPos(275, 145)
	NoButton:SetText("")
	NoButton.Paint = function()
		surface.SetFont("Trebuchet24")
		local w, h = surface.GetTextSize("Yes")
		
		draw.WordBox(4, (NoButton:GetWide() / 2) - (w / 2), (NoButton:GetTall() / 2) - (h / 2), "No", "Trebuchet24", Color(48, 48, 48), Color(255, 255, 255))
	end
	NoButton.DoClick = function()
		gui.EnableScreenClicker(false)
		surface.PlaySound("UI/buttonclickrelease.wav")
		
		Panel:Remove()
	end
end
