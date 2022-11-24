
-- hudScreen = nil
local Alive = false
local Class = nil
local Team = 0
local WaitingToRespawn = false
local InRound = false
local RoundResult = 0
local RoundNumber = 0
local RoundWinner = nil
local IsObserver = false
local ObserveMode = 0
local ObserveTarget = NULL
local InVote = false
local nbHunters = 0
local nbProps = 0
local nextRefresh = 0
local verifNbHunters = 0
local verifNbProps = 0

function GM:AddHUDItem( item, pos, parent )
	hudScreen:AddItem( item, parent, pos )
	-- print(hudScreen)
	-- hudScreen:Clear()
end

function GM:CleanHUD()
	hudScreen:Clear()
end

function GM:HUDNeedsUpdate()

	if (nextRefresh>CurTime()) then return false end
	if ( !IsValid( LocalPlayer() ) ) then return false end

	if ( hudScreen == nil || hudSpec == nil) then 
		-- print("hudscreen=nil")
		return true
	end
	if ( Class != LocalPlayer():GetNWString( "Class", "Default" ) ) then return true end
	if ( Alive != LocalPlayer():Alive() ) then return true end
	if ( Team != LocalPlayer():Team() ) then return true end
	if ( WaitingToRespawn != ( (LocalPlayer():GetNWFloat( "RespawnTime", 0 ) > CurTime()) && LocalPlayer():Team() != TEAM_SPECTATOR && !LocalPlayer():Alive()) ) then return true end
	if ( InRound != GetGlobalBool( "InRound", false ) ) then return true end
	if ( RoundResult != GetGlobalInt( "RoundResult", 0 ) ) then return true end
	if ( RoundNumber != GetGlobalInt( "RoundNumber", 0 ) ) then return true end
	if ( RoundWinner != GetGlobalEntity( "RoundWinner", nil ) ) then return true end
	if ( IsObserver != LocalPlayer():IsObserver() ) then return true end
	if ( ObserveMode != LocalPlayer():GetObserverMode() ) then return true end
	if ( ObserveTarget != LocalPlayer():GetObserverTarget() ) then return true end
	if ( InVote != GAMEMODE:InGamemodeVote() ) then return true end
	verifNbHunters=0
	verifNbProps=0
	for k,v in pairs(player.GetAll()) do
		if (v:Alive() && v:Team()==TEAM_HUNTERS) then
			verifNbHunters = verifNbHunters+1
		elseif (v:Alive() && v:Team()==TEAM_PROPS) then
			verifNbProps = verifNbProps+1
		end
	end
	if (nbHunters != verifNbHunters) then return true end
	if (nbProps != verifNbProps) then return true end
	
	return false
end

function GM:OnHUDUpdated()
	Class = LocalPlayer():GetNWString( "Class", "Default" )
	Alive = LocalPlayer():Alive()
	Team = LocalPlayer():Team()
	WaitingToRespawn = (LocalPlayer():GetNWFloat( "RespawnTime", 0 ) > CurTime()) && LocalPlayer():Team() != TEAM_SPECTATOR && !Alive
	InRound = GetGlobalBool( "InRound", false )
	RoundResult = GetGlobalInt( "RoundResult", 0 )
	RoundNumber = GetGlobalInt( "RoundNumber", 0 )
	RoundWinner = GetGlobalEntity( "RoundWinner", nil )
	IsObserver = LocalPlayer():IsObserver()
	ObserveMode = LocalPlayer():GetObserverMode()
	ObserveTarget = LocalPlayer():GetObserverTarget()
	InVote = GAMEMODE:InGamemodeVote()
	nbHunters = verifNbHunters
	nbProps = verifNbProps
	nextRefresh = CurTime()+1
end

function GM:OnHUDPaint()

end



hook.Add("OnReloaded","testrefreshhud2", function()
	OVCRHUD_OpenHUD()
end)

hook.Add("InitPostEntity", "PH_HUD_Start", function() 
	OVCRHUD_OpenHUD()
		-- GAMEMODE:RefreshHUD()	
end)

function GM:HUDPaint()
	if !IsValid(hudScreen) || !IsValid(hudSpec) then
		OVCRHUD_OpenHUD() 
	end
end


function OVCRHUD_OpenHUD() 
	if IsValid(hudScreen) || IsValid(hudSpec) then
		hudScreen:Remove()
		hudSpec:Remove()
	end

	hudScreen = vgui.Create("DFrame")
	hudScreen:SetTitle("")
	hudScreen:ShowCloseButton( false )
	hudScreen:SetSize(ScrW()/3,100)
	hudScreen:SetPos(ScrW()/2-hudScreen:GetWide()/2,ScrH()/1.15)

	hudScreen.Think = function()
		if (GAMEMODE:HUDNeedsUpdate()) then
			GAMEMODE:OnHUDUpdated()
		end
	end

	hudScreen.Paint = function( self, w, h )
		local couleurTexte = Color(255,0,255,180)
		--Fond vert pour débug 
		-- draw.RoundedBox( 1, 0, 0, w, h, Color( 0, 250, 0, 255 ) )
		--Trait du milieu
		-- draw.RoundedBox( 1, w/2-1, 0, 1, h, Color( 0, 0, 0, 255 ) )
		--Cadre rose
		surface.SetDrawColor(couleurTexte)
		surface.DrawOutlinedRect( 0,0,  w,  h-20, 3 )
		surface.DrawOutlinedRect( 5,5,  w-10,  h-30, 1 )
		-- Soleil
		surface.SetDrawColor(255, 255, 255, 235)
		surface.SetMaterial(Material("vgui/sun.png"))
		surface.DrawTexturedRect(w/2-33,46,w/10,h/3+26)
		--Statue
		-- surface.SetDrawColor(255, 255, 255, 170)
		-- surface.SetMaterial(Material("vgui/statue.png"))
		-- surface.DrawTexturedRect(0,2,w/9,h/3+45)
		surface.SetDrawColor(255, 255, 255, 200)
		surface.SetMaterial(Material("vgui/statue2.png"))
		surface.DrawTexturedRect(7,9,w/12,h/3+30)
		--Palmiers
		surface.SetDrawColor(255, 255, 255, 200)
		surface.SetMaterial(Material("vgui/palm.png"))
		surface.DrawTexturedRect(w-73,7,w/10,h/3+30)

		--Texte Overcreep
		-- surface.SetFont( "Default" )
		surface.SetFont( "DarktoothFontHUD" )
		surface.SetTextColor( couleurTexte )
		surface.SetTextPos( w/1.8 , h-38 ) 
		surface.DrawText( "Overcreep" )

		--NB Rounds
		surface.SetFont( "DarktoothFontHUDRound" )
		surface.SetTextColor( couleurTexte )
		surface.SetTextPos( w/8 , h/2-12 ) 
		surface.DrawText( RoundNumber.."/10" )
		surface.SetFont( "DarktoothFontHUD" )
		surface.SetTextPos( w/8 , h/2+10 ) 
		surface.DrawText( "Rounds" )
		if (InRound && !InVote && #player.GetAll()>1) then
			--Temps Restant
			local EndTime
			if ( GetGlobalFloat( "RoundStartTime", 0 ) > CurTime() ) then
				EndTime = GetGlobalFloat( "RoundStartTime", 0 )
			else
				EndTime = GetGlobalFloat( "RoundEndTime" )  
			end 
			local Time = util.ToMinutesSeconds( EndTime - CurTime() )
			if ( !EndTime || EndTime < CurTime() || EndTime==-1 ) then 
				Time = "00:00"
			end
			surface.SetFont( "DarktoothFontHUD" )
			surface.SetTextPos( w/8 , h/2-43 ) 
			surface.DrawText( "Temps restant" )
			surface.SetFont( "DarktoothFontHUDRound" ) 
			surface.SetTextColor( couleurTexte )
			surface.SetTextPos( w/8 , h/2-34 ) 
			surface.DrawText( Time )
			--Nb props en vie
			surface.SetFont( "DarktoothFontHUD" )
			surface.SetTextPos( w/1.3 , h/2-43 ) 
			surface.DrawText( "Props" )
			surface.SetFont( "DarktoothFontHUDRound" ) 
			surface.SetTextColor( couleurTexte )
			surface.SetTextPos( w/1.3 , h/2-34 ) 
			surface.DrawText( nbProps )
			--Nb hunters en vie
			surface.SetFont( "DarktoothFontHUDRound" )
			surface.SetTextColor( couleurTexte )
			surface.SetTextPos( w/1.3 , h/2-12 ) 
			surface.DrawText( nbHunters )
			surface.SetFont( "DarktoothFontHUD" )
			surface.SetTextPos( w/1.3 , h/2+10 ) 
			surface.DrawText( "Hunters" )

			--Team
			surface.SetFont( "DarktoothFontHUDTeam" )
			-- local txt = "Equipe:"..team.GetName(LocalPlayer():Team())
			local txt = team.GetName(LocalPlayer():Team())
			local wTxt , hTxt = surface.GetTextSize( txt )
			surface.SetTextColor( couleurTexte )
			surface.SetTextPos( w/2-(wTxt/2) , h/2-40 ) 
			surface.DrawText( txt )
		else
			if (InVote) then
				surface.SetFont( "DarktoothFontHUDRound" )
				local txt = "Votemap"
				local wTxt , hTxt = surface.GetTextSize( txt )
				surface.SetTextColor( couleurTexte )
				surface.SetTextPos( w/2-(wTxt/2) , h/2-40 ) 
				surface.DrawText( txt )
			elseif (!InRound && #player.GetAll()>1) then
				surface.SetFont( "DarktoothFontHUDRound" )
				local txt = "Chargement prochain round"
				local wTxt , hTxt = surface.GetTextSize( txt )
				surface.SetTextColor( couleurTexte )
				surface.SetTextPos( w/2-(wTxt/2) , h/2-40 ) 
				surface.DrawText( txt )
			elseif (#player.GetAll()==1) then
				surface.SetFont( "DarktoothFontHUDRound" )
				local txt = "En attente de joueurs..."
				local wTxt , hTxt = surface.GetTextSize( txt )
				surface.SetTextColor( couleurTexte )
				surface.SetTextPos( w/2-(wTxt/2) , h/2-40 ) 
				surface.DrawText( txt )
			end
		end

		
	end


	hudSpec = vgui.Create("DFrame")
	hudSpec:SetTitle("")
	hudSpec:ShowCloseButton( false )
	hudSpec:SetSize(ScrW(),100)
	hudSpec:SetPos(0,30)

	hudSpec.Paint = function(self, w, h)
		if (LocalPlayer():Team()==TEAM_SPECTATOR && IsValid( ObserveTarget ) && ObserveTarget:IsPlayer() && ObserveTarget != LocalPlayer() && ObserveMode != OBS_MODE_ROAMING) then
			local couleurTexte = Color(255,0,255,180)
			--Fond vert pour débug 
			-- draw.RoundedBox( 1, 0, 0, w, h, Color( 0, 250, 0, 255 ) )
			--Trait du milieu
			-- draw.RoundedBox( 1, w/2-1, 0, 1, h, Color( 0, 0, 0, 255 ) )
			surface.SetFont( "DarktoothFontHUDRound" )
			local txt = ObserveTarget:Name()
			-- local txt = "Darktooth"
			local tailleHud, hauteurHud = surface.GetTextSize( txt )
			--Cadre rose
			surface.SetDrawColor(couleurTexte)
			-- surface.DrawOutlinedRect( w/2-w/4-(tailleHud/2)-50, 0,  w/2-w/4+(tailleHud/2)+50,  h-20, 3 )
			surface.DrawOutlinedRect( w/2-(w/6+tailleHud/2)+25+(w/6+(tailleHud/2))/2, 0,  w/6+(tailleHud/2)-50,  h-20, 3 )
			surface.DrawOutlinedRect( w/2-(w/6+tailleHud/2)+30+(w/6+(tailleHud/2))/2, 5,  w/6+(tailleHud/2)-60,  h-30, 1 )
			-- surface.DrawOutlinedRect( 5,5,  w-10,  h-30, 1 )
			-- Soleil
			-- surface.SetDrawColor(255, 255, 255, 255)
			-- surface.SetMaterial(Material("vgui/sun.png"))
			-- surface.DrawTexturedRect(w/2-30,52,60,50)

			surface.SetTextColor( couleurTexte )
			surface.SetTextPos( w/2-(tailleHud/2) , h/2-30 ) 
			surface.DrawText( txt )
			surface.SetFont( "DarktoothFontHUD" )
			tailleHud, hauteurHud = surface.GetTextSize( "Observation" )
			surface.SetTextPos( w/2-(tailleHud/2) , h/2-43 ) 
			surface.DrawText( "Observation" )
			tailleHud, hauteurHud = surface.GetTextSize( "F2 pour choisir une équipe" )
			surface.SetTextPos( w/2-(tailleHud/2) , h/2+10 ) 
			surface.DrawText( "F2 pour choisir une équipe" )
			tailleHud, hauteurHud = surface.GetTextSize( "F2 to pick a team" )
			surface.SetTextPos( w/2-(tailleHud/2) , h/2 ) 
			surface.DrawText( "F2 to pick a team" )
		end
	end
end