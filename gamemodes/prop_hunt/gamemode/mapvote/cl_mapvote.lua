taillemaps = {
    ["petites"] = {
        "ph_alley_x1",
        "ph_bunkier2",
        "ph_downbroke",
        -- "ph_grandparenthouse", -- pas sur le serveur
        -- "ph_estate", -- pas sur le serveur
        "ph_hallway_v2",
        "ph_hotel",
        -- "ph_motel_blacke_v3", -- pas sur le serveur
        "ph_infernaria",
        "ph_underlab_v2",
        "ph_winecellar",
        "ph_office",
        "ph_school",
        "ph_zombie_bunker_xmas",
        "ph_kakcasts",
        "ph_office221",
        "ph_apartments_2017",
        "ph_oceanwaves",
        "rp_japanschool",
        "ph_metrostation",
        "ph_indieoffice",
        "ph_teybar"
    },
    ["moyennes"] = {
        "ph_abandoned_motel_ks",
        "ph_bikinibottom",
        "ph_backyard",
        "ph_construction_site",
        "ph_contraband",
        "ph_elementary_school",
        "ph_chalet",
        "ph_chalet_night",
        "ph_fancyhouse",
        "ph_twoside",
        "ph_parkinglot",
        "ph_minecraft_awakening_a3",
        -- "ph_restaurant_2017_v2",
        "ph_gas_stationrc7",
        "ph_gas_stationrc7_xmas",
        "ph_islandhouse",
        "gm_littlegarden",
        "ph_littlegarden",
        "ph_lockup",
        "ph_warehouse_v2",
        "ph_modern_house",
        "ph_pirateship",
        "ph_lttp_kakariko_b2",
        "ph_manufactory",
        "ph_purity",
        "ph_academy20"--,
        -- "ph_beachhouse"
    },
    ["grandes"] = {
        "ph_awesomebuilding_xl_map",
        "ph_awesomewarehouse_night_map",
        "ph_bank",
        "ph_break_at_work",
        "ph_bitnanner_b",
        "ph_crashhouse",
        "ph_volcano_v1",
        "ph_csoffice__b2",
        "ph_holiday_gift",
        "ph_junkyard",
        -- "ph_restaurant_2019",
        -- "ph_restaurant_2020",
        "ph_starship",
        "ph_youturd",
        -- "ph_supermarket",
        "ph_octagon",
        "ph_villahouse_2014",
        "ph_halloweenhouse_v3",
        "ph_theater"
    },
    ["css"] = {
        "ph_csoffice__b2",
        "ph_hotel",
        "ph_octagon",
        "ph_bank",
    }
    }


surface.CreateFont("RAM_VoteFont", {
    font = "Trebuchet MS",
    size = 19,
    weight = 700,
    antialias = true,
    shadow = true
})

surface.CreateFont("RAM_VoteFontCountdown", {
    font = "Tahoma",
    size = 32,
    weight = 700,
    antialias = true,
    shadow = true
})

surface.CreateFont("RAM_VoteSysButton", 
{    font = "Marlett",
    size = 13,
    weight = 0,
    symbol = true,
})

MapVote.EndTime = 0
MapVote.Panel = false

net.Receive("RAM_MapVoteStart", function()
    MapVote.CurrentMaps = {
        ['petites'] = {},
        ['moyennes'] = {},
        ['grandes'] = {}
    }
    MapVote.Allow = true
    MapVote.Votes = {}
    
    -- local amt = net.ReadUInt(32)
    
    -- for i = 1, amt do
    --     local map = net.ReadString()
        
    --     MapVote.CurrentMaps[#MapVote.CurrentMaps + 1] = map
    -- end
    local nbMaps = net.ReadUInt(4)
    -- print(nbMaps)
    for i = 0,nbMaps-1,1 do
        MapVote.CurrentMaps['petites'][i] = net.ReadString()
        -- print("cl map recue : "..MapVote.CurrentMaps['petites'][i])
    end
    nbMaps = net.ReadUInt(4)
    -- print(nbMaps)
    for i = 0,nbMaps-1,1 do
        MapVote.CurrentMaps['moyennes'][i] = net.ReadString()
        -- print("cl map recue : "..MapVote.CurrentMaps['moyennes'][i])
    end
    nbMaps = net.ReadUInt(4)
    -- print(nbMaps)
    for i = 0,nbMaps-1,1 do
        MapVote.CurrentMaps['grandes'][i] = net.ReadString()
        -- print("cl map recue : "..MapVote.CurrentMaps['grandes'][i])
    end

    
    
    MapVote.EndTime = CurTime() + net.ReadUInt(32)
    
    if(IsValid(MapVote.Panel)) then
        MapVote.Panel:Remove()
    end
    
    MapVote.Panel = vgui.Create("VoteScreen")
    -- MapVote.Panel:SetMaps(lesMaps)
    MapVote.Panel:SetMaps(MapVote.CurrentMaps)
end)

net.Receive("RAM_MapVoteUpdate", function()
    local update_type = net.ReadUInt(3)
    local paspresent=false
    if(update_type == MapVote.UPDATE_VOTE) then
        local ply = net.ReadEntity()
        if(IsValid(ply)) then
            local map_id = net.ReadUInt(32)
            local taille = net.ReadString()
            if (!MapVote.Votes[ply:SteamID()]) then
                paspresent=true
                -- print("paspresent")
                -- print(map_id)
                -- print(taille)
            else
                -- print("present")
                -- print(MapVote.Votes[ply:SteamID()][1])
                -- print(MapVote.Votes[ply:SteamID()][2])
                -- print("nouveaux")
                -- print(map_id)
                -- print(taille)
            end  
            

            
            MapVote.Votes[ply:SteamID()] = {map_id,taille}
            -- print("call addvoter via netreceive")
            MapVote.Panel:AddVoter(ply,taille,map_id)


            
        end
    elseif(update_type == MapVote.UPDATE_WIN) then
        local mapgagnante = net.ReadUInt(32)
        if(IsValid(MapVote.Panel)&&mapgagnante!=999) then
            MapVote.Panel:Flash(mapgagnante)
        end
    end
end)

net.Receive("RAM_MapVoteCancel", function()
    if IsValid(MapVote.Panel) then
        MapVote.Panel:Remove()
    end
end)

net.Receive("RTV_Delay", function()
    chat.AddText(Color( 102,255,51 ), "[RTV]", Color( 255,255,255 ), " The vote has been rocked, map vote will begin on round end")
end)

local PANEL = {}

function PANEL:Init()
    self:ParentToHUD()
    
    --Conteneur
    self.Canvas = vgui.Create("Panel", self)
    self.Canvas:MakePopup()
    self.Canvas:SetKeyboardInputEnabled(false)
    self.Canvas:SetMouseInputEnabled(true)
    
    --Temps pour voter
    self.countDown = vgui.Create("DLabel", self.Canvas)
    self.countDown:SetTextColor(color_white)
    self.countDown:SetFont("RAM_VoteFontCountdown")
    self.countDown:SetText("")
    self.countDown:SetPos(0, 14)

    --Image grossie de la map hovered
    self.imagemapB = vgui.Create("DImage", self)
    self.imagemapB:SetImage("vgui/avatar_default")
    self.imagemapB:SetSize(450,450)
    self.imagemapB:SetPos(0,220)
    self.imagemapB:SetZPos(-32768)
    aTransparence= false

    self.imagemapB.Think = function()
        if aTransparence then
            self.imagemapB:SetAlpha(self.imagemapB:GetAlpha()-1)
            if (self.imagemapB:GetAlpha()<=0) then
                aTransparence = false
            end
        end 
    end

    --Explications CSS
    --Image
    self.css = vgui.Create("DImage", self.Canvas)
    self.css:SetImage("icon16/cog.png")
    self.css:SetSize(24,24)
    self.css:SetPos(640,55)
    
    --Texte
    self.csstext = vgui.Create("DLabel", self.Canvas)
    self.csstext:SetText(": CSS Textures")
    self.csstext:SetSize(300,30)
    self.csstext:SetPos(670,50)
    self.csstext:SetTextColor(Color(244, 13, 248))
    self.csstext:SetFont("RAM_VoteFontCountdown")
   
    
    --Petites maps
    self.petites = vgui.Create("DLabel", self.Canvas)
    self.petites:SetText("Maps petites :")
    self.petites:SetSize(300,30)
    self.petites:SetPos(0,50)
    self.petites:SetTextColor(color_white)
    self.petites:SetFont("RAM_VoteFontCountdown")
    self.mapList = vgui.Create("DPanelList", self.Canvas)
    self.mapList:SetName("petites")
    self.mapList:SetDrawBackground(false)
    self.mapList:SetSpacing(4)
    self.mapList:SetPadding(4)
    -- self.mapList:SetPos(0,80)
    self.mapList:EnableHorizontal(true)
    self.mapList:EnableVerticalScrollbar()

    --Moyennes maps
    self.moyennes = vgui.Create("DLabel", self.Canvas)
    self.moyennes:SetText("Maps moyennes :")
    self.moyennes:SetSize(500,30)
    self.moyennes:SetPos(0,310)
    self.moyennes:SetTextColor(color_white)
    self.moyennes:SetFont("RAM_VoteFontCountdown")
    self.mapListm = vgui.Create("DPanelList", self.Canvas)
    self.mapListm:SetName("moyennes")
    self.mapListm:SetDrawBackground(false)
    self.mapListm:SetSpacing(4)
    self.mapListm:SetPadding(4)
    self.mapListm:SetPos(0,320)
    self.mapListm:EnableHorizontal(true)
    self.mapListm:EnableVerticalScrollbar()

    --Grandes maps

    self.grandes = vgui.Create("DLabel", self.Canvas)
    self.grandes:SetText("Maps grandes :")
    self.grandes:SetSize(500,30)
    self.grandes:SetPos(0,510)
    self.grandes:SetTextColor(color_white)
    self.grandes:SetFont("RAM_VoteFontCountdown")
    self.mapListg = vgui.Create("DPanelList", self.Canvas)
    self.mapListg:SetName("grandes")
    self.mapListg:SetDrawBackground(false)
    self.mapListg:SetSpacing(4)
    self.mapListg:SetPadding(4)
    self.mapListg:SetPos(0,320)
    self.mapListg:EnableHorizontal(true)
    self.mapListg:EnableVerticalScrollbar()
    
    self.closeButton = vgui.Create("DButton", self.Canvas)
    self.closeButton:SetText("")

    self.closeButton.Paint = function(panel, w, h)
        derma.SkinHook("Paint", "WindowCloseButton", panel, w, h)
    end

    self.closeButton.DoClick = function()
        print("MapVote has started...")
        self:SetVisible(false)
    end

    self.maximButton = vgui.Create("DButton", self.Canvas)
    self.maximButton:SetText("")
    self.maximButton:SetDisabled(true)

    self.maximButton.Paint = function(panel, w, h)
        derma.SkinHook("Paint", "WindowMaximizeButton", panel, w, h)
    end

    self.minimButton = vgui.Create("DButton", self.Canvas)
    self.minimButton:SetText("")
    self.minimButton:SetDisabled(true)

    self.minimButton.Paint = function(panel, w, h)
        derma.SkinHook("Paint", "WindowMinimizeButton", panel, w, h)
    end

    self.Voters = {}
    -- self.tailleVoters = 0

    
    self.voteurs = {}

    self.voteursp = {}
    self.voteursm = {}
    self.voteursg = {}
end

function PANEL:PerformLayout()
    local cx, cy = chat.GetChatBoxPos()
    
    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    
    local extra = math.Clamp(300, 0, ScrW() - 640)
    self.Canvas:StretchToParent(0, 0, 0, 0)
    self.Canvas:SetWide(640 + extra)
    // self.Canvas:SetTall(cy -60)
	self.Canvas:SetTall(940)
    self.Canvas:SetPos(0, 0)
    self.Canvas:CenterHorizontal()
    self.Canvas:SetZPos(0)
    
    self.mapList:StretchToParent(0, 90, 0, 0)
    self.mapListm:StretchToParent(0, 350, 0, 0)
    self.mapListg:StretchToParent(0, 550, 0, 0)

    local buttonPos = 640 + extra - 31 * 3

    self.closeButton:SetPos(buttonPos - 31 * 0, 4)
    self.closeButton:SetSize(31, 31)
    self.closeButton:SetVisible(true)

    self.maximButton:SetPos(buttonPos - 31 * 1, 4)
    self.maximButton:SetSize(31, 31)
    self.maximButton:SetVisible(true)

    self.minimButton:SetPos(buttonPos - 31 * 2, 4)
    self.minimButton:SetSize(31, 31)
    self.minimButton:SetVisible(true)
    
end

local heart_mat = Material("icon16/heart.png")
local star_mat = Material("icon16/star.png")
local shield_mat = Material("icon16/shield.png")

function PANEL:AddVoter(voter,taille,map_id)
    -- print("Taille table voters")
    -- print(table.getn(self.Voters))
    -- print("-------------------------------")
    -- PrintTable(self.Voters)
    -- if (table.getn(self.Voters)>0) then
    -- print(self.Voters["STEAM_0:1:63569677"].Player)
    -- end
    -- print("-------------------------------")

    for k, v in pairs(self.Voters) do
        -- if (k==1) then
            -- print(taille)
            -- print(tostring(v))
            -- print(v.TailleVote)    
        -- end
        
        -- if (tostring(v) == "[NULL Panel]") then
            -- self.Voters[k]=nil
            -- table.remove(self.Voters,k)
        -- end

        if (v.Player==voter) then
            if (v.TailleVote!=taille) then
                -- print("On a taillevote différent")
                -- print(v)
                -- print(k)
                
                -- print(v.Player:SteamID())
                -- PrintTable(MapVote.Votes)
                if (v.Player) then
                    MapVote.Votes[v.Player:SteamID()] = {map_id,taille}
                    -- print("avant del")
                    -- PrintTable(self.Voters)
                    -- print(v.Player)
                    -- print("on a mis autreTaille a true")
                    v.autreTaille = true
                    v:Remove()
                    v.Player=nil
                    v.TailleVote = nil
                    -- print(v.Player)
                    -- print("apres del")
                    -- PrintTable(self.Voters)
                -- else
                    -- if (taille=="petit") then
                    --     print("ic dans for = petit")
                    --     self:MapPetite(voter,taille)
                    -- elseif (taille=="moyen") then 
                    --     print("ic dans for = moyen")
                    --     self:MapMoyenne(voter,taille)
                    -- else 
                    --     print("ic dans for = grand")
                    --     self:MapGrande(voter,taille)
                    -- end
                end
            else
                if (v.Player) then
                    -- print("on met autreTaille a false")
                    v.autreTaille = false
                end
            end
        end
    end
    for k, v in pairs(self.Voters) do
        if(v.Player and v.Player == voter && !v.autreTaille) then
            -- print("On a déja le voteur")
            return false
        end
    end

    
    
    -- print("nouveau icon container")
    if (taille=="petit") then
        -- print("ic = petit")
        self:MapPetite(voter,taille)
    elseif (taille=="moyen") then 
        -- print("ic = moyen")
        self:MapMoyenne(voter,taille)
    else 
        -- print("ic = grand")
        self:MapGrande(voter,taille)
    end


end

function PANEL:MapPetite(voter,taille)
    local icon_container =  vgui.Create("Panel", self.mapList:GetCanvas())
    local icon = vgui.Create("AvatarImage", icon_container)
    icon:SetSize(16, 16)
    icon:SetZPos(1000)
    icon:SetTooltip(voter:Name())
    icon_container.Player = voter
    icon_container.TailleVote = taille
    icon_container.autreTaille = false
    icon_container:SetTooltip(voter:Name())
    icon:SetPlayer(voter, 16)

    icon_container:SetSize(20, 20)
    icon:SetPos(2, 2)

    
    icon_container.Paint = function(s, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(255, 0, 0, 80))
    end
    
    self.Voters[voter:SteamID()] = icon_container
    -- table.insert(self.Voters, icon_container)
end

function PANEL:MapMoyenne(voter,taille)
    -- print("ajout d'un voter pour map moyenne"..taille)
    local icon_container =  vgui.Create("Panel", self.mapListm:GetCanvas())
    local icon = vgui.Create("AvatarImage", icon_container)
    icon:SetSize(16, 16)
    icon:SetZPos(1000)
    icon:SetTooltip(voter:Name())
    icon_container.Player = voter
    icon_container.TailleVote = taille
    icon_container.autreTaille = false
    icon_container:SetTooltip(voter:Name())
    icon:SetPlayer(voter, 16)


    icon_container:SetSize(20, 20)
    icon:SetPos(2, 2)
    
    icon_container.Paint = function(s, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(255, 0, 0, 80))
    end
    
    self.Voters[voter:SteamID()] = icon_container
    -- table.insert(self.Voters, icon_container)
end

function PANEL:MapGrande(voter,taille)
    -- print("ajout d'un voter pour map grande"..taille)
    local icon_container =  vgui.Create("Panel", self.mapListg:GetCanvas())
    local icon = vgui.Create("AvatarImage", icon_container)
    icon:SetSize(16, 16)
    icon:SetZPos(1000)
    icon:SetTooltip(voter:Name())
    icon_container.Player = voter
    icon_container.TailleVote = taille
    icon_container.autreTaille = false
    icon_container:SetTooltip(voter:Name())
    icon:SetPlayer(voter, 16)

    icon_container:SetSize(20, 20)
    icon:SetPos(2, 2)

    
    icon_container.Paint = function(s, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(255, 0, 0, 80))
    end
    
    self.Voters[voter:SteamID()] = icon_container
    -- table.insert(self.Voters, icon_container)
end


function PANEL:Think()
    for k, v in pairs(self.mapList:GetItems()) do
        v.NumVotes = 0
    end

    for k, v in pairs(self.mapListm:GetItems()) do
        v.NumVotes = 0
    end

    for k, v in pairs(self.mapListg:GetItems()) do
        v.NumVotes = 0
    end
    

    for k,v in pairs(self.Voters) do
        if(not IsValid(v.Player)) then
            v:Remove()
        else
            if(not MapVote.Votes[v.Player:SteamID()]) then
                v:Remove()
            else

                local bar = self:GetMapButton(MapVote.Votes[v.Player:SteamID()][1])

                bar.NumVotes = bar.NumVotes + 1
                
                if(IsValid(bar)) then
                    local CurrentPos = Vector(v.x, v.y, 0)
                    local NewPos = Vector((bar.x + bar:GetWide()) - 21 * bar.NumVotes - 2, bar.y + (bar:GetTall() * 0.5 - 10), 0)
                    
                    if(not v.CurPos or v.CurPos ~= NewPos) then
                        v:MoveTo(NewPos.x, NewPos.y, 0.3)
                        v.CurPos = NewPos
                    end
                end
                -- print("on va recup la barre et faire le transfer d'icone")
            end
        end
    end
    
    local timeLeft = math.Round(math.Clamp(MapVote.EndTime - CurTime(), 0, math.huge))
    -- print("temps restant : "..timeLeft)
    -- print("cvar : "..MapVote.EndTime)
    self.countDown:SetText(tostring(timeLeft or 0).." seconds")
    self.countDown:SizeToContents()
    self.countDown:CenterHorizontal()
end

function PANEL:SetMaps(maps)
    self.mapList:Clear()
    self.mapListm:Clear()
    self.mapListg:Clear()
    
    --Faire les différentes tailles
    --Et si le nb de joueurs sur le serv supérieur a 12 afficher les grandes

    --Si map necessite le contenu CSS afficher une signification (engrenage ?, et une description de l'engrenage)
    local n = 1
    
    -- if (0==1) then
        --On va parcourir les 3 tailles (petit/moy/grand)
        for k,v in pairs(maps) do
            
            --Pour chaque taille
            for ke,map in pairs(v) do
                local button = {}
                local iconecss = {}
                local css = false
                if (table.HasValue(taillemaps['css'], map)) then
                    css = true
                else
                    css = false
                end
                if (k=='petites') then
                    button = vgui.Create("DButton", self.mapList)
                elseif (k=='moyennes') then
                    button = vgui.Create("DButton", self.mapListm)
                elseif (k=='grandes') then
                    button = vgui.Create("DButton", self.mapListg)
                end

                button.maptexte=map
                button.ID = n
                n=n+1
                if (k== "petites") then
                    button.taille = "petit"
                elseif (k== "moyennes") then
                    button.taille = "moyen"
                elseif (k== "grandes") then
                    button.taille = "grand"
                end

                button.DoClick = function()
                print("mapcliqué :"..button.maptexte)
                print("id :"..button.ID)
                    net.Start("RAM_MapVoteUpdate")
                        net.WriteUInt(MapVote.UPDATE_VOTE, 3)
                        net.WriteUInt(button.ID, 32)
                        net.WriteString(button.maptexte)
                        net.WriteString(button.taille)
                    net.SendToServer()
                end

                do
                    local Paint = button.Paint
                    button.Paint = function(s, w, h)
                        local col = Color(255, 255, 255, 10)
                        
                        if(button.bgColor) then
                            col = button.bgColor
                        end
                        
                        draw.RoundedBox(4, 0, 0, w, h, col)

                        draw.DrawText(button.maptexte, "RAM_VoteFont", 52, 20, Color( 255, 255, 255, 255 ))
                        Paint(s, w, h)
                    end
                end

                button:SetTextColor(color_white)
                button:SetContentAlignment(4)
                button:SetTextInset(8, 0)
                button:SetFont("RAM_VoteFont")
                
                local extra = math.Clamp(300, 0, ScrW() - 640)
                
                button:SetDrawBackground(false)


                --Taille du bouton
                button:SetTall(48)
                button:SetWide(285 + (extra / 2))
                button.NumVotes = 0

                --Aggrandissement de la map sur l'image sur le coté
                button.Think = function()
                    if button:IsHovered() then
                        aTransparence=true
                        self.imagemapB:SetAlpha(255)
                        self.imagemapB:SetImage("mapicon/"..tostring(map)..".png", "vgui/avatar_default")
                    end
                end


                --Ajout de l'image à la map
                local iconemap = vgui.Create("DImage", button)
                iconemap:SetPos(0,0)
                iconemap:SetSize(48,48)
                iconemap:SetImage("mapicon/"..tostring(map)..".png", "vgui/avatar_default")

                --Ajout de l'icone css
                if (css==true) then
                    local iconecss = vgui.Create("DImage", button)
                    iconecss:SetImage("icon16/cog.png")
                    iconecss:SetSize(16,16)
                    iconecss:SetPos(50,2)
                end

                if (button.taille == "petit") then
                    self.mapList:AddItem(button)
                elseif (button.taille == "moyen") then
                    self.mapListm:AddItem(button)
                elseif (button.taille == "grand") then
                    self.mapListg:AddItem(button)
                end
            end
        end
    -- end


end

function PANEL:GetMapButton(id)
    for k, v in pairs(self.mapList:GetItems()) do
        if(v.ID == id) then
            -- print("trouvé dans petite (maplist)")
            return v
        end
    end

    for k, v in pairs(self.mapListm:GetItems()) do
        if(v.ID == id) then
            -- print("trouvé dans moyenne (maplist)")
            return v
        end
    end

    for k, v in pairs(self.mapListg:GetItems()) do
        if(v.ID == id) then
            -- print("trouvé dans grande (maplist)")
            return v
        end
    end
    
    return false
end

function PANEL:Paint()
    --Derma_DrawBackgroundBlur(self)
    
    local CenterY = ScrH() / 2
    local CenterX = ScrW() / 2
    
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(0, 0, ScrW(), ScrH())
end

function PANEL:Flash(id)
    self:SetVisible(true)

    local bar = self:GetMapButton(id)
    
    if(IsValid(bar)) then
        timer.Simple( 0.0, function() bar.bgColor = Color( 0, 255, 255 ) surface.PlaySound( "hl1/fvox/blip.wav" ) end )
        timer.Simple( 0.2, function() bar.bgColor = nil end )
        timer.Simple( 0.4, function() bar.bgColor = Color( 0, 255, 255 ) surface.PlaySound( "hl1/fvox/blip.wav" ) end )
        timer.Simple( 0.6, function() bar.bgColor = nil end )
        timer.Simple( 0.8, function() bar.bgColor = Color( 0, 255, 255 ) surface.PlaySound( "hl1/fvox/blip.wav" ) end )
        timer.Simple( 1.0, function() bar.bgColor = Color( 100, 100, 100 ) end )
    end
end

derma.DefineControl("VoteScreen", "", PANEL, "DPanel")