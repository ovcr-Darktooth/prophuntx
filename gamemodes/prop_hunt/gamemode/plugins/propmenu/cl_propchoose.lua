PCR.PropList = {}

hook.Add("InitPostEntity", "pcr.RequestPropData", function()
	net.Start("pcr.ClientRequestPropData")
	net.SendToServer()
end)

net.Receive("pcr.PropListData", function()
	PCR.PropList = {}

	local total = net.ReadUInt(32)
	local data  = net.ReadData(total)
	local model = util.JSONToTable(util.Decompress(data))
    
    if !model or model == nil then
        local err = "[!!PHX Prop Menu] Error: We got empty prop list. Something terribly went wrong with Networking!!!"
        chat.AddText(Color(255,0,0), err)
        MsgC(Color(255,0,0), err.."\n")
        return
    end
    
	for i=1,#model do
		table.insert(PCR.PropList, model[i])
	end
end)

net.Receive("pcr.EditorCustomData", function()
	PCR.CustomProp = {}

	local total = net.ReadUInt(32)
	local data = net.ReadData(total)
	
	local model = util.JSONToTable(util.Decompress(data))
	for i=1,#model do
		table.insert(PCR.CustomProp, model[i])
	end
end)

if ( PHX:GetCVar( "pcr_notify_messages" ) ) then
	timer.Create("pcrT.NotifyAddon", math.random(70,120), math.random(4,10), function()
		chat.AddText( Color(10,235,235), "[PHX Prop Menu]", Color(220,220,220), PHX:FTranslate("PCR_NOTIFY_1", PCR._VERSION), Color(235,235,0), "\"pcr_help\"" , Color(220,220,220), PHX:FTranslate("PCR_NOTIFY_2") )
	end)
end

-- Add 'PropChooser Help' menu on F1 selection screen.
hook.Add("PH_AddSplashHelpButton", "PCR.AddSplashScreen", function(helpUI)
	local help = helpUI:AddSelectButton(PHX:FTranslate("PCR_BTN_HELP_MENU"), function()
		PCR.openTutorialWindow()
	end)
	help.m_colBackground = Color(165,100,235)
end)

local f = {}
f.uselimit  = 0 -- init the usage limit.
function PCR:MainWindow() --arg: ls
    
    local str = "0"
    local ls = self.PropList
    
    if !ls or ls == nil then
        ErrorNoHalt("[Prop Menu: Error] PropList appears to be empty. Try reconnecting to retreive the data.")
        return
    end
    
    f.frame = vgui.Create("DFrame")
    f.frame:SetPos(30,25)
    f.frame:SetSize(400,ScrH()-45)
    f.frame:SetTitle(PHX:FTranslate("PCR_WINDOW_TITLE"))
    f.frame:SetVisible(true)
    f.frame:ShowCloseButton(true)
    f.frame:SetDeleteOnClose(false) --update: don't delete the pannel upon calling :Close()
    f.frame:SetMouseInputEnabled(true)
    f.frame:SetKeyboardInputEnabled(true)
    
    f.frame:SetDraggable(true)
    
    -- top panel --
    f.panel = vgui.Create("DPanel",f.frame)
    f.panel:Dock(TOP)
    f.panel:SetSize(0,72)
    f.panel:DockMargin(8,4,8,0)
    f.panel:SetBackgroundColor(Color(64,64,64))
    
    -- container of top panel --	
    local font = "Trebuchet24"
    local font2 = "HudHintTextLarge"
    f.panel.PaintOver = function(self,w,h)
        if f.uselimit <= -1 then str = PHX:Translate("PCR_UNLIMIT_TEXT") end
        if f.uselimit > 0 then str = tostring(f.uselimit) end
    
        surface.SetFont(font)
        draw.DrawText(PHX:FTranslate("PCR_HEADER_TOP"),font2,w/2,h/2-32,Color(200,200,200),TEXT_ALIGN_CENTER)
        draw.DrawText(PHX:FTranslate("PCR_HEADER_MID", str),font,w/2,h/2-16,Color(255,255,30),TEXT_ALIGN_CENTER)
        draw.DrawText(PHX:FTranslate("PCR_HEADER_BOTTOM"),font2,w/2,h/2+12,Color(200,200,200),TEXT_ALIGN_CENTER)
    end
    
    -- body panel --
    f.body = vgui.Create("DPanel",f.frame)
    f.body:Dock(FILL)
    f.body:DockMargin(8,4,8,4)
    
    f.gridscrl = vgui.Create("DScrollPanel", f.body)
    f.gridscrl:Dock(FILL)
    f.gridscrl:DockMargin(4,2,4,2)
    
    -- container of body --
    f.grid = vgui.Create("DGrid",f.gridscrl)
    f.grid:SetPos(10,10)
    f.grid:SetSize(f.gridscrl:GetWide(),f.gridscrl:GetTall())
    f.grid:SetCols(5)
    f.grid:SetColWide(67)
    f.grid:SetRowHeight(66)
    f.grid:SetVerticalScrollbarEnabled(true)
    
    for _,p in pairs(ls) do
        local pan = vgui.Create("DPanel")
        local tooltext = PHX:FTranslate( "PCR_CL_TOOLTIP_MODEL", p )
        pan:SetSize(64,64)
        if table.HasValue( PHX.BANNED_PROP_MODELS, p ) then
            tooltext = PHX:FTranslate("PCR_CL_TOOLTIP_BANNED")
            pan:SetBackgroundColor(Color(120,20,20))
        else
            pan:SetBackgroundColor(Color(100,100,100))
        end
        
        local icon = vgui.Create("SpawnIcon",pan)
        icon:SetModel(Model(p))
        icon:SetSize(64,64)
        icon:SetToolTip(tooltext)
        
        icon.DoClick = function()
            net.Start("pcr.SetMetheProp")
            net.WriteString(p)
            net.SendToServer()
            f.frame:Close()
        end
        
        if LocalPlayer():CheckUserGroup() or LocalPlayer():IsSuperAdmin() then
            icon.DoRightClick = function()
                local m = DermaMenu()
                m:AddOption("Copy Model", function() SetClipboardText( p ) end):SetIcon("icon16/page_copy.png")
                m:Open()
                
                -- This is place holder. The idea is that, you can mark and add prop ban from here.
                -- This idea scrapped, but will be included later in future update/PH:Z
            end
        end
        
        f.grid:AddItem(pan)
    end
    
    f.frame.OnClose = function( self )
        self.currentlyOpen = false
    end
    
    f.currentlyOpen = true
    f.frame:MakePopup()
    f.frame:SetKeyboardInputEnabled(false)
    
end

function PCR:OpenPropMenu()
    -- do basic checks
    if !PHX:GetCVar( "pcr_enable" ) then
		chat.AddText(Color(235,10,15), "[PHX Prop Menu]", Color(220,220,220), PHX:FTranslate("PCR_CL_DISABLED"))
		return
	end
	
	if PHX:GetCVar( "pcr_only_allow_certain_groups" ) and !self:CheckUserGroup( LocalPlayer() ) then
		chat.AddText(Color(235,10,15), "[PHX Prop Menu]", Color(220,220,220), PHX:FTranslate("PCR_CL_GROUP"))
		return
	end
    
    if !LocalPlayer():Alive() && LocalPlayer():Team() ~= TEAM_PROPS && !GetGlobalBool("InRound",false) then
        chat.AddText(Color(10,235,30), "[PHX Prop Menu]", Color(220,220,220), PHX:FTranslate("PCR_CL_MENU_NOTREADY"))
        return
    end
    -- end of basic checks
    
    f.uselimit = LocalPlayer():CheckUsage()
    if f.uselimit == 0 then
        chat.AddText(Color(10,235,30), "[PHX Prop Menu]", Color(220,220,220), PHX:FTranslate("PCR_CL_LIMIT"))
        
        if f.frame and f.frame ~= nil and ispanel(f.frame) and f.frame:IsValid() then
            f.frame:SetDeleteOnClose( true )
            f.frame:Close()
            f.currentlyOpen = false
        end
        
        return
    end
    
    if (f.frame == nil or !IsValid(f.frame)) then
        -- Create a window first.
        self:MainWindow(self.PropList)
        return
    end
    
    -- Allow toggle and make sure f.frame is a panel.
    if f.frame and f.frame ~= nil and ispanel(f.frame) and f.frame:IsValid() then
        if (!f.currentlyOpen or !f.frame:IsVisible()) then
            f.frame:SetVisible(true)
        else
            f.frame:Close()
        end
    end
end

concommand.Add("ph_prop_menu", function()
	if PHX:GetCVar( "pcr_use_ulx_menu" ) then
		chat.AddText(Color(235,20,20), "[PHX Prop Menu]", Color(220,220,220), PHX:FTranslate("PCR_CL_CMDUSEULX"))
	else
		PCR:OpenPropMenu()
	end
end)

net.Receive("pcr.ForceCloseMenu", function()
	if f.frame and f.frame ~= nil and ispanel(f.frame) and f.frame:IsValid() then
        f.frame:SetDeleteOnClose( true )
		f.frame:Close()
        f.currentlyOpen = false
	end
end)

function PCR.openTutorialWindow()

	local f = {}
		
	f.frame = vgui.Create("DFrame")
	f.frame:SetPos(0,0)
	f.frame:SetSize(970, 556)
	f.frame:SetTitle(PHX:FTranslate( "PCR_WINDOW_GUIDE_TTL" ))
	f.frame:SetVisible(true)
	f.frame:ShowCloseButton(true)
	f.frame:SetMouseInputEnabled(true)
	f.frame:SetKeyboardInputEnabled(true)
	f.frame:Center()
	
	f.frame:SetDraggable(false)
	
	f.image = vgui.Create("DImage",f.frame)
	f.image:SetImage("pcr/idbs_guide")
	f.image:Dock(FILL)
	
	f.frame:MakePopup()
	f.frame:SetKeyboardInputEnabled(false)
	
end