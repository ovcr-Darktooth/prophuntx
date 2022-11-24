PHX.DEFAULT_CATEGORY = "Prop Hunt X Classics"

-- Permanently banned models.
local phx_PermaBannedModels = {
    -- Props that can cause server crash. Please DO NOT REMOVE THIS as for your own safety sake!
    "models/props/ph_gas_stationrc7/piepan.mdl",
    
    -- Tiny / Exploitable Props which often cause game breaking
    "models/props/cs_assault/money.mdl",
    "models/props/cs_assault/dollar.mdl",
    "models/props/cs_office/snowman_arm.mdl",
    "models/props/cs_office/computer_mouse.mdl",
    "models/props/cs_office/projector_remote.mdl",
    "models/foodnhouseholditems/egg.mdl",
    "models/props/cs_militia/reload_bullet_tray.mdl",
    "models/sims/lightwall2.mdl",
	"models/crow.mdl",
	"models/props/cs_office/light_inset.mdl",
	"models/props/cs_office/computer_caseb_p2a.mdl",
	"models/props/cs_office/computer_caseb_p8a.mdl",
	"models/props/cs_office/trash_can_p2.mdl",
	"models/props/cs_office/trash_can_p7.mdl",
	"models/props_junk/garbage_cellphone01a.mdl",
	"models/props_wasteland/prison_toiletchunk01c.mdl",
	"models/plate_small/plate_small.mdl",
	"models/props/cs_office/phone_p2.mdl"
}

-- Decoy Default Distance
PHX.DecoyDistance   = 250

-- Time (in seconds) for spectator check (Default: 0.1)
PHX.SPECTATOR_CHECK_ADD = 0.1

-- [ Usable Entities ]
-- Do Not Use / Modify from THIS TABLE!
--====================================================================================--
-- RULES: MUST HAVE VPHSYICS, MUST HAVE PROPER BOUNDING BOX.
-- NO VPHYSICS = IGNORED
--====================================================================================--
PHX.CVARUseAbleEnts = {
	-- Due to Performance issue, table must contains: [classname] = true. We'll starting to avoid table.HasValue for now.
	[1]	= { 
		-- DO NOT ADD OR CHANGE ANYTHING HERE, USE [4] BELOW!
		["prop_physics"]				= true,
		["prop_physics_multiplayer"]	= true,
		["prop_physics_override"]		= true
		-- DO NOT ADD OR CHANGE ANYTHING HERE, USE [4] BELOW!
	},
	[2]	= {
		-- DO NOT ADD OR CHANGE ANYTHING HERE, USE [4] BELOW!
		["prop_physics"]				= true,
		["prop_physics_multiplayer"]	= true,
		["prop_physics_override"]		= true,
		["prop_dynamic"] 				= true,
		["prop_dynamic_override"] 		= true
		-- DO NOT ADD OR CHANGE ANYTHING HERE, USE [4] BELOW!
	},
	[3] = {
		-- DO NOT ADD OR CHANGE ANYTHING HERE, USE [4] BELOW!
		["prop_physics"]				= true,
		["prop_physics_multiplayer"]	= true,
		["prop_physics_override"]		= true,
		["prop_dynamic"] 				= true,
		["prop_dynamic_override"] 		= true,
		["prop_ragdoll"]				= true, -- Warning: prop_ragdoll will be deprecated: Causing bug with Pitch Prop Rotation.
		["ph_luckyball"]				= true,
		["item_healthkit"] 				= true,
		["item_battery"] 				= true,
		["item_item_crate"] 			= true,
		["item_ammo_crate"] 			= true,
		["prop_door_rotating"]			= true,
		["prop_vehicle_jeep"]			= true,
		["prop_vehicle_drivable"]		= true,
		["prop_vehicle_apc"]			= true,
		["prop_vehicle_airboat"]		= true,
		["prop_thumper"]				= true, -- thumper is too big i guess. 
		["combine_mine"]				= true
		-- DO NOT ADD OR CHANGE ANYTHING HERE, USE [4] BELOW!
		
		-- I'm not going to add any weapons or other item entities so it's up to you to add by using PHX.USABLE_PROP_CUSTOM_ENTS below.
		-- These are recommended list and please do a copy paste to table below to modify. NOT inside this table!!!
	},
	[4] = {
		-- Enter any custom entities here. Avoid adding dangerous entities which may cause your server/game to CRASH! 
		-- See: https://gmodgameservers.com/wiki/prophuntx/#0_QuickFix/Dangerous_Entities+Dangerous_Entities
		--====================================================================================--
		-- RULES: MUST HAVE VPHSYICS, MUST HAVE PROPER COLLISION BOUNDS/BOUNDING BOX (BBOX).
		-- NO VPHYSICS = IGNORED
		--====================================================================================--
		["prop_physics"]				= true,
		["prop_physics_multiplayer"] 	= true,
		["prop_physics_override"] 		= true
	}
}

-- Initialise
PHX.USABLE_PROP_ENTITIES = PHX.USABLE_PROP_ENTITIES or PHX.CVARUseAbleEnts[1]

function PHX:IsUsablePropEntity( entClass )
	if entClass and entClass ~= nil then
		if self.USABLE_PROP_ENTITIES[entClass] then
			return true
		end
	end
	return false
end

-- Called only from cvars.AddChangeCallback. Do Not use outside from cvar's callback function!
function PHX:SetUsableEntity( number )
	if !number and !isnumber(number) then return end

	if number >= 1 and number <= 4 then
		self.USABLE_PROP_ENTITIES = self.CVARUseAbleEnts[number]
	else
		ErrorNoHalt("Error: SetUsableEntity number argument is out of range! (min = 1, max = 4)")
	end
end

function PHX:GetUsableEntities()
	return self.USABLE_PROP_ENTITIES
end

-- dirty hacks: Client and Server must update Usable Prop Entities settings every round restart!
-- Also Addition: Prohibitted Props
-- Prohibitted models which can cause server/client crash or other issues.
-- This will automatically gets deleted after round restart!

-- Please DO NOT REMOVE OR MODIFY THIS TABLE as this is for your own safety sake!
PHX.PROHIBITTED_MDLS = {
    -- Can cause server crash when being used with Prop Menu. Occurs on ph_gas_station* maps.
	["models/props_collectables/piepan.mdl"]	    = true,
    ["models/props/ph_gas_stationrc7/piepan.mdl"]   = true,
    
    -- This props is so tiny that can be exploited to almost in any objects!
	["models/foodnhouseholditems/egg.mdl"]		= true,
    -- Not crashing problem, but with rotation, it can go through to the wall, almost made entirely invisible.
	["models/sims/lightwall2.mdl"]				= true
}

-- This is default English as Fallback. DO NOT TRANSLATE HERE, USE YOUR TRANSLATED LANGUAGE FILE INSTEAD!
PHX.DefaultHelp = [[A Prop Hunt: X Project.

A project to make Prop Hunt X modern and customisable.

More info can be found at:
https://gmodgameservers.com/prophuntx

To See more info, help and guide, Press [F1] key and then click [Prop Hunt Menu] button.

Version: ]].. PHX.VERSION ..[[ Revision: ]].. PHX.REVISION ..[[

Have Fun!]]

PHX.IgnoreMutedUserGroup = {
	-- Use from Group Edit in F1 Menu.
	-- Do not modify. Use External script to add group.
	["superadmin"] 	= true,
	["admin"] 		= true
}
PHX.SVAdmins = {
    -- Use from Group Edit in F1 Menu.
    -- Do not modify. Use External script to add group.
	["superadmin"] = true
}
-- Bootstrap 4 colour base. This only works on clientside :(
PHX.info = {
	["PRIMARY"] = { Color(200,200,200), "INFO"		},
	["NOTICE"]	= { Color(40 ,150,255), "NOTICE"	},
	["ERROR"]	= { Color(250, 86, 46), "ALERT"		},
	["WARNING"] = { Color(252,221,  3), "WARNING"	},
	["GOOD"]	= { Color(34 ,177, 76), "INFO"		}
}
-- End of Stock Config

function PHX:AddAdminGroup( strGroup )
	if !strGroup or strGroup == nil or !isstring(strGroup) or strGroup == "" then return end
	
	if self.SVAdmins[strGroup] then
        print("Failed. UserGroup was exists.")
		PHX.VerboseMsg("[PHX] The usergroup you entered '" .. strGroup .. "' was exist. Ignoring...")
	else
		self.SVAdmins[strGroup] = true
	end
end

function PHX:RemoveAdminGroup( strGroup )
    if !strGroup or strGroup == nil or !isstring(strGroup) or strGroup == "" then return end
    
    self.SVAdmins[strGroup] = nil
end

function PHX:AddWhitelistMuted( strGroup )
	if !strGroup or strGroup == nil or !isstring(strGroup) or strGroup == "" then return end
	
	if self.IgnoreMutedUserGroup[strGroup] then
		PHX.VerboseMsg("[PHX] The whitelisted mute usergroup you entered '" .. strGroup .. "' was exist. Ignoring...")
	else
		self.IgnoreMutedUserGroup[strGroup] = true
	end
end

function PHX:RemoveWhitelistMuted( strGroup )
	if !strGroup or strGroup == nil or !isstring(strGroup) or strGroup == "" then return end
	
	self.IgnoreMutedUserGroup[strGroup] = nil
end

-- Banned Props models. Stock, use external lua script to add and use Initialize hook to start adding items.
PHX.BANNED_PROP_MODELS = {}

-- Taunts are now moved here
PHX.TAUNTS = {}
PHX.TAUNTS[PHX.DEFAULT_CATEGORY] = {}

-- Custom Player Model bans for props
PHX.PROP_PLMODEL_BANS = {
	"models/player.mdl"
}

-- the Freeze Cam Sounds
PHX.FreezeCamSounds = {
	"misc/freeze_cam.wav",
	"misc/freeze_cam_sad1.wav"
}

PHX.WINNINGSOUNDS = {	
	-- Legends: [1] = Team Hunters, [2] = Team Props.
	[1] = { "misc/ph_hunterwin.mp3", 	"misc/ph_hunterwin_new1.mp3" },
	[2]	= { "misc/ph_propwin.mp3", 	 	"misc/ph_propwin_new1.mp3"	 },
	[3]	= { "misc/ph_rounddraw_1.mp3", 	"misc/ph_rounddraw_2.mp3", "misc/ph_rounddraw_3.mp3" }
}

if SERVER then
	function PHX:PlayWinningSound( teamid )
		teamid = math.Clamp(teamid, 1, 3)
	
		if !teamid or teamid == nil or 
			teamid == 0 or teamid == 1001 then
			teamid = 3 -- make '3' as a default sound.
		end
		
		local t = PHX.WINNINGSOUNDS[teamid]
		local rand = t[math.random(1,#t)]
		
		if rand and rand ~= nil and isstring( rand ) then
		net.Start("PH_TeamWinning_Snd")
			net.WriteString(rand)
		net.Broadcast()
			
		else
			ErrorNoHalt("[PHX Win Sound] Cannot play win sound because it's appear to be invalid!")
		end
	end
end

--[[ // DO NOT MODIFY! These are stock taunts. Please add yourself by using taunt scanner! \\ ]]--
PHX.TAUNTS[PHX.DEFAULT_CATEGORY][TEAM_HUNTERS] = {
	["Come to Papa"]				=	{"taunts/hunters/come_to_papa.wav",1},
	["I am your Father"]			=	{"taunts/hunters/father.wav",2},
	["Need Fire Assistance!"]		=	{"taunts/hunters/fireassis.wav",2},
	["{GlaDOS) President"]			=	{"taunts/hunters/glados-president.wav",5},
	["I am Hit!"]					=	{"taunts/hunters/hitassist.wav",1},
	["How Rude"]					=	{"taunts/hunters/how_rude.wav",1},
	["I will Find You"]				=	{"taunts/hunters/ill_find_you.wav",6},
	["Radio Laugh"]					=	{"taunts/hunters/laugh.wav",2},
	["Now What?"]					=	{"taunts/hunters/now_what.wav",1},
	["You dont have the Soul"]		=	{"taunts/hunters/you_dont_have_the_soul.wav",2},
	["You dont know the Power"]		=	{"taunts/hunters/you_dont_know_the_power.wav",4},
	["You are underestimating"]		=	{"taunts/hunters/you_underestimate_the_power.wav",3},
	["Threat Neutralized"]			=	{"taunts/hunters/threat_neutralized.wav",1},
	["DX: My Vision is Augmented"]	=	{"taunts/ph_enhanced/dx_augmented.wav",2},
	["DX: Im gonna Whoop your Ass"]	=	{"taunts/ph_enhanced/dx_imgonnawoopyourass.wav",1},
	["DX: Dont worry we are cops"]	=	{"taunts/ph_enhanced/dx_dontworrywurcops.wav",2},
	["DX: Heheh"]					=	{"taunts/ph_enhanced/dx_hehe.wav",1},
	["Albatard"]					=	{"taunts/ovcr/albatard.mp3",1},
	["Arrête de manger toi"]		=	{"taunts/ovcr/arrete_de_manger_toi.mp3",1},
	["Arrête stp"]					=	{"taunts/ovcr/arrete_stp.mp3",1},
	["Bande de batard"]				=	{"taunts/ovcr/bande_de_batard.mp3",1},
	["Begayement"]					=	{"taunts/ovcr/begayement.mp3",4},
	["Bonjour madame"]				=	{"taunts/ovcr/bjr_madame.mp3",2},
	["Blc de ta vie"]				=	{"taunts/ovcr/blc_de_ta_vie.mp3",1},
	["Bonne journée"]				=	{"taunts/ovcr/bonne_journee.mp3",1},
	["Bouffe  ma queue salope"]		=	{"taunts/ovcr/bouffe_ma_queue_salope.mp3",2},
	["Comment vas ta mère"]			=	{"taunts/ovcr/comment_vas_ta_mere.mp3",2},
	["Cris cris sale pute"]			=	{"taunts/ovcr/cris_cris_sale_pute.mp3",2},
	["Fdp"]							=	{"taunts/ovcr/fdp.mp3",1},
	["Ftg fils de chien"]			=	{"taunts/ovcr/ftg_fils_de_chien.mp3",2},
	["Ftg sale dromadaire"]			=	{"taunts/ovcr/ftg_sale_dromadaire.mp3",2},
	["Je suis pas français"]		=	{"taunts/ovcr/je_suis_pas_francais.mp3",2},
	["Je vais baiser ta mère"]		=	{"taunts/ovcr/je_vais_baiser_ta_mere.mp3",3},
	["Mange mon sauciflard"]		=	{"taunts/ovcr/mange_mon_sauciflard.mp3",2},
	["Noir arrète de parler ok"]	=	{"taunts/ovcr/noir_arrete_de_parler_ok.mp3",4},
	["Ok c'est une bonne question"]	=	{"taunts/ovcr/ok_cest_une_bonne_histoire.mp3",2},
	["Orv fdp"]						=	{"taunts/ovcr/orv_fdp.mp3",2},
	["Bien joué bonne histoire"]	=	{"taunts/ovcr/ouais_bien_joue_bonne_histoire_frere.mp3",2},
	["Pk tu suce"]					=	{"taunts/ovcr/pk_tu_suce.mp3",2},
	["Sale baleine"]				=	{"taunts/ovcr/sale_baleine.mp3",2},
	["Salut fdp"]					=	{"taunts/ovcr/salut_fdp.mp3",2},
	["Salut les amis"]				=	{"taunts/ovcr/salut_les_amis.mp3",3},
	["Salut les amis c'est popi"]	=	{"taunts/ovcr/salut_les_amis_cest_popi.mp3",4},
	["Slt fdp"]						=	{"taunts/ovcr/slt_fdp.mp3",1},
	["Slash ban"]					=	{"taunts/ovcr/slashban.mp3",1},
	["Ta mère la ornithorynque"]	=	{"taunts/ovcr/ta_mere_la_ornithorynque.mp3",2},
	["Tk"]							=	{"taunts/ovcr/tk.mp3",2},
	["Tu parle trop"]				=	{"taunts/ovcr/tu_parler_trop.mp3",3},
	["Viens lécher mes couilles"]	=	{"taunts/ovcr/viens_lecher_mes_couilles_sur_mc.mp3",2},
	["Wsh ftg toi"]					=	{"taunts/ovcr/wsh_ftg_toi.mp3",1},
	["Wsh ftg toi il parler"]		=	{"taunts/ovcr/wsh_ftg_toi_il_parler.mp3",2},
	["Why are you running"]			=	{"taunts/ovcr/Why_are_you_running.mp3",1}
}

--[[ // DO NOT MODIFY! use from taunts/props_taunts.lua or hunters_taunts.lua instead! \\ ]]--
PHX.TAUNTS[PHX.DEFAULT_CATEGORY][TEAM_PROPS] = {
	["Bad Boys"]							=	{"taunts/props/bad_boys.wav",11},
	["Not the Bees"]						=	{"taunts/props/bees_fix.wav",3},
	["BillyMays - Are you on the Balls"]	=	{"taunts/props/billymays_areyouontheballs.wav",1},
	["BillyMays - Get on the Balls"]		=	{"taunts/props/billymays_getontheballs.wav",1},
	["BillyMays - I Guarantee It"]			=	{"taunts/props/billymays_iguaranteeit.wav",1},
	["BillyMays - Its so Easy"]				=	{"taunts/props/billymays_itsoeasy.wav",3},
	["BillyMays - Laundry made Easy"]		=	{"taunts/props/billymays_laundrymadeeasy.wav",2},
	["BillyMays - New OxyClean"]			=	{"taunts/props/billymays_newoxyclean.wav",1},
	["BillyMays - No more Detergent"]		=	{"taunts/props/billymays_nomoredetergent.wav",3},
	["BillyMays - Only $9.99"]				=	{"taunts/props/billymays_only9_99.wav",1},
	["BillyMays - OxyClean"]				=	{"taunts/props/billymays_oxyclean.wav",2},
	["BillyMays - So Get on the Balls!"]	=	{"taunts/props/billymays_sogetontheballs.wav",1},
	["Boom, Headshot!"]						=	{"taunts/props/boom_hs.wav",1},
	["Car Horn"]							=	{"taunts/props/car_horn.wav",1},
	["Chicken Hammer"]						=	{"taunts/props/chicken_hammer.wav",3},
	["DOH"]									=	{"taunts/props/doh.wav",1},
	["Force Eliminated"]					=	{"taunts/props/forces_eliminated.wav",2},
	["H A R D B A S S"]						=	{"taunts/props/hardbass.wav",10},
	["T R I  P O L O S K I"]				=	{"taunts/props/tri_poloski1.wav",8},
	["Poloski Beats"]						=	{"taunts/props/tri_poloski2.wav",10},
	["Nein Nein Nein"]						=	{"taunts/props/nein.wav",3},
	["Ill be back"]							=	{"taunts/props/ill_be_back.wav",1},
	["I am Corn Holio"]						=	{"taunts/props/i_am_cornholio.wav",3},
	["I Am the one and only"]				=	{"taunts/props/i_am_the_one_and_only.wav",4},
	["LEROY JENKINS"]						=	{"taunts/props/leroy_jenkins.wav",4},
	["Oh yeah he will pay"]					=	{"taunts/props/oh_yea_he_will_pay.wav",4},
	["Muffin Man"]							=	{"taunts/props/ok_i_will_tell_you.wav",5},
	["ON ME"]								=	{"taunts/props/on_me.wav",7},
	["Its over 9000"]						=	{"taunts/props/over9000.wav",7},
	["PINGAS"]								=	{"taunts/props/pingas.wav",3},
	["Please Come Again"]					=	{"taunts/props/pls_come_again.wav",1},
	["Pokemon"]								=	{"taunts/props/pokemon.wav",4},
	["Very Retarded Laugh"]					=	{"taunts/props/retarted_laugh.wav",10},
	["Shams Wow"]							=	{"taunts/props/sham_wow.wav",4},
	["This is SPARTA"]						=	{"taunts/props/sparta.wav",2},
	["WATATATATA"]							=	{"taunts/props/watatata.wav",20},
	["What is wrong with you"]				=	{"taunts/props/wrong.wav",2},
	["WROOOONG"]							=	{"taunts/props/wroooong.wav",1},
	["Wololo"]								=	{"taunts/props/wololo.wav",1},
	["WooHoo"]								=	{"taunts/props/woohoo.wav",1},
	["DX: Easy Bruh"]						=	{"taunts/ph_enhanced/dx_easy_bruh.wav",1},
	["DX: Hehe"]							=	{"taunts/ph_enhanced/dx_heh.wav",1},
	["DX: I dont Move Out"]					=	{"taunts/ph_enhanced/dx_idonotmoveout.wav",1},
	["DX: You Killed my Friend"]			=	{"taunts/ph_enhanced/dx_iloominarty.wav",4},
	["DX: Leave me alone"]					=	{"taunts/ph_enhanced/dx_leaveme.wav",1},
	["DX: LOOK AT ME"]						=	{"taunts/ph_enhanced/dx_lookatme.wav",1},
	["DX: AAAAAAARGGHHHHHH"]				=	{"taunts/ph_enhanced/dx_molepeople.wav",11},
	["DX: A BOMB"]							=	{"taunts/ph_enhanced/dx_thebomb.wav",1},
	["DX: THE BOMB JC"]						=	{"taunts/ph_enhanced/dx_thebomb2.wav",1},
	["DX: What a Shame"]					=	{"taunts/ph_enhanced/dx_whatashame.wav",1},
	["DX: Whoa #1"]							=	{"taunts/ph_enhanced/dx_whoawhoawhoa_1.wav",1},
	["DX: Whoa #2"]							=	{"taunts/ph_enhanced/dx_whoawhoawhoa_2.wav",1},
	["SPAGHET"]								=	{"taunts/ph_enhanced/ext_spaghet.wav",1},
	["WHO TOUCHA MY SPAGHET"]				=	{"taunts/ph_enhanced/ext_touch_ma_spaghet.wav",2},
	["Do you know the way"]					=	{"taunts/ph_enhanced/ext_do_you_kno_de_wei.wav",1},
	["U have ebola to kno the wei"]			=	{"taunts/ph_enhanced/ext_uhaveebolatoknodewei.wav",2},
	["Angry German Kid"]					=	{"taunts/ph_enhanced/ext_angry_german_kid.wav",3},
	["Vitas: 7th Elements"]					=	{"taunts/ph_enhanced/ext_blablaahah.wav",7},
	["I hate you"]							=	{"taunts/ph_enhanced/ext_crackmod_ihateyou.wav",1},
	["I watch your rear"]					=	{"taunts/ph_enhanced/ext_crackmod_watchyourrear.wav",2},
	["You damn Ugly"]						=	{"taunts/ph_enhanced/ext_crackmod_youareugly.wav",1},
	["Dance Music"]							=	{"taunts/ph_enhanced/ext_dance_music.wav",6},
	["MLG: GET NO SCOPE"]					=	{"taunts/ph_enhanced/ext_get_no_scope.wav",4},
	["MLG: GET THE CAMERA"]					=	{"taunts/ph_enhanced/ext_getcamera.wav",13},
	["MLG: OH ITS TRIPLE"]					=	{"taunts/ph_enhanced/ext_mlg_triple.wav",5},
	["Bicycle Bell"]						=	{"taunts/ph_enhanced/ext_bicycle_bell.wav",1},
	["Ding"]								=	{"taunts/ph_enhanced/ext_cling.wav",1},
	["AND III ALWAYS LOVE YOU"]				=	{"taunts/ph_enhanced/ext_and_iiiiiiiiiiiiiiiiiiii.wav",12},
	["The Rude of Storming Sand"]			=	{"taunts/ph_enhanced/ext_darude.wav",7},
	["Deaugh"]								=	{"taunts/ph_enhanced/ext_deaugh.wav",1},
	["CDI Die"]								=	{"taunts/ph_enhanced/ext_die.wav",1},
	["CDI Oah"]								=	{"taunts/ph_enhanced/ext_oah.wav",1},
	["Heres some cash goys"]				=	{"taunts/ph_enhanced/ext_dosh1.wav",1},
	["Loadsam money"]						=	{"taunts/ph_enhanced/ext_dosh2.wav",2},
	["Who needed money"]					=	{"taunts/ph_enhanced/ext_dosh3.wav",1},
	["Money money money"]					=	{"taunts/ph_enhanced/ext_dosh4.wav",1},
	["Dosh grab it while you can"]			=	{"taunts/ph_enhanced/ext_dosh5.wav",2},
	["Dun dun duuuun"]						=	{"taunts/ph_enhanced/ext_dundundun.wav",4},
	["Derpy fart"]							=	{"taunts/ph_enhanced/ext_fart1.wav",1},
	["Nice fart"]							=	{"taunts/ph_enhanced/ext_fart2.wav",1},
	["Auffwauffderp"]						=	{"taunts/ph_enhanced/ext_fdsa.wav",4},
	["Game Over"]							=	{"taunts/ph_enhanced/ext_gameover.wav",7},
	["Game Over mario"]						=	{"taunts/ph_enhanced/ext_gameover_mario.wav",2},
	["Get out of Here stalker"]				=	{"taunts/ph_enhanced/ext_getoutofhere_stalker.wav",2},
	["GET TO THE CHOPPA"]					=	{"taunts/ph_enhanced/ext_get_to_the_choppa.wav",5},
	["Idiots #1"]							=	{"taunts/ph_enhanced/ext_idiots_1.wav",8},
	["Idiots #2"]							=	{"taunts/ph_enhanced/ext_idiots_2.wav",7},
	["This is Illegal"]						=	{"taunts/ph_enhanced/ext_illegal.wav",2},
	["JASONNN"]								=	{"taunts/ph_enhanced/ext_jason1.wav",1},
	["JASON!"]								=	{"taunts/ph_enhanced/ext_jason2.wav",1},
	["JASON"]								=	{"taunts/ph_enhanced/ext_jason3.wav",1},
	["Jim Carrey REMIX"]					=	{"taunts/ph_enhanced/ext_jim_carrey.wav",7},
	["AND HIS NAME IS JOHN CENA"]			=	{"taunts/ph_enhanced/ext_johncena.wav",10},
	["AND HIS NAME IS JOHN CENA REMIX"]		=	{"taunts/ph_enhanced/ext_johncena_remix.wav",10},
	["No way"]								=	{"taunts/ph_enhanced/ext_nowai.wav",2},
	["Remove Freeman"]						=	{"taunts/ph_enhanced/ext_remove_kebab.wav",18},
	["SHUT UP"]								=	{"taunts/ph_enhanced/ext_shutuuuuuuup.wav",2},
	["JC2: No no no"]						=	{"taunts/ph_enhanced/jc2_nonono.wav",1},
	["JC2: no way"]							=	{"taunts/ph_enhanced/jc2_nowai.wav",2},
	["JC2: You Son of a Bee"]				=	{"taunts/ph_enhanced/jc2_usonova_bee.wav",2},
	["Shia Labeouf: JUST DO IT"]			=	{"taunts/ph_enhanced/just_doit1.wav",1},
	["Shia Labeouf: DO IT"]					=	{"taunts/ph_enhanced/just_doit2.wav",1},
	["Hula Dance"]							=	{"taunts/ph_enhanced/ext_huladance.wav",7},
	["X Files"]								=	{"taunts/ph_enhanced/ext_illuminaty.wav",8},
	["Lovely hehe"]							=	{"taunts/ph_enhanced/ext_lovely_hehe_mp4.wav",1},
	["Yeah Boy"]							=	{"taunts/ph_enhanced/ext_yeahboy_mp4.wav",1},
	["MY LEG"]								=	{"taunts/ph_enhanced/ext_my_leg.wav",1},
	["JOHN FREEMANS WEPON"]					=	{"taunts/ph_enhanced/ext_wepon.wav",11},
	["OOOOOOOOH"]							=	{"taunts/ph_enhanced/ext_woo.wav",14},
	["Uuf"]									=	{"taunts/ph_enhanced/ext_oof_minecraft.wav",1},
	["Oof"]									=	{"taunts/ph_enhanced/ext_oof_roblox.wav",1},
	["Cloaker"]								=	{"taunts/ph_enhanced/ext_pd2_cloaker.wav",4},
	["WOOOOH"]								=	{"taunts/ph_enhanced/ext_pyrocynical_woo.wav",1},
	["Boom"]								=	{"taunts/ovcr/Boomboomboomboom.mp3",14},
	["Trololol"]							=	{"taunts/ovcr/Trololol.mp3",10},
	["I just met you"]						=	{"taunts/ovcr/Ijustmetyou.mp3",8},
	["What is love"]						=	{"taunts/ovcr/Whatislove.mp3",31},
	["Funkytown"]							= 	{"taunts/ovcr/Funkytown.mp3",12},
	["HEYYEYAAEYAAAEYAEYAA"]				=	{"taunts/ovcr/Hurhurhyahyahya.mp3",14},
	["Squee"]								=	{"taunts/ovcr/squee.mp3",1},
	["Americano"]							=	{"taunts/ovcr/americano.mp3",30},
	["Nuke"]								=	{"taunts/ovcr/tac_nuke.mp3",4},
	["Inspector pingas"]					= 	{"taunts/ovcr/inspectorpingas1.mp3",5},
	["Thomas"]								=	{"taunts/ovcr/thomas1.mp3",8},
	["Sax poursuite"]						=	{"taunts/ovcr/yakety_sax.mp3",16},
	["Give me back my son"]					=	{"taunts/ovcr/gimmebackmyson1.mp3",4},
	["MLG"]									=	{"taunts/ovcr/mlg.mp3",3},
	["Gay"]									=	{"taunts/ovcr/hah_gay.mp3",3},
	["Eheh"]								=	{"taunts/ovcr/eheheheheheh1.mp3",5},
	["Horn"]								=	{"taunts/ovcr/horn1.mp3",4},
	["Sand man"]							=	{"taunts/ovcr/sandman.mp3",22},
	["Eheh2"]								=	{"taunts/ovcr/ehehe1.mp3",3},
	["Smell like power"]					=	{"taunts/ovcr/smells_like_power.mp3",8},
	["Scream"]								=	{"taunts/ovcr/screams.mp3",4},
	["Victoire FinalFantasy"]				=	{"taunts/ovcr/finalfantasyvictory.mp3",4},
	["Dirty bit"]							=	{"taunts/ovcr/dirtybit.mp3",7},
	["Chewbacca"]							=	{"taunts/ovcr/chewbacca.mp3",1},
	["Bat Cat"]								=	{"taunts/ovcr/batcat.mp3",20},
	["Suh"]									=	{"taunts/ovcr/suh.mp3",1},
	["Giggity"]								= 	{"taunts/ovcr/giggitygiggity.mp3",3},
	["Dramatic"]							=	{"taunts/ovcr/dramatic.mp3",5},
	["Chicken song"]						=	{"taunts/ovcr/chickensong.mp3",13},
	["Bruh"]								=	{"taunts/ovcr/bruh.mp3",1},
	["Surprise mother fucker"]				=	{"taunts/ovcr/suprisemotherfucker1.mp3",1},
	["Happy tree friend"]					=	{"taunts/ovcr/happytreefriends.mp3",16},
	["Duck hunt dog"]						=	{"taunts/ovcr/duckhuntdoglaugh.mp3",2},
	["Colossuyale"]							=	{"taunts/ovcr/colossusyale.mp3",3},
	["Burned"]								=	{"taunts/ovcr/burned.mp3",1},
	["Minion song"]							=	{"taunts/ovcr/ymca.mp3",5},
	["Hey apple"]							=	{"taunts/ovcr/heyapple.mp3",5},
	["Squeezy"]								=	{"taunts/ovcr/easypeasylemonsqueezy.mp3",3},
	["Oh yea wake up yea"]					= 	{"taunts/ovcr/ohyeahwakeupyeah.mp3",4},
	["Cavalerie"]							=	{"taunts/ovcr/cavalrycharge.mp3",4},
	["Thème angrybird"]						=	{"taunts/ovcr/angrybirdstheme.mp3",20},
	["Thug life"]							=	{"taunts/ovcr/thuglife.mp3",17},
	["Shut the fuck up"]					= 	{"taunts/ovcr/shutthefuckup.mp3",15},
	["French kankan Lalala"]				=	{"taunts/ovcr/nostalgiacriticthelaw.mp3",14},
	["Coin"]								=	{"taunts/ovcr/cuek.mp3",1},
	["True lalala"]							=	{"taunts/ovcr/lalalalala.mp3",12},
	["I like trains"]						=	{"taunts/ovcr/iliketrains.mp3",1},
	["Timmy"]								=	{"taunts/ovcr/timmy.mp3",3},
	["Silence, I kill you"]					=	{"taunts/ovcr/silenceikillyou.mp3",5},
	["Theme pacman"]						=	{"taunts/ovcr/pacmantheme.mp3",5},
	["Murloc"]								=	{"taunts/ovcr/murloc.mp3",2},
	["I'm firing with my lazor"]			=	{"taunts/ovcr/lazor.mp3",3},
	["I'm your father"]						=	{"taunts/ovcr/imyourfather.mp3",4},
	["Secret zelda"]						=	{"taunts/ovcr/zeldasecret.mp3",2},
	["Victory"]								=	{"taunts/ovcr/victoryff.mp3",4},
	["Spanish flea"]						=	{"taunts/ovcr/spanishflea.mp3",13},
	["Pedobear song"]						=	{"taunts/ovcr/pedobearsong.mp3",15},
	["Nba"]									=	{"taunts/ovcr/nba.mp3",13},
	["I see you"]							=	{"taunts/ovcr/iseeyou.mp3",6},
	["What the fuck"]						=	{"taunts/ovcr/whatthefuck.mp3",4},
	["Wakawaka"]							=	{"taunts/ovcr/wakawaka.mp3",4},
	["Rabbids"]								=	{"taunts/ovcr/rabbids.mp3",2},
	["Nein nein nein"]						=	{"taunts/ovcr/nein.mp3",3},
	["J'ai pas d'idée pour celui la"]		=	{"taunts/ovcr/moseisleycantina.mp3",15},
	["Just can't get enough"]				=	{"taunts/ovcr/justcantgetenough.mp3",11},
	["Merrygo1"]							=	{"taunts/ovcr/merrygo1.mp3",15},
	["Chacarron"]							=	{"taunts/ovcr/chacarron.mp3",8},
	["Michael jack 1"]						=	{"taunts/ovcr/michaeljack1.mp3",21},
	["Merrygo 2"]							=	{"taunts/ovcr/merrygo2.mp3",18},
	["Michael jack 2"]						=	{"taunts/ovcr/michaeljack2.mp3",15},
	["Nyancat"]								=	{"taunts/ovcr/nyancat.mp3",17},
	["Merrygo 3"]							=	{"taunts/ovcr/merrygo3.mp3",14},
	["Party Rock"]							=	{"taunts/ovcr/partyrock.mp3",13},
	["Raspberries"]							=	{"taunts/ovcr/raspberries.mp3",19},
	["Rich round"]							=	{"taunts/ovcr/rightround.mp3",8},
	["Spazz 1"]								=	{"taunts/ovcr/spazz1.mp3",11},
	["Spazz 2"]								=	{"taunts/ovcr/spazz2.mp3",11},
	["Dance of the sugar"]					=	{"taunts/ovcr/danceofthesugar1.mp3",21},
	["Right round"]							=	{"taunts/ovcr/spinmeround.mp3",7},
	["Jihad"]								=	{"taunts/ovcr/jihad.mp3",3},
	["Etalon du cul"]						=	{"taunts/ovcr/etalon_cul.mp3",8},
	["Roi"]									=	{"taunts/ovcr/inconnus_roi.mp3",4},
	["Let's get it started"]				=	{"taunts/ovcr/letsgetitstarted.mp3",5},
	["Can't touch this"]					=	{"taunts/ovcr/canttouchthis.mp3",8}, 
	["Nuke"]								=	{"taunts/ovcr/tacticalnuke.mp3",6},
	["Nomnom"]								=	{"taunts/ovcr/dn0002.mp3",2},
	["Damn Son"]							=	{"taunts/ovcr/dn0037.mp3",14},
	["Honey"]								=	{"taunts/ovcr/ih0052.mp3",8},
	["Romtomtom"]							=	{"taunts/ovcr/rrrhomtom.mp3",9},
	["Mine"]								=	{"taunts/ovcr/mineminemine.mp3",12},
	["Ouih"]								=	{"taunts/ovcr/ouih.mp3",14},
	["Baka baka"]							=	{"taunts/ovcr/cirno.mp3",25},
	["Highscore"]							=	{"taunts/ovcr/highscore.mp3",18},
	["Knaki ball"]							=	{"taunts/ovcr/knacki.mp3",11},
	["Promise"]								=	{"taunts/ovcr/promise.mp3",24},
	["Megaman Castle"]						=	{"taunts/ovcr/mmcastle1.mp3",28},
	["Savage"]								=	{"taunts/ovcr/savage.mp3",17},
	["Sm fouet"]							=	{"taunts/ovcr/sf-fouet3.mp3",1},
	["Siflet"]								=	{"taunts/ovcr/sifflet2.mp3",1},
	["Zombienation"]						=	{"taunts/ovcr/zombienation.mp3",12},
	["Zombie appocalypse"]					=	{"taunts/ovcr/unicorne.mp3",17},
	["Swiss"]								=	{"taunts/ovcr/swiss.mp3",15},
	["Caramell dansen"]						=	{"taunts/ovcr/caramell.mp3",25},
	["Peanut butter 1"]						=	{"taunts/ovcr/peanutbutter1.mp3",7},
	["Peanut butter 2"]						=	{"taunts/ovcr/peanutbutter2.mp3",11},
	["Wiggle"]								=	{"taunts/ovcr/wiggle.mp3",16},
	["Woaw"]								=	{"taunts/ovcr/woaw.mp3",8},
	["Wrecking ball"]						=	{"taunts/ovcr/wreckingball.mp3",20},
	["Yukki"]								=	{"taunts/ovcr/yukiyukiyuki.mp3",15},
	["My dick"]								=	{"taunts/ovcr/dick.mp3",16},
	["Wrecking ball"]						=	{"taunts/ovcr/wreckingball.mp3",20},
	["Yukki"]								=	{"taunts/ovcr/yukiyukiyuki.mp3",15},
	["My dick"]								=	{"taunts/ovcr/dick.mp3",16},
	["Je veut te voir"]						=	{"taunts/ovcr/jeveuxtevoir.mp3",30},
	["Jackie et Michel"]					=	{"taunts/ovcr/jm.mp3",12},
	["Lama"]								=	{"taunts/ovcr/lama.mp3",14},
	["Mia khalifa"]							=	{"taunts/ovcr/miakhalifa.mp3",20},
	["Thirdeyeya"]							=	{"taunts/ovcr/thirdeyeya.mp3",22},
	["Thx Dvd"]								=	{"taunts/ovcr/thx-dvd.mp3",28},
	["Etoile mario"]						=	{"taunts/ovcr/1-146.mp3",9},
	["Poney"]								=	{"taunts/ovcr/1-144.mp3",9},
	["Pudi pudi"]							=	{"taunts/ovcr/1-152.mp3",15},
	["Alloyrun"]							=	{"taunts/ovcr/alloyrun2.mp3",45},
	["Daddy"]								=	{"taunts/ovcr/daddy.mp3",17},
	["Fox 3"]								=	{"taunts/ovcr/fox3.mp3",6},
	["Tetris 1"]							=	{"taunts/ovcr/tetrislol.mp3",13},
	["Tetris 2"]							=   {"taunts/ovcr/tetrisjapwtf.mp3",22},
	["Radio portal"]						=	{"taunts/ovcr/portalradio.mp3",19},
	["Gmod gimn"]							=	{"taunts/ovcr/gmodgimn.mp3",8},
	["Do it"]								=	{"taunts/ovcr/doit.mp3",30},
	["Assassin des templiers"]				=	{"taunts/ovcr/assassin.mp3",20},
	["I'm a banana"]						=	{"taunts/ovcr/1-99.mp3",10},
	["Nyan cat remix"]						=	{"taunts/ovcr/1-96.mp3",30},
	["Trouble"]								=	{"taunts/ovcr/1-88a.mp3",37},
	["Levan polka"]							=	{"taunts/ovcr/1-210.mp3",26},
	["Gohst busters"]						=	{"taunts/ovcr/1-217.mp3",19},
	["Tu m'aura pas"]						=	{"taunts/ovcr/tumaurapas.mp3",2},
	["Smoke weed every day"]				=	{"taunts/ovcr/1-87.mp3",16},
	["Ts song"]								=	{"taunts/ovcr/ts3.mp3",30},
	["Bass canon"]							=	{"taunts/ovcr/basscanon.mp3",29},
	["Drop it"]								=	{"taunts/ovcr/drop.mp3",15},
	["Gta Boy"]								=	{"taunts/ovcr/gtaboy.mp3",16},
	["Des pompes, des tractions"]			=	{"taunts/ovcr/pompesettractions.mp3",24},
	["Dididou"]								=	{"taunts/ovcr/1-218.mp3",7},
	["Sourie verte"]						=	{"taunts/ovcr/sourieverte.mp3",18},
	["So fresh"]							=	{"taunts/ovcr/sofresh.mp3",10},
	["Thug"]								=	{"taunts/ovcr/thug.mp3",17},
	["Carte kiwi"]							=	{"taunts/ovcr/cartekiwi.mp3",8},
	["Drop it goat"]						=	{"taunts/ovcr/dropitgoat.mp3",16},
	["Poker face"]							=	{"taunts/ovcr/pokerfacecartman.mp3",24},
	["Skrillex"]							=	{"taunts/ovcr/skrilexplayingthevinil.mp3",10},
	["Psy hurlement"]						=	{"taunts/ovcr/1-231.mp3",17},
	["Sardines"]							=	{"taunts/ovcr/sardines.mp3",12},
	["Kidcudi"]								=	{"taunts/ovcr/kidcudi.mp3",30},
	["Madavergar"]							=	{"taunts/ovcr/madavergar3.mp3",8},
	["Century"]								=	{"taunts/ovcr/century.mp3",20},
	["Fox 1"]								=	{"taunts/ovcr/fox1.mp3",6},
    ["Jpsong"]                              =	{"taunts/ovcr/jpsong1.mp3",17},
	["Papyrus"]                             =   {"taunts/ovcr/papyrus.mp3",26},
	["Ronald insanity"]                     =   {"taunts/ovcr/ronaldinsanity.mp3",19},
    ["1-236"]                               =   {"taunts/ovcr/1-236.mp3",30},
	["Ameno"]                               =   {"taunts/ovcr/ameno.mp3",10},
	["Baguette"]                            =   {"taunts/ovcr/baguette.mp3",2},
	["Internet"]                            =   {"taunts/ovcr/internet.mp3",22},
    ["Chante chante chante"]                =   {"taunts/ovcr/chanteschanteschantes.mp3",15},
	["Fox 2"]                               =   {"taunts/ovcr/fox2.mp3",6},
	["Letitgomlg"]                          =   {"taunts/ovcr/letitgomlg.mp3",21},
	["Papaya"]                              =   {"taunts/ovcr/papaya.mp3",3},
	["Quenouilles"]                         =   {"taunts/ovcr/quenouilles.mp3",8},
	["Alerte au gogole"]                    =   {"taunts/ovcr/alertaugogole.mp3",4},
	["Durka durk"]                          =   {"taunts/ovcr/durka_durk.mp3",5},
	["Illuminati"]                          =   {"taunts/ovcr/illuminati.mp3",23},
	["Boule"]                               =   {"taunts/ovcr/boule.mp3",15},
	["Congolexicomatisation"]               =   {"taunts/ovcr/congolexicomatisation.mp3",32},
	["Fox 4"]                               =   {"taunts/ovcr/fox4.mp3",6},
	["Miku"]                                =   {"taunts/ovcr/miku.mp3",21},
	["Omfghello"]                           =   {"taunts/ovcr/omfghello.mp3",17},
	["Mario wtf"]                           =   {"taunts/ovcr/mariowtf.mp3",18},
	["Charge"]                              =   {"taunts/ovcr/charge.mp3",3},
	["Ball of steel"]                       =   {"taunts/ovcr/ballofsteel.mp3",2},
	["Connard 1"]                           =   {"taunts/ovcr/connards1.mp3",37},
	["Connard 2"]                           =   {"taunts/ovcr/connards2.mp3",31},
	["Darude"]                              =   {"taunts/ovcr/darude.mp3",13},
	["Final count"]                       	=   {"taunts/ovcr/finalcount.mp3",18},
	["Flop 2"]                              =   {"taunts/ovcr/flop.mp3",19},
	["Mission 1"]                           =   {"taunts/ovcr/mission1.mp3",31},
	["Mission 2"]                           =   {"taunts/ovcr/mission2.mp3",30},
	["Touhou"]                            	=   {"taunts/ovcr/touhou.mp3",15},
	["Dempagumi"]                           =   {"taunts/ovcr/dempagumi.mp3",29},
	["Boom bitch"]                          =   {"taunts/ovcr/boombitch.mp3",11},
	["Chelou"]                              =   {"taunts/ovcr/chelou.mp3",12},
	["Einnob"]                              =   {"taunts/ovcr/einnoob.mp3",12},
	["Surprise"]                            =   {"taunts/ovcr/surprise.mp3",1},
	["Western"]                             =   {"taunts/ovcr/western.mp3",8},
	["Arbre"]                               =   {"taunts/ovcr/arbre.mp3",15},
	["Souffrir 2"]                          =   {"taunts/ovcr/souffrir2.mp3",23},
	["Exorcist"]                            =   {"taunts/ovcr/exorcist.mp3",10},
	["Rainbow"]                             =   {"taunts/ovcr/rainbow.mp3",16},
	["Shooting stars"]                      =   {"taunts/ovcr/Shootingstars.mp3",19},
	["Macklemore"]                          =   {"taunts/ovcr/macklemore.mp3",10},
	["Orange"]                              =   {"taunts/ovcr/Orange.mp3",9},
	["Ca peps en bouche"]                   =   {"taunts/ovcr/Ca_peps_en_bouche.mp3",20},
	["Dun dun"]                             =   {"taunts/ovcr/Dun_Dun.mp3",4},
	["Dun"]                                 =   {"taunts/ovcr/Dun.mp3",1},
	["Bipbip"]                              =   {"taunts/ovcr/bipbip.mp3",1},
	["Ole"]                                 =   {"taunts/ovcr/ole.mp3",3},
	["Ole 2"]                               =   {"taunts/ovcr/ole2.mp3",3},
	["Olivier"]                             =   {"taunts/ovcr/olivier.mp3",2},
	["Sncf"]                                =   {"taunts/ovcr/sncf.mp3",3},
	["Coucou"]                              =   {"taunts/ovcr/Coucou.mp3",2},
	["Money"]                               =   {"taunts/ovcr/Money.mp3",5},
	["Mario 1"]                             =   {"taunts/ovcr/Mario1.mp3",2},
	["Mario 2"]                             =   {"taunts/ovcr/mario2.mp3",1},
	["Mario 3"]                             =   {"taunts/ovcr/Mario3.mp3",1},
	["Maurice"]                             =   {"taunts/ovcr/Maurice.mp3",3},
	["Ta mere"]                             =   {"taunts/ovcr/Ta_mere.mp3",12},
	["Mario musique"]                       =   {"taunts/ovcr/Mario_musique.mp3",29},
	["Une fraise"]                          =   {"taunts/ovcr/une_fraise.mp3",1},
	["Il a dit wallah"]						=	{"taunts/ovcr/ah_bah_il_a_dit_wallah_misterv.mp3",11},
	["Ah denis"]							=	{"taunts/ovcr/ah_denis_brogniart.mp3",1},
	["Très bonne question"]					=	{"taunts/ovcr/ah_tres_bonne_question.mp3",4},
	["Ahhhh"]								=	{"taunts/ovcr/ahhhh.mp3",1},
	["Amour Bernard 1"]						=	{"taunts/ovcr/amour_bernard1.mp3",4},
	["Amour Bernard 2"]						=	{"taunts/ovcr/amour_bernard2.mp3",11},
	["Tk78 anglais"]						=	{"taunts/ovcr/anglais_tk.mp3",22},
	["Applause"]							=	{"taunts/ovcr/applause.mp3",9},
	["Arab Skydiver"]						=	{"taunts/ovcr/arab_skydiver_allahu_akbar.mp3",20},
	["Attention MisterV"]					=	{"taunts/ovcr/attention_misterv.mp3",2},
	["Avengers"]							=	{"taunts/ovcr/avengers.mp3",12},
	["Badumtss"]							=	{"taunts/ovcr/badumtss_swf.mp3",2},
	["Bat les couilles"]					=	{"taunts/ovcr/bat_les_couilles.mp3",1},
	["Bat les couilles MisterV"]			=	{"taunts/ovcr/bat_les_couilles_misterv.mp3",1},
	["Bisous les michtos"]					=	{"taunts/ovcr/bisous_les_michtos.mp3",4},
	["Bomb has been defused"]				=	{"taunts/ovcr/bomb_has_been_defused.mp3",4},
	["Bomfunk freestyle"]					=	{"taunts/ovcr/bomfunk_freestyle.mp3",7},
	["Bonne bite sa mère MisterV"]			=	{"taunts/ovcr/bonne_bite_sa_mere_misterv.mp3",6},
	["Bravo Nils"]							=	{"taunts/ovcr/bravo_nils.mp3",5},
	["Tk78 ça marche pas"]					=	{"taunts/ovcr/ca_marche_pas_tk.mp3",1},
	["C'est honteux"]						=	{"taunts/ovcr/cest_honteux.mp3",1},
	["C'est l'heure du du duel"]			=	{"taunts/ovcr/cest_lheure_du_du_duel.mp3",5},
	["C'est ma teub MisterV"]				=	{"taunts/ovcr/cest_ma_teub_misterv.mp3",6},
	["C'est normal en Russie"]				=	{"taunts/ovcr/cest_normal_en_russie.mp3",3},
	["C'est notre projet Macron"]			=	{"taunts/ovcr/cest_notre_projet_emmanuel_macron.mp3",6},
	["C'est pas toi qui décide Fanta"]		=	{"taunts/ovcr/cest_pas_toi_qui_decide_fanta.mp3",2},
	["C'était sûr Sardoche"]				=	{"taunts/ovcr/cetait_sur_sardoche.mp3",3},
	["Chatte en pièce jointe"]				=	{"taunts/ovcr/chatte_en_pj.mp3",4},
	["Commence à me parler poliment"]		=	{"taunts/ovcr/commence_a_me_parler_poliment.mp3",2},
	["Comment je nique ta mère"]			=	{"taunts/ovcr/comment_je_nique_ta_mere.mp3",6},
	["Tk78 compte twitter"]					=	{"taunts/ovcr/compte_twitter_tk.mp3",1},
	["Tk78 coup de coude"]					=	{"taunts/ovcr/coup_de_coude_tk.mp3",1},
	["Creeper revenge"]						=	{"taunts/ovcr/creeper_revenge.mp3",2},
	["Crickets"]							=	{"taunts/ovcr/crickets_swf.mp3",5},
	["Tk78 dinosaure"]						=	{"taunts/ovcr/dinosaure_tk.mp3",1},
	["Discord call sound"]					=	{"taunts/ovcr/discord_call_sound.mp3",5},
	["Discord join"]						=	{"taunts/ovcr/discord_join.mp3",1},
	["Discord leave"]						=	{"taunts/ovcr/discord_leave.mp3",1},
	["Discord mute"]						=	{"taunts/ovcr/discord_mute.mp3",1},
	["Discord notification"]				=	{"taunts/ovcr/discord_notification.mp3",1},
	["Dun dun laws and order"]				=	{"taunts/ovcr/dun_dun_laws_and_order.mp3",1},
	["Embrouille en France MisterV"]		=	{"taunts/ovcr/embrouille_en_france_misterv.mp3",11},
	["Windows error"]						=	{"taunts/ovcr/windows_error.mp3",1},
	["Et en plus t'es moche"]				=	{"taunts/ovcr/et_en_plus_tes_moche_misterv.mp3",12},
	["Exactement ouais ouais"]				=	{"taunts/ovcr/exactement-ouais-ouais-ouais-ouais-tes-bien-renseigne-toi.mp3",3},
	["Fake news great"]						=	{"taunts/ovcr/fake-news-great.mp3",4},
	["Fatality"]							=	{"taunts/ovcr/fatality_swf.mp3",2},
	["FBI open the door"]					=	{"taunts/ovcr/fbi-open-the-door.mp3",4},
	["Tk78 fdp ma lumière"]					=	{"taunts/ovcr/fdp_ma_lumiere_tk.mp3",1},
	["Tk78 fdp"]							=	{"taunts/ovcr/fdp_tk.mp3",1},
	["Tk78 fdp 2"]							=	{"taunts/ovcr/fdp2_tk.mp3",1},
	["Ferme ta gueule salope"]				=	{"taunts/ovcr/ferme_ta_gueule_salope.mp3",4},
	["Fils d'unijambiste"]					=	{"taunts/ovcr/fils-dunijambiste.mp3",4},
	["Fort boyard"]							=	{"taunts/ovcr/fort-boyard.mp3",18},
	["Fortnite default dance boosted"]		=	{"taunts/ovcr/fortnite-default-dance-bass-boosted.mp3",7},
	["Fuck fuck fuck fuck"]					=	{"taunts/ovcr/fuck-fuck-fuck-fuck-fuuuuuck.mp3",10},
	["Fus ro dah"]							=	{"taunts/ovcr/fus-ro-dah.mp3",11},
	["Tk78 gogole"]							=	{"taunts/ovcr/gogole_tk.mp3",3},
	["Goût ma bite MisterV"]				=	{"taunts/ovcr/gout_ma_bite_misterv.mp3",5},
	["GTA san andreas"]						=	{"taunts/ovcr/gta-san-andreas.mp3",16},
	["Guillaume le thug MisterV"]			=	{"taunts/ovcr/guillaume_le_thug_misterv.mp3",4},
	["Hallelujah"]							=	{"taunts/ovcr/hallelujahshort_swf.mp3",2},
	["Hallucination collective Sylvain"]	=	{"taunts/ovcr/hallucination_collective_sylvain.mp3",3},
	["HARRY POTTER BOSOTED"]				=	{"taunts/ovcr/HARRY_POTTER_BOSOTED.mp3",9},
	["Hendek 1"]							=	{"taunts/ovcr/hendek1.mp3",5},
	["Hendek 2"]							=	{"taunts/ovcr/hendek2.mp3",1},
	["Hendek 3"]							=	{"taunts/ovcr/hendek3.mp3",1},
	["Hey listen"]							=	{"taunts/ovcr/hey_listen.mp3",2},
	["Il a fait prout"]						=	{"taunts/ovcr/il_a_fait_prout.mp3",8},
	["Inception button"]					=	{"taunts/ovcr/inceptionbutton.mp3",3},
	["Windows start"]						=	{"taunts/ovcr/windows-start.mp3",4},
	["Tk78 intro gotaga"]					=	{"taunts/ovcr/intro_gotaga_tk.mp3",32},
	["It is what it is"]					=	{"taunts/ovcr/it_is_what_it_is.mp3",4},
	["J'ai glissé chef"]					=	{"taunts/ovcr/jai-glisse-chef.mp3",2},
	["J'apprécie à moitié"]					=	{"taunts/ovcr/japprecie_a_moitie_ce_qui_vient_de_se_passer.mp3",3},
	["Je ne suis pas un homme"]				=	{"taunts/ovcr/je_ne_suis_pas_un_homme_monsieur.mp3",3},
	["Tk78 Je pensais pas ça de toi"]		=	{"taunts/ovcr/je_pensais_pas_ca_de_toi_tk.mp3",2},
	["Jeanne au secours earrape"]			=	{"taunts/ovcr/jeanne_au_secours_earrape.mp3",2},
	["Je code avec le cul"]					=	{"taunts/ovcr/je-code-avec-le-cul.mp3",18},
	["Je me present Sylvain"]				=	{"taunts/ovcr/je-me-presente_sylvain.mp3",4},
	["J'en ai rien à foutre Siphano"]		=	{"taunts/ovcr/jen_ai_rien_a_foutre_siphano.mp3",1},
	["Joke drum"]							=	{"taunts/ovcr/joke_drum_effect.mp3",2},
	["Joris le con MisterV"]				=	{"taunts/ovcr/joris_le_con_misterv.mp3",2},
	["La photo fils de pute"]				=	{"taunts/ovcr/la_photo_fils_de_pute.mp3",5},
	["Tk78 la ps4"]							=	{"taunts/ovcr/la_ps4_tk.mp3",6},
	["Lache moi Michel"]					=	{"taunts/ovcr/lache_moi_michel.mp3",3},
	["Tk78 le grand père"]					=	{"taunts/ovcr/le_grand_pere_tk.mp3",3},
	["Plein le cul des arabes"]				=	{"taunts/ovcr/les_gens_en_ont_plein_le_cul_des_arabes.mp3",2},
	["Chez pute les nuls"]					=	{"taunts/ovcr/les_nuls_chez_pute.mp3",20},
	["Ta geule jojobernard"]				=	{"taunts/ovcr/mais-putain-ta-gueule_jojobernard.mp3",7},
	["Maskey bat les couilles"]				=	{"taunts/ovcr/maskey_bat_les_couilles.mp3",6},
	["Maskey bsahtek le génie"]				=	{"taunts/ovcr/maskey_bsahtek_le_genie.mp3",6},
	["Maskey cheh"]							=	{"taunts/ovcr/maskey_cheh.mp3",5},
	["Maskey double toz"]					=	{"taunts/ovcr/maskey_double_toz.mp3",7},
	["Maskey fils de pute"]					=	{"taunts/ovcr/maskey_fils_de_pute.mp3",7},
	["Maskey lisa la 2000"]					=	{"taunts/ovcr/maskey_lisa_la_2000.mp3",23},
	["Maskey j'ai la flemme"]				=	{"taunts/ovcr/maskey_jai la flemme.mp3",5},
	["Meep meep"]							=	{"taunts/ovcr/meep_meep.mp3",1},
	["Metal gear solide"]					=	{"taunts/ovcr/metal_gear_solide.mp3",2},
	["Minecraft_eating"]					=	{"taunts/ovcr/minecraft_eating.mp3",2},
	["Minecraft enderman"]					=	{"taunts/ovcr/minecraft_enderman.mp3",1},
	["Minecraft villager"]					=	{"taunts/ovcr/minecraft-villager.mp3",1},
	["Coucou miss jirachi"]					=	{"taunts/ovcr/miss_jirachi_coucou.mp3",1},
	["MLG song"]							=	{"taunts/ovcr/mlg_song.mp3",7},
	["MLG airhorn"]							=	{"taunts/ovcr/mlg-airhorn.mp3",3},
	["Tk78 mon rep"]						=	{"taunts/ovcr/mon_rep_se_pose_des_questions_tk.mp3",3},
	["Monster inc earrape"]					=	{"taunts/ovcr/monster_inc_ear_rape.mp3",13},
	["Tk78 musique 1"]						=	{"taunts/ovcr/musique1_tk.mp3",13},
	["Tk78 musique 2"]						=	{"taunts/ovcr/musique2_tk.mp3",7},
	["Ne t'inquiète pas"]					=	{"taunts/ovcr/ne_tinquiete_pas.mp3",7},
	["Never gonna give you up"]				=	{"taunts/ovcr/nevergonnagive.mp3",17},
	["Nique ta mère Le Pen"]				=	{"taunts/ovcr/nique_ta_mere_lepen.mp3",2},
	["Nique ta mère MisterV"]				=	{"taunts/ovcr/nique_ta_mere_misterv.mp3",7},
	["Nooo"]								=	{"taunts/ovcr/nooo_swf.mp3",6},
	["Nope engineer"]						=	{"taunts/ovcr/nope_engineer_tf2.mp3",1},
	["Not to be racist or anything"]		=	{"taunts/ovcr/not-to-be-racist-or-anything.mp3",5},
	["Nous somme en guerre 1"]				=	{"taunts/ovcr/nous_somme_en_guerre1_emmanuel_macron.mp3",1},
	["Nous somme en guerre 2"]				=	{"taunts/ovcr/nous_somme_en_guerre2_emmanuel_macron.mp3",2},
	["Nyan pass"]							=	{"taunts/ovcr/nyanpass.mp3",2},
	["Oh merde oh c'est con ça"]			=	{"taunts/ovcr/oh-merde-oh-cest-con-ca.mp3",3},
	["On no Jojo"]							=	{"taunts/ovcr/oh-no_jojo.mp3",3},
	["On crame des mecs"]					=	{"taunts/ovcr/on-crame-des-mecs.mp3",5},
	["On va casser du pd"]					=	{"taunts/ovcr/on-va-casser-du-pd.mp3",5},
	["Ouais c'est pas faux"]				=	{"taunts/ovcr/ouais_cest_pas_faux.mp3",1},
	["Tk78 ouvre ta gueule"]				=	{"taunts/ovcr/ouvre_ta_gueule_tk.mp3",7},
	["Maskey parce que c'est la hess"]		=	{"taunts/ovcr/parce_que_cest_la_hess_maskey.mp3",4},
	["Partout autour de nous"]				=	{"taunts/ovcr/partout_autour_de_nous y_a_des_arabes.mp3",7},
	["Pays de galles independant"]			=	{"taunts/ovcr/pays-de-galles-independant.mp3",3},
	["Perfect fart"]						=	{"taunts/ovcr/perfect-fart.mp3",1},
	["Perlimpinpin Macron"]					=	{"taunts/ovcr/perlimpinpin_emmanuel_macron.mp3",3},
	["Peter griffin laugh"]					=	{"taunts/ovcr/peter_griffin_laugh.mp3",13},
	["Pizza time"]							=	{"taunts/ovcr/pizza-time.mp3",1},
	["Poi"]									=	{"taunts/ovcr/poi.mp3",1},
	["Tk78 musique pokemon 1"]				=	{"taunts/ovcr/pokemon_musique1_tk.mp3",9},
	["Tk78 musique pokemon 2"]				=	{"taunts/ovcr/pokemon_musique2_tk.mp3",35},
	["Popopo wtc"]							=	{"taunts/ovcr/popopo_wtc.mp3",9},
	["Primo kyogre primo groudon"]			=	{"taunts/ovcr/primo-kyogre-primo-groudon-mega-rayquaza-tout-shiney.mp3",4},
	["PS1"]									=	{"taunts/ovcr/ps1.mp3",18},
	["Tk78 PSG les kheys"]					=	{"taunts/ovcr/psg_les_kheys_tk.mp3",3},
	["Qui est le plus con Siphano"]			=	{"taunts/ovcr/qui_est_le_plus_con_dans_lhistoire_siphano.mp3",5},
	["Tk78 Rachide"]						=	{"taunts/ovcr/rachide_tk.mp3",9},
	["Tk78 rire 1"]							=	{"taunts/ovcr/rire1_tk.mp3",2},
	["Tk78 rire 2"]							=	{"taunts/ovcr/rire2_tk.mp3",3},
	["Tk78 rire 3"]							=	{"taunts/ovcr/rire3_tk.mp3",6},
	["Tk78 rire 4"]							=	{"taunts/ovcr/rire4_tk.mp3",2},
	["Risitas"]								=	{"taunts/ovcr/risitas.mp3",23},
	["Sad trombone"]						=	{"taunts/ovcr/sadtrombone_swf.mp3",4},
	["Tk78 sale batard"]					=	{"taunts/ovcr/sale_batard_tk.mp3",6},
	["Skippidy bop mmm bada"]				=	{"taunts/ovcr/skippidy_bop_mmm_bada.mp3",2},
	["Skype"]								=	{"taunts/ovcr/skype-incoming.mp3",4},
	["Smoke weed everyday"]					=	{"taunts/ovcr/smoke_weed_everyday.mp3",2},
	["Tk78 RIP la souris"]					=	{"taunts/ovcr/souris_tk.mp3",3},
	["SSBU challenger approaching"]			=	{"taunts/ovcr/ssbu_challenger_approaching.mp3",5},
	["Tk78 starfoullah"]					=	{"taunts/ovcr/starfoullah_tk.mp3",18},
	["Stromoyen MisterV"]					=	{"taunts/ovcr/stromoyen_misterv.mp3",15},
	["Suce ma bite"]						=	{"taunts/ovcr/suce_ma_bite.mp3",7},
	["Sur le coran c'est vrai"]				=	{"taunts/ovcr/sur_le_coran_cest_vrai.mp3",2},
	["Surprise motherfucker"]				=	{"taunts/ovcr/surprise-motherfucker.mp3",2},
	["Ta gueule Fanta"]						=	{"taunts/ovcr/ta_gueule_fanta.mp3",2},
	["Ta gueule tu es moche"]				=	{"taunts/ovcr/ta_gueule_tu_es_moche.mp3",4},
	["Tk78 t'as 28 ans"]					=	{"taunts/ovcr/tas_28_ans_tk.mp3",3},
	["TF1 20h"]								=	{"taunts/ovcr/tf1_20h.mp3",14},
	["Your momma dead"]						=	{"taunts/ovcr/thats_why_your_momma_dead_dead_as_hell.mp3",8},
	["The price is right losing horn"]		=	{"taunts/ovcr/the-price-is-right-losing-horn.mp3",5},
	["Nelsons haha"]						=	{"taunts/ovcr/the-simpsons-nelsons-haha.mp3",2},
	["Tk78 défoncer"]						=	{"taunts/ovcr/tk_defoncer.mp3",3},
	["Toc toc"]								=	{"taunts/ovcr/toc_toc.mp3",4},
	["Tout le monde s'en branle"]			=	{"taunts/ovcr/tout_le_monde_sen_branle.mp3",2},
	["Toute nu sur des cercueil"]			=	{"taunts/ovcr/toute_nu_cercueil.mp3",3},
	["Trisomique 1"]						=	{"taunts/ovcr/trisomique1.mp3",7},
	["Trisomique 2"]						=	{"taunts/ovcr/trisomique2.mp3",7},
	["Tu es grosse mélissandre"]			=	{"taunts/ovcr/tu_es_grosse_melissandre.mp3",2},
	["Tu te calmes Denis MisterV"]			=	{"taunts/ovcr/tu_te_calmes_denis_misterv.mp3",1},
	["Tuturu"]								=	{"taunts/ovcr/tuturu.mp3",2},
	["URSS hymne"]							=	{"taunts/ovcr/urss_hymne.mp3",17},
	["Tk78 wallah"]							=	{"taunts/ovcr/wallah_tk.mp3",1},
	["Ferme ta gueule wtc"]					=	{"taunts/ovcr/what-the-cut-ferme-ta-gueule.mp3",9},
	["J'ai envie de me suicider wtc"]		=	{"taunts/ovcr/what-the-cut-jai-envie-de-me-suicider.mp3",7},
	["Who can say where the road goes"]		=	{"taunts/ovcr/who-can-say-where-the-road-goes.mp3",12},
	["Windows XP earrape"]					=	{"taunts/ovcr/windows_xp_earrape.mp3",5},
	["Peut tu mettre wtc"]					=	{"taunts/ovcr/wtc-antoine-daniel-peut-tu-mettre-wtc-30.mp3",6},
	["Transforme tes couilles wtc"]			=	{"taunts/ovcr/wtc-antoine-daniel-transforme-tes-couilles.mp3",13},
	["Yankee with no brim"]					=	{"taunts/ovcr/yankee_with_no_brim.mp3",4},
	["YEAAAAAAAAAAAAAAAAAAH !"]				=	{"taunts/ovcr/YEAAAAAAAAAAAAAAAAAAH!.mp3",6},
	["Yoda"]								=	{"taunts/ovcr/yoda.mp3",9},
	["Yoshi tongue"]						=	{"taunts/ovcr/yoshi-tongue.mp3",1},
	["Za warudo stop time Jojo"]			=	{"taunts/ovcr/za-warudo-stop-time-sound.mp3",4},
	["Tk78 zehma"]							=	{"taunts/ovcr/zehma_tk.mp3",2},
	["Zoidberg whoop"]						=	{"taunts/ovcr/zoidberg-whoop.mp3",3},
	["America fuck yeah"]					=	{"taunts/ovcr/america_fuck_yeah.mp3",12},
	["Chinese rap"]							=	{"taunts/ovcr/chinese_rap.mp3",10},
	["I want to be ninja"]					=	{"taunts/ovcr/i_want_to_be_ninja.mp3",13},
	["Lero lero lero 1"]					=	{"taunts/ovcr/lero_lero_lero1.mp3",6},
	["Lero lero lero 2"]					=	{"taunts/ovcr/lero_lero_lero2.mp3",9},
	["Muda muda muda"]						=	{"taunts/ovcr/muda_muda_muda.mp3",5},
	["Ora ora ora"]							=	{"taunts/ovcr/ora_ora_ora.mp3",4},
	["Astronomia"]							=	{"taunts/ovcr/astronomia.mp3",31},
	["C'est la décadence"]					=	{"taunts/ovcr/cest_la_decadence.mp3",2},
	["Crab rave"]							=	{"taunts/ovcr/crab_rave.mp3",28},
	["Dance till your dead"]				=	{"taunts/ovcr/dance_till_your_dead.mp3",24},
	["Dancin Aaron Smith"]					=	{"taunts/ovcr/dancin_aaron_smith.mp3",18},
	["La colère de dieu"]					=	{"taunts/ovcr/la_colere_de_dieu.mp3",3},
	["C'est la mer noir 1"]					=	{"taunts/ovcr/mer_noir1.mp3",2},
	["C'est la mer noir 2"]					=	{"taunts/ovcr/mer_noir2.mp3",1},
	["C'est la mer noir 3"]					=	{"taunts/ovcr/mer_noir3.mp3",1},
	["C'est la mer noir 3"]					=	{"taunts/ovcr/mer_noir4.mp3",1},
	["Mexican hat dance"]					=	{"taunts/ovcr/mexican_hat_dance.mp3",17},
	["Mii channel music"]					=	{"taunts/ovcr/mii_channel_music.mp3",9},
	["Ratz générique"]						=	{"taunts/ovcr/ratz.mp3",24},
	["Shrek / all star Smash Mouth 1"]		=	{"taunts/ovcr/all_star_smash_mouth1.mp3",19},
	["Shrek / all star Smash Mouth 2"]		=	{"taunts/ovcr/all_star_smash_mouth2.mp3",18},
	["Super smash bros brawl"]				=	{"taunts/ovcr/super_smash_bros_brawl.mp3",18},
	["Tu t'appelles comment"]				=	{"taunts/ovcr/tu_tappelles_comment.mp3",10},
	["Tunak tunak tun 1"]					=	{"taunts/ovcr/tunak_tunak_tun1.mp3",16},
	["Tunak tunak tun 2"]					=	{"taunts/ovcr/tunak_tunak_tun2.mp3",29},
	["Wii sport music"]						=	{"taunts/ovcr/wii_sport.mp3",22},
	["Avouv Bernard 1"]						=	{"taunts/ovcr/avouv1.mp3",1},
	["Avouv Bernard 2"]						=	{"taunts/ovcr/avouv2.mp3",1},
	["Bébé tout bleu"]						=	{"taunts/ovcr/bebe_tout_bleu.mp3",3},
	["Bim bam boom"]						=	{"taunts/ovcr/Bim_bam_toi.mp3",9},
	["Bonsoir Paris"]						=	{"taunts/ovcr/bonsoir_paris.mp3",4},
	["Crash Bandicoot Woah"]				=	{"taunts/ovcr/Crash_Bandicoot_Woah.mp3",8},
	["GWA GWA GWA"]							=	{"taunts/ovcr/GWA_GWA_GWA_ZULUL_-_Sound_Effect.mp3",2},
	["Hunger games zombie"]					=	{"taunts/ovcr/hunger_games_zombie.mp3",10},
	["Japan"]								=	{"taunts/ovcr/japan.mp3",5},
	["Kirby54 Coup droit coup gauche"]		=	{"taunts/ovcr/Kirby-54_Esquive__coup_droit__coup_gauche_ADRIAAANE.mp3",3},
	-- BUGGED ["Kirby54 Mettez vous à quatre pattes"]	=	{"taunts/ovcr/kirby-54_mettez_vous_a_quatre_pattes_sil_vous_plait.mp3",1},
	["Marsupilami générique"]				=	{"taunts/ovcr/marsupilami.mp3",19},
	["Meow Meow Nigga"]						=	{"taunts/ovcr/meow_meow_nigga.mp3",3},
	["Pirates des caraibes"]				=	{"taunts/ovcr/Pirates_des_caraibes.mp3",18},
	["Pokiman les gens qui"]				=	{"taunts/ovcr/Pokiman_les_gens_qui_.mp3",6},
	["Pornhub"]								=	{"taunts/ovcr/Pornhub.mp3",3},
	["Kirby54 QI DE 143"]					=	{"taunts/ovcr/QI_DE_143_kirby_54.mp3",3},
	["Relax take it easy"]					=	{"taunts/ovcr/Relax_take_it_easy.mp3",17},
	["RobotRock"]							=	{"taunts/ovcr/RobotRock.mp3",19},
	["Russe qui pleure"]					=	{"taunts/ovcr/Russe_qui_pleure.mp3",6},
	["Skyrim menu"]							=	{"taunts/ovcr/Skyrim_menu.mp3",30},
	["Spider dance"]						=	{"taunts/ovcr/Spider_dance.mp3",9},
	["The weekend the hills"]				=	{"taunts/ovcr/The_weekEnd_the_hills.mp3",18},
	["Tokyo drift"]							=	{"taunts/ovcr/tokyo_drift.mp3",25},
	["Uganda knuckles clicking sound"]		=	{"taunts/ovcr/Uganda_knuckles_clicking_sound_effect.mp3",17},
	["Yakuza"]								=	{"taunts/ovcr/yakuza.mp3",30},
	["Yo tout le monde c'est Squeezie"]		=	{"taunts/ovcr/yo_tout_le_monde_cest_squeezie.mp3",1},
	["Coconut"]								=	{"taunts/ovcr/coconut.mp3",7},
	["Dents de la mer"]						=	{"taunts/ovcr/dents_de_la_mer.mp3",7},
	["Sanic"]								=	{"taunts/ovcr/sanic.mp3",8},
	["Perk BO2 Masto"]						=	{"taunts/ovcr/Perk_BO2_Masto.mp3",30},
	["Perk BO2 QuiqRevive"]					=	{"taunts/ovcr/Perk_BO2_QuiqRevive.mp3",27},
	["Perk BO2 Stamina"]					=	{"taunts/ovcr/Perk_BO2_Stamina.mp3",34},
-- Ajout du 07/09/2020
	["Booba - Tiens tiens tiens"]			=	{"taunts/ovcr/Booba___Tiens_tiens_tiens_.mp3",2},
	["Buttercup"]							=	{"taunts/ovcr/BUTTERCUP_MEME_CLIP.mp3",28},
	["C'est pas que j'en ai marre"]			=	{"taunts/ovcr/Cest_pas_que_jen_ai_marre__je_suis_un_peu_fatigue.mp3",3},
	["Coucou les musulmans"]				=	{"taunts/ovcr/Coucou_les_musulmans_moi_je_mange_la_glace_!.mp3",12},
	["C'est pas sorcier"]					=	{"taunts/ovcr/Generique_cest_pas_sorcier.mp3",38},
	["Oggy et les Cafards"]					=	{"taunts/ovcr/Generique_Oggy_et_les_Cafards__Gaumont_.mp3",18},
	["Hello there"]							=	{"taunts/ovcr/Hello_there_.mp3",1},
	["Initial D - Déjà Vu"]					=	{"taunts/ovcr/Initial_D_-_Deja_Vu.mp3",29},
	["Initial D - Running in The 90's"]		=	{"taunts/ovcr/Initial_D_-_Running_in_The_90s.mp3",18},
	["La question elle est vite repondue"]	=	{"taunts/ovcr/La_question_elle_est_vite_repondue.mp3",2},
	["Manuel - Gas Gas Gas"]				=	{"taunts/ovcr/Manuel_-_Gas_Gas_Gas.mp3",13},
	["MisterV - Tu Est Qui"]				=	{"taunts/ovcr/Mister_V_-_Tu_Est_Qui.mp3",1},
	["MisterV - Mais comment vous m'avez trouvé"]	=	{"taunts/ovcr/MisterV_-_Mais_comment_vous_mavez_trouve.mp3",16},
	["Morty's theme"]						=	{"taunts/ovcr/Mortys_theme.mp3",17},
	["Nice"]								=	{"taunts/ovcr/Nice.mp3",2},
	["Nono square"]							=	{"taunts/ovcr/Nono_square.mp3",4},
	["Onii chan I have a DICK"]				=	{"taunts/ovcr/onii_chan_I_have_a_DICC_ORIGINAL.mp3",6},
	["Pub éléfun"]							=	{"taunts/ovcr/pub_elefun.mp3",9},
	["Salut à toi jeune entrepreneur"]		=	{"taunts/ovcr/Salut_a_toi_jeune_entrepreneur.mp3",2},
	["Song for Denise"]						=	{"taunts/ovcr/Song_for_Denise.mp3",21},
	["Steam notif"]							=	{"taunts/ovcr/STEAM_CHAT_SOUND_EFFECT.mp3",1},
	["Thomas The Tank Engine Theme Song"]	=	{"taunts/ovcr/Thomas_The_Tank_Engine_Theme_Song.mp3",20},
	["Why are you running"]					=	{"taunts/ovcr/Why_are_you_running.mp3",1},
	["Yamete Kudasai"]						=	{"taunts/ovcr/Yamete_Kudasai_Sound_Effect__Original_.mp3",2},
	["Bonk"]								=	{"taunts/ovcr/Bonk_Sound_effect.mp3",1},
	["Ali-A Fortnite Intro"]				=	{"taunts/ovcr/Dirty_Rush_&_Gregor_Es_-_Brass__Ali-A_Fortnite_Intro_Song_.mp3",8},
	["DuckTales - The Moon Theme"]			=	{"taunts/ovcr/DuckTales_Music__NES__-_The_Moon_Theme.mp3",24},
	["Get outta my room I'm playing Minecraft"]	=	{"taunts/ovcr/Get_outta_my_room_Im_playing_Minecraft.mp3",3},
	["Get Stick Bugged lol"]				=	{"taunts/ovcr/Get_Stick_Bugged_lol.mp3",8},
	["Gnome"]								=	{"taunts/ovcr/Gnome_sound_effect.mp3",1},
	["Tuturu - Heiakim"]					=	{"taunts/ovcr/Heiakim_-_Tuturu.mp3",24},
	["Megalovania Sound Effect"]			=	{"taunts/ovcr/Megalovania_Meme_Sound_Effect.mp3",1},
	["JDG C'est un vrai sabre laser"]		=	{"taunts/ovcr/jdg-cest-un-vrai-sabre-laser.mp3",19},
	["JDG Alors ici c'est une usine de biscuit"]	=	{"taunts/ovcr/jdg-alors-ici-cest-une-usine-de-biscuit.mp3",7},
	["Snaptrox - Devine qui c'est"]			=	{"taunts/ovcr/snaptrox_devine_qui_cest.mp3",9},
	["Snaptrox - Paf fdp"]					=	{"taunts/ovcr/snaptrox_paf_fdp.mp3",2},
-- Ajout du 26/07/2021     
	["Amogus"]			                    =	{"taunts/ovcr/amogus.mp3",8},
	["C'est quand le feu"]			        =	{"taunts/ovcr/cest_quand_le_feu.mp3",12},
	["Chupapi Munyanyo"]			        =	{"taunts/ovcr/chupapi_munanyo.mp3",8},
	["Merci aux clients fidèles"]			=	{"taunts/ovcr/client_fidele.mp3",10},
	["Donne moi ton fric"]					=	{"taunts/ovcr/donne_moi_ton_fric.mp3",6},
	["Eheh boy EARRAPE"]					=	{"taunts/ovcr/eh_eh_boy_earrape.mp3",5},
	["Hop ta gueule"]						=	{"taunts/ovcr/hop_tg.mp3",5},
	["Kingdom of predators"]				=	{"taunts/ovcr/kingdom_of_predators.mp3",13},
	["Mange mon pain Eren"]					=	{"taunts/ovcr/mange_mon_pain_eren.mp3",4},
	["Married life"]						=	{"taunts/ovcr/married_life.mp3",10},
	["Morshu RTX on"]						=	{"taunts/ovcr/morshu_rtx_on.mp3",14},
	["Oh ta gueule"]						=	{"taunts/ovcr/oh_ta_gueule.mp3",1},
	["Hamburger Cheese"]					=	{"taunts/ovcr/hamburger_cheezeburger.mp3",15},
	["Lisa simpsons prie"]					=	{"taunts/ovcr/lisa_simpson.mp3",15},
	["Redbone"]								=	{"taunts/ovcr/redbone.mp3",13},
	["Sanctuary Guardian"]					=	{"taunts/ovcr/sanctuary_guardian.mp3",12},
	["Snaptrox - Ferme la ta gueule"]		=	{"taunts/ovcr/snaptrox_ferme_ta_geule.mp3",3},
	["Snaptrox - Oh mon cerveau"]			=	{"taunts/ovcr/snaptrox_oh_mon_cerveau.mp3",3},
	["Snaptrox - J'ai qu'une bite"]			=	{"taunts/ovcr/snaptrox_quune_bite.mp3",3},
	["Snaptrox - Pour une telle merde"]		=	{"taunts/ovcr/snaptrox_telle_merde.mp3",3},
	["Stonks"]								=	{"taunts/ovcr/stonks.mp3",5},
	["Terracid - Envie de baiser"]			=	{"taunts/ovcr/terracid_envie_baiser.mp3",2},
	["Terracid - Heure enculer"]			=	{"taunts/ovcr/terracid_heure_enculer.mp3",5},
	["Un deux trois Damien"]				=	{"taunts/ovcr/un_deux_trois_damien.mp3",4},
	["We'll be right back"]					=	{"taunts/ovcr/well_be_right_back.mp3",3},
	["Addict to porn"]						=	{"taunts/ovcr/addict_to_porn.mp3",21},
	["Mario coconut mall"]					=	{"taunts/ovcr/coconut_mall_mario.mp3",27},
	["Gnome Power"]							=	{"taunts/ovcr/gnome_power.mp3",32},
	["Kassos zizi dans ta soeur"]			=	{"taunts/ovcr/kassos_zizi_soeur.mp3",26},
	["Like a dino"]							=	{"taunts/ovcr/like_a_dino.mp3",17},
	["Polish cow"]							=	{"taunts/ovcr/polish_cow.mp3",20},
	["Salut à tous c'est fanta"]			=	{"taunts/ovcr/salut_a_tous_cest_fanta.mp3",23},
	["Super mario world ending"]			=	{"taunts/ovcr/super_mario_world_ending.mp3",18},
-- Ajout du 02/08/2021
	["Place de la femme cuisine"]			=	{"taunts/ovcr/place_de_la_femme_cuisine_remix.mp3",33},
	["WII Sport Roblox"]					=	{"taunts/ovcr/wii_sport_roblox.mp3",30},
	["Anemone Spotted"]						=	{"taunts/ovcr/anemone_spotted.mp3",6},
	["Dababy let's go"]						=	{"taunts/ovcr/dababy_lets_go.mp3",3},
	["MisterV - Eh nique ta mère"]			=	{"taunts/ovcr/mister_v_eh_ntm.mp3",1},
	["Tk78 T'es un homme mort"]				=	{"taunts/ovcr/mort_fdp_tk.mp3",4},
	["Have a break bout de viande"]			=	{"taunts/ovcr/have_a_break_bout_de_viande.mp3",8},
	["Sheeeh"]								=	{"taunts/ovcr/sheeeh.mp3",8},
	["The funny sound"]						=	{"taunts/ovcr/the_funny_sound.mp3",3},
	["Tut tut fils de pute"]				=	{"taunts/ovcr/tut_tut_fdp.mp3",2},
	["You're not that guy"]					=	{"taunts/ovcr/youre_not_that_guy.mp3",3},
-- Ajout d'oublie 30/09/21
	["Dababy let's go"]						=	{"taunts/ovcr/dababy_lets_go.mp3",3},
	["Bipbip"]								=	{"taunts/ovcr/bipbip.mp3",1},
    ["Akon Lonely"]			                =	{"taunts/ovcr/akon_lonely.mp3",10},
	["BeatBox"]			                    =	{"taunts/ovcr/beatbox.mp3",19},
	["Benny Hill"]			                =	{"taunts/ovcr/benny_hill.mp3",7},
	["Betty boop"]			                =	{"taunts/ovcr/betty_boop.mp3",16}
	
	--[""]			=	{"",},
	
}

PHX.AUTOTAUNTS = {
	--Thoses are exemple of taunts :
	["WATATATATA"]							=	{"taunts/props/watatata.wav",20},
	["Remove Freeman"]						=	{"taunts/ph_enhanced/ext_remove_kebab.wav",18},
	["What is love"]						=	{"taunts/ovcr/Whatislove.mp3",31},
	["HEYYEYAAEYAAAEYAEYAA"]				=	{"taunts/ovcr/Hurhurhyahyahya.mp3",14},
	["Americano"]							=	{"taunts/ovcr/americano.mp3",30},
	["Sax poursuite"]						=	{"taunts/ovcr/yakety_sax.mp3",16},
	["Sand man"]							=	{"taunts/ovcr/sandman.mp3",22},
	["Bat Cat"]								=	{"taunts/ovcr/batcat.mp3",20},
	["Happy tree friend"]					=	{"taunts/ovcr/happytreefriends.mp3",16},
	["Thème angrybird"]						=	{"taunts/ovcr/angrybirdstheme.mp3",20},
	["Thug life"]							=	{"taunts/ovcr/thuglife.mp3",17},
	["Shut the fuck up"]					= 	{"taunts/ovcr/shutthefuckup.mp3",15},
	["French kankan Lalala"]				=	{"taunts/ovcr/nostalgiacriticthelaw.mp3",14},
	["J'ai pas d'idée pour celui la"]		=	{"taunts/ovcr/moseisleycantina.mp3",15},
	["Merrygo1"]							=	{"taunts/ovcr/merrygo1.mp3",15},
	["Michael jack 1"]						=	{"taunts/ovcr/michaeljack1.mp3",21},
	["Merrygo 2"]							=	{"taunts/ovcr/merrygo2.mp3",18},
	["Michael jack 2"]						=	{"taunts/ovcr/michaeljack2.mp3",15},
	["Nyancat"]								=	{"taunts/ovcr/nyancat.mp3",17},
	["Merrygo 3"]							=	{"taunts/ovcr/merrygo3.mp3",14},
	["Party Rock"]							=	{"taunts/ovcr/partyrock.mp3",13},
	["Raspberries"]							=	{"taunts/ovcr/raspberries.mp3",19},
	["Dance of the sugar"]					=	{"taunts/ovcr/danceofthesugar1.mp3",21},
	["Ouih"]								=	{"taunts/ovcr/ouih.mp3",14},
	["Baka baka"]							=	{"taunts/ovcr/cirno.mp3",25},
	["Highscore"]							=	{"taunts/ovcr/highscore.mp3",18},
	["Knaki ball"]							=	{"taunts/ovcr/knacki.mp3",11},
	["Promise"]								=	{"taunts/ovcr/promise.mp3",24},
	["Megaman Castle"]						=	{"taunts/ovcr/mmcastle1.mp3",28},
	["Savage"]								=	{"taunts/ovcr/savage.mp3",17},
	["Wrecking ball"]						=	{"taunts/ovcr/wreckingball.mp3",20},
	["Yukki"]								=	{"taunts/ovcr/yukiyukiyuki.mp3",15},
	["My dick"]								=	{"taunts/ovcr/dick.mp3",16},
	["Je veut te voir"]						=	{"taunts/ovcr/jeveuxtevoir.mp3",30},
	["Jackie et Michel"]					=	{"taunts/ovcr/jm.mp3",12},
	["Lama"]								=	{"taunts/ovcr/lama.mp3",14},
	["Mia khalifa"]							=	{"taunts/ovcr/miakhalifa.mp3",20},
	["Thirdeyeya"]							=	{"taunts/ovcr/thirdeyeya.mp3",22},
	["Thx Dvd"]								=	{"taunts/ovcr/thx-dvd.mp3",28},
	["Nyan cat remix"]						=	{"taunts/ovcr/1-96.mp3",30},
	["Trouble"]								=	{"taunts/ovcr/1-88a.mp3",37},
	["Levan polka"]							=	{"taunts/ovcr/1-210.mp3",26},
	["Gohst busters"]						=	{"taunts/ovcr/1-217.mp3",19},
	["Smoke weed every day"]				=	{"taunts/ovcr/1-87.mp3",16},
	["Ts song"]								=	{"taunts/ovcr/ts3.mp3",30},
	["Bass canon"]							=	{"taunts/ovcr/basscanon.mp3",29},
	["Connard 1"]                           =   {"taunts/ovcr/connards1.mp3",37},
	["Connard 2"]                           =   {"taunts/ovcr/connards2.mp3",31},
	["Darude"]                              =   {"taunts/ovcr/darude.mp3",13},
	["Final count"]                       	=   {"taunts/ovcr/finalcount.mp3",18},
	["Flop 2"]                              =   {"taunts/ovcr/flop.mp3",19},
	["Mission 1"]                           =   {"taunts/ovcr/mission1.mp3",31},
	["Mission 2"]                           =   {"taunts/ovcr/mission2.mp3",30},
	["Touhou"]                            	=   {"taunts/ovcr/touhou.mp3",15},
	["Dempagumi"]                           =   {"taunts/ovcr/dempagumi.mp3",29},
	["Marsupilami générique"]				=	{"taunts/ovcr/marsupilami.mp3",19},
	["Pirates des caraibes"]				=	{"taunts/ovcr/Pirates_des_caraibes.mp3",18},
	["Relax take it easy"]					=	{"taunts/ovcr/Relax_take_it_easy.mp3",17},
	["Skyrim menu"]							=	{"taunts/ovcr/Skyrim_menu.mp3",30},
	["The weekend the hills"]				=	{"taunts/ovcr/The_weekEnd_the_hills.mp3",18},
	["Tokyo drift"]							=	{"taunts/ovcr/tokyo_drift.mp3",25},
	["Uganda knuckles clicking sound"]		=	{"taunts/ovcr/Uganda_knuckles_clicking_sound_effect.mp3",17},
	["Yakuza"]								=	{"taunts/ovcr/yakuza.mp3",30},
	["Perk BO2 Masto"]						=	{"taunts/ovcr/Perk_BO2_Masto.mp3",30},
	["Perk BO2 QuiqRevive"]					=	{"taunts/ovcr/Perk_BO2_QuiqRevive.mp3",27},
	["Perk BO2 Stamina"]					=	{"taunts/ovcr/Perk_BO2_Stamina.mp3",34},
	["C'est pas sorcier"]					=	{"taunts/ovcr/Generique_cest_pas_sorcier.mp3",38},
	["Buttercup"]							=	{"taunts/ovcr/BUTTERCUP_MEME_CLIP.mp3",28},
	["Initial D - Déjà Vu"]					=	{"taunts/ovcr/Initial_D_-_Deja_Vu.mp3",29},
	["Initial D - Running in The 90's"]		=	{"taunts/ovcr/Initial_D_-_Running_in_The_90s.mp3",18},
	["Thomas The Tank Engine Theme Song"]	=	{"taunts/ovcr/Thomas_The_Tank_Engine_Theme_Song.mp3",20},
	["DuckTales - The Moon Theme"]			=	{"taunts/ovcr/DuckTales_Music__NES__-_The_Moon_Theme.mp3",24},
	["Tuturu - Heiakim"]					=	{"taunts/ovcr/Heiakim_-_Tuturu.mp3",24},
	["Song for Denise"]						=	{"taunts/ovcr/Song_for_Denise.mp3",21},
-- Ajout du 26/07/2021
	["Addict to porn"]						=	{"taunts/ovcr/addict_to_porn.mp3",21},
	["Mario coconut mall"]					=	{"taunts/ovcr/coconut_mall_mario.mp3",27},
	["Gnome Power"]							=	{"taunts/ovcr/gnome_power.mp3",32},
	["Kassos zizi dans ta soeur"]			=	{"taunts/ovcr/kassos_zizi_soeur.mp3",26},
	["Like a dino"]							=	{"taunts/ovcr/like_a_dino.mp3",17},
	["Polish cow"]							=	{"taunts/ovcr/polish_cow.mp3",20},
	["Salut à tous c'est fanta"]			=	{"taunts/ovcr/salut_a_tous_cest_fanta.mp3",23},
	["Super mario world ending"]			=	{"taunts/ovcr/super_mario_world_ending.mp3",18},
-- Ajout du 02/08/2021
	["Place de la femme cuisine"]			=	{"taunts/ovcr/place_de_la_femme_cuisine_remix.mp3",33},
	["WII Sport Roblox"]					=	{"taunts/ovcr/wii_sport_roblox.mp3",30},
	["BeatBox"]			                    =	{"taunts/ovcr/beatbox.mp3",19},
	["Betty boop"]			                =	{"taunts/ovcr/betty_boop.mp3",16}

}

-- These are used for verification and random taunt only. Do not mess this up.
PHX.CachedTaunts = {}
PHX.CachedTaunts[TEAM_HUNTERS]	= {}
PHX.CachedTaunts[TEAM_PROPS]	= {}

if SERVER then
	function AddResources(t)
		if !t then return end
		
		for name,path in pairs(t) do
			PHX.VerboseMsg("[PH Taunts] Adding resource for download: " .. name)
			resource.AddFile("sound/" .. path)
		end
	end
	
	function PHX:GetRandomTaunt( idTeam )
		if table.IsEmpty(self.CachedTaunts[idTeam]) then
			print("[PH Taunts] !!ERROR: Cache Taunt Table is Empty! Is there something messing up the cache??")
			return "vo/k_lab/kl_fiddlesticks.wav"
		else
			local rand = table.Random(self.CachedTaunts[idTeam])
			local name = table.KeyFromValue(self.CachedTaunts[idTeam], rand)
			return rand, name
		end
	end
end

function PHX:CheckCache( tbl, cat )
	
	if !cat or cat == nil then cat = "Unknown" end
	
	for i=TEAM_HUNTERS,TEAM_PROPS do
		if tbl[i] and tbl[i] ~= nil then
			for name,path in pairs(tbl[i]) do
				if (self.CachedTaunts[i][name] ~= nil) then
					self.VerboseMsg("[PH Taunts: "..team.GetName(i).." Cache Warning] Taunt name ["..name.."] from category '".. cat .. "' was exists in the cache. Removing entry to prevent duplication...")
					tbl[i][name] = nil
				elseif table.HasValue( self.CachedTaunts[i], path ) then
					self.VerboseMsg("[PH Taunts:"..team.GetName(i).." Cache Warning] Taunt name ["..name.."]["..path.."] from category '"..cat.."' was exists in the cache. Removing entry to prevent duplication...")
					tbl[i][name] = nil
				end
			end
		end
	end
	
end

function PHX:AddToCache( idTeam, tbl )

	for name,path in pairs( tbl ) do
		self.VerboseMsg( "[PH Taunts] ["..team.GetName( idTeam ):upper().." Cache] Adding taunt [" .. name .. "] to the cache." )
		self.CachedTaunts[idTeam][name] = path
	end
	
end

function PHX:ManageTaunt( category, tauntData )
	
	-- check cache first.
	self.VerboseMsg("[PH Taunts] Checking for duplicated/conflicting taunts: "..category.."...")
	self:CheckCache( tauntData, category )
	
	local emptied=0
	
	if !istable(tauntData[TEAM_HUNTERS]) then
		emptied=emptied+1
	elseif istable(tauntData[TEAM_HUNTERS]) and table.IsEmpty(tauntData[TEAM_HUNTERS]) then
		emptied=emptied+1
	end
	
	if !istable(tauntData[TEAM_PROPS]) then
		emptied=emptied+1
	elseif istable(tauntData[TEAM_PROPS]) and table.IsEmpty(tauntData[TEAM_PROPS]) then
		emptied=emptied+1
	end
	
	if emptied==2 then
		print("[PH Taunts] Warning: It seems that all taunts from "..category.." was emptied from Cache Checker! Skipping to next taunt if any.")
		return
	end
	
	self.VerboseMsg("[PH Taunts] Done. Starting Managing Taunts ...")

	if self.TAUNTS[category] ~= nil then
		-- if category exist, add them.
		self.VerboseMsg("[PH Taunts] Category " .. category .. " was exists in taunt table. Adding Taunts...")
		
		for i=TEAM_HUNTERS,TEAM_PROPS do
			if tauntData[i] and tauntData[i] ~= nil then
				for name,path in pairs(tauntData[i]) do
					-- Double Check, if somehow found any duplicates
					if ( self.TAUNTS[category][i][name] ) or ( self.CachedTaunts[i][name] ) then
						self.VerboseMsg(string.format("[PH Taunts] Skipping taunt NAME '%s' (Cat: %s) because it exist in Taunt Table & Cache.", name,category))
					elseif (table.HasValue( self.TAUNTS[category][i], path )) and (table.HasValue( self.CachedTaunts[i], path )) then
						self.VerboseMsg(string.format("[PH Taunts] Skipping taunt PATH '%s' (Cat: %s, path: %s) because it exist in Taunt Table & Cache.", name,category,path))
					else
						self.VerboseMsg(string.format("[PH Taunts] Adding taunt '%s' (Cat: %s) to their Existing Taunt Table and Cache.", name,category))
						self.TAUNTS[category][i][name] 	= path
						self.CachedTaunts[i][name] 		= path
					end
				end
			end
		end
		
		self.VerboseMsg("[PH Taunts] Taunts Category " .. category .. " has been successfully added!")
		
		return
	end
	
	self.VerboseMsg("[PH Taunts] Adding new taunt & category: " .. category .. "!")
	
	self.TAUNTS[category]	= tauntData
	
	local PROPS_TAUNT 		= {}
	local HUNTERS_TAUNT 	= {}
	
	self.VerboseMsg("[PH Taunts] Precaching taunts from category: " .. category .. "..." )
	
	if tauntData[TEAM_PROPS] and tauntData[TEAM_PROPS] ~= nil and istable(tauntData[TEAM_PROPS]) and !table.IsEmpty( tauntData[TEAM_PROPS] ) then
		PROPS_TAUNT = tauntData[TEAM_PROPS]
		self:AddToCache( TEAM_PROPS, PROPS_TAUNT )
		if SERVER then
			self.VerboseMsg("[PH Taunts] Adding Prop taunts resources if any." )
			AddResources( PROPS_TAUNT )
		end
	end
	
	if tauntData[TEAM_HUNTERS] and tauntData[TEAM_HUNTERS] ~= nil and istable(tauntData[TEAM_HUNTERS]) and !table.IsEmpty( tauntData[TEAM_HUNTERS] ) then
		HUNTERS_TAUNT = tauntData[TEAM_HUNTERS]
		self:AddToCache( TEAM_HUNTERS, HUNTERS_TAUNT )
		if SERVER then
			self.VerboseMsg("[PH Taunts] Adding Hunter taunts resources if any." )
			AddResources( HUNTERS_TAUNT )
		end
	end
end

-- Taunts Addition & Removal
function PHX:AddCustomTaunt( idTeam, category, tblTaunt )
	self:CheckCache( tblTaunt, category )

	if (idTeam ~= TEAM_PROPS or idTeam ~= TEAM_HUNTERS) and (!tblTaunt or tblTaunt == nil) and (!istable(tblTaunt)) then
		print( "[PH] Error: Cannot add taunt category from team: "..team.GetName(idTeam).."!" )
		return
	end
	
	if self.TAUNT[category] ~= nil then
		self.TAUNTS[category][idTeam] = tblTaunt
		self:AddToCache(idTeam, tblTaunt)
		AddResources( tblTaunt )
	else
		print( "[PH] Error: Cannot add taunt category "..category.." because category is exists! Try with different name." )
	end
	
end

function PHX:AddSingleTaunt(idTeam, category, name, path)
	if (idTeam ~= TEAM_PROPS or idTeam ~= TEAM_HUNTERS) and (!name and !path) and (type(name) ~= "string" and type(path) ~= "string") then
		print( "[PH] Error: All required arguments must be a string, required and thus cannot be empty!" )
		return
	end
	
	if self.TAUNTS[category] == nil then
		self.TAUNTS[category] = {}	-- create empty category table instead.
	end
	
	-- Singular proccess.
	if self.TAUNTS[category][idTeam][name] ~= nil and self.CachedTaunts[idTeam][name] ~= nil and
		!table.HasValue(self.TAUNTS[category][idTeam][name], path) and !table.HasValue( self.CachedTaunts[idTeam][name], path ) then
		
		self.TAUNTS[category][idTeam][name]	= path
		self.CachedTaunts[idTeam][name] 	= path
		if SERVER then
			resource.AddFile("sound/"..path)
		end
	end
end

function PHX:RemoveTauntByPath( idTeam, category, strTaunt )
	if (!idTeam or !category) then
		print("[PH Taunts] Error: Team ID or Category is Invalid!")
	end

	if table.HasValue(self.TAUNT[category][idTeam], strTaunt) then 
		table.RemoveByValue(self.TAUNT[category][idTeam], strTaunt)
		table.RemoveByValue(self.CachedTaunts[idTeam], strTaunt)
		return true
	else
		print("[PH Taunts] Taunt: ".. strTaunt .. " didn't exists on category " .. category)
	end
	
	return false
end

-- Get List of Taunt, returned by Table.
function PHX:GetAllTeamTaunt( teamid, category )
	if (not category) then
		self.VerboseMsg("[PH Taunts] Warning: category isn't defined. Reverting back to Default Category!")
		category = self.DEFAULT_CATEGORY
	end

	if (not self.TAUNTS[category]) or (self.TAUNTS[category] == nil) then
		print("[PH Taunts] The specified ".. team.GetName(teamid) .." taunt table from "..category.." contains nothing or not found.")
		return false
	end
	
	-- do a copy instead accessing them.
	local taunt = table.Copy(self.TAUNTS[category][teamid])
	return taunt
end

-- Use with your own risk.
function PHX:RefreshTauntList()
	local t = table.Copy(self.TAUNTS)
	local getCategories = table.GetKeys(self.TAUNTS)
	
	print( "[PHX Taunt] Refreshing..." )
	
	-- Empty Table
	self.TAUNTS = {}
	
	-- Resort them.
	for _,Category in pairs( getCategories ) do
		if t[Category][TEAM_PROPS]   ~= nil then table.sort( t[Category][TEAM_PROPS] ) 	 end
		if t[Category][TEAM_HUNTERS] ~= nil then table.sort( t[Category][TEAM_HUNTERS] ) end
	end
	
	self.TAUNTS = t
end

-- if there was no  taunts loaded, uncomment these. For most cases, this should never happened.
--[[
	hook.Add("InitPostEntity", "PHX.RefreshTauntList", function()
		PHX:RefreshTauntList() 
	end)
]]

concommand.Add("ph_refresh_taunt_list", function( ply ) 
	if ( util.IsStaff( ply ) ) then PHX:RefreshTauntList() end
end, nil, "(Deprecated: Use with your own risk) Refresh Taunt List and Sort them.")

-- Add the custom player model bans for props AND prop banned models
local config_path = PHX.ConfigPath
if SERVER then
	if ( !file.Exists( config_path, "DATA" ) ) then
		PHX.VerboseMsg("[PHX] Warning: ./data/".. config_path .." does not exist. Creating New One...")
		file.CreateDir( config_path )
	end
	
	local function AddBadPLModels()

		local dir = config_path .. "/prop_plymodel_bans"
		
		-- Create base config area
		if ( !file.Exists( dir, "DATA" ) ) then
			file.CreateDir( dir )
		end

		-- Create actual config
		if ( !file.Exists( dir.."/bans.txt", "DATA" ) or file.Size( dir.."/bans.txt", "DATA" ) <= 0 ) then
			file.Write( dir.."/bans.txt", util.TableToJSON({"models/player.mdl", "custom_playermodel_name"}, true) )
		end
		
		if ( file.Exists( dir.."/bans.txt", "DATA" ) ) then
		
			local PROP_PLMODEL_BANS_READ = util.JSONToTable( file.Read( dir.."/bans.txt", "DATA" ) )
			
			-- empty the table instead
			PHX.PROP_PLMODEL_BANS = {}
			
			for _, v in pairs(PROP_PLMODEL_BANS_READ) do
				PHX.VerboseMsg("[PHX PlayerModels] Adding custom prop player model ban --> "..string.lower(v))
				table.insert(PHX.PROP_PLMODEL_BANS, string.lower(v))
			end
		else
			
			PHX.VerboseMsg("[PHX] Cannot read "..dir.."/bans.txt: Error - did not exist. Did you just delete it or what?")
			
		end

	end
	
	local function AddBannedPropModels()
		local dir = config_path .. "/prop_model_bans"
		
		-- this is a stock template. DO NOT MODIFY.
		local template = {
            "models/player.mdl",
            "models/chefhat.mdl"
		}
		
		if ( !file.Exists(dir, "DATA") ) then
			file.CreateDir(dir)
		end
		
		if ( !file.Exists(dir.."/model_bans.txt","DATA") or file.Size( dir.."/model_bans.txt", "DATA" ) <= 0 ) then
			file.Write( dir.."/model_bans.txt", util.TableToJSON( template, true ))
		end
		
		if ( file.Exists ( dir.."/model_bans.txt","DATA" ) ) then
			local PROP_MODEL_BANS_READ = util.JSONToTable(file.Read(dir.."/model_bans.txt"))
            
			--PHX.BANNED_PROP_MODELS = {}
			for _,v in pairs(PROP_MODEL_BANS_READ) do
				PHX.VerboseMsg("[PHX Model Bans] Adding entry of restricted model to be used -> "..string.lower(v))
                
                if table.HasValue(PHX.BANNED_PROP_MODELS, v) then
                    PHX.VerboseMsg("[PHX Model Bans] Models " .. v .. " is already exists in the prop model banlist. Ignoring...!")
                else
                    table.insert(PHX.BANNED_PROP_MODELS, string.lower(v))
                end
			end
		else
			PHX.VerboseMsg("[PHX] Cannot read "..dir.."/model_bans.txt: Error - did not exist. Did you just delete it or what?")
		end
	end
    
    -- First, Add Permanent Ban
    for _,v in pairs( phx_PermaBannedModels ) do
        table.insert( PHX.BANNED_PROP_MODELS, v )
    end
        
    -- Add Extra Banned Models
    AddBadPLModels()
    AddBannedPropModels()
	
	-- Add ConCommands.
	concommand.Add("ph_refresh_plmodel_ban", function(ply)
		if ( util.IsStaff( ply ) ) then AddBadPLModels() end
	end, nil, "Refresh Server Playermodel Ban Lists (Auto-update on round restart) and read from prop_plymodel_bans/bans.txt")
	
	concommand.Add("ph_refresh_propmodel_ban", function(ply)
		if ( util.IsStaff( ply ) ) then AddBannedPropModels() end
	end, nil, "Refresh Server Prop Models Ban Lists (Auto-update on round restart) and read from prop_model_bans/model_bans.txt")
end

local function UpdatePropBansInfo( PHXKey, tbl )
	local compress,len = util.PHXQuickCompress( tbl )
	
	net.Start( "PHX.UpdatePropbanInfo" )
		net.WriteString( PHXKey )
		net.WriteUInt( len, 16 )
		net.WriteData( compress, len )
	net.Broadcast()
end

hook.Add("PostCleanupMap", "PHX.UpdateUsablePropEnt", function()
	-- Update Prop Entities Type
	PHX.USABLE_PROP_ENTITIES = PHX.CVARUseAbleEnts[ PHX:GetCVar( "ph_usable_prop_type" ) ]
	
	if SERVER then
    
        -- Prohibit specific prop from spawning
        for _,ent in pairs(ents.GetAll()) do
            timer.Simple(0.1, function()
                if IsValid(ent) and PHX.PROHIBITTED_MDLS[ ent:GetModel() ] then
                    PHX.VerboseMsg("[PHX] Removing " .. ent:GetModel() .. " to prevent server crash or gameplay-breaking exploits.")
                    ent:Remove()
                end
            end)
        end
        
        -- Always update the prop bans info.
		UpdatePropBansInfo( "BANNED_PROP_MODELS", PHX.BANNED_PROP_MODELS )
		UpdatePropBansInfo( "PROP_PLMODEL_BANS", PHX.PROP_PLMODEL_BANS )
	end
end)

local function InitializeConfig()

	PHX.VerboseMsg("[PH Taunts] Initializing Taunts...")
	
	PHX.VerboseMsg("[PH Taunts] Precaching stock taunts..." )
	PHX:AddToCache( TEAM_PROPS, 	PHX.TAUNTS[PHX.DEFAULT_CATEGORY][TEAM_PROPS] )
	PHX:AddToCache( TEAM_HUNTERS, 	PHX.TAUNTS[PHX.DEFAULT_CATEGORY][TEAM_HUNTERS] )
	
	PHX.VerboseMsg("[PHX Taunts] Adding External Custom Taunts, if any...")
	for category,tauntData in SortedPairs( list.Get("PHX.CustomTaunts") ) do 
		
		PHX.VerboseMsg("[PH Taunts] Working on Adding external taunt: Category: [" .. category .. "]...")
		PHX:ManageTaunt( category, tauntData )
		
	end
	
	PHX.VerboseMsg( "[PH Taunts] Total Cache size: Props - " .. tostring(table.Count(PHX.CachedTaunts[TEAM_PROPS])) .. ", Hunter: " .. tostring(table.Count(PHX.CachedTaunts[TEAM_HUNTERS])) .."\n[PH Taunts] Done. Have Fun!" )
    
    -- Initialize Usable Prop Entities
    PHX.USABLE_PROP_ENTITIES = PHX.CVARUseAbleEnts[ PHX:QCVar( "ph_usable_prop_type" ) ]
	
end
hook.Add("Initialize", "PHX.InitializeTaunts", InitializeConfig)
-- use this if taunts are not properly added.
-- hook.Add("InitPostEntity", "PHX.InitializeTaunts", InitializeTaunts)