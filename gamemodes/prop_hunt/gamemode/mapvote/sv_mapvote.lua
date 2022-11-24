util.AddNetworkString("RAM_MapVoteStart")
util.AddNetworkString("RAM_MapVoteUpdate")
util.AddNetworkString("RAM_MapVoteCancel")
util.AddNetworkString("RTV_Delay")
taillemapsserv = {
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

MapVote.Continued = false

net.Receive("RAM_MapVoteUpdate", function(len, ply)
    if(MapVote.Allow) then
        if(IsValid(ply)) then
            local update_type = net.ReadUInt(3)
            
            if(update_type == MapVote.UPDATE_VOTE) then
                local map_id = net.ReadUInt(32)
                local map = net.ReadString()
                local taille = net.ReadString()
                -- PrintTable(MapVote.CurrentMaps)
                -- print(MapVote.CurrentMaps[map_id])
                
                -- if(MapVote.CurrentMaps[map_id]) then
                MapVote.Votes[ply:SteamID()] = {map_id,map}
                
                net.Start("RAM_MapVoteUpdate")
                    net.WriteUInt(MapVote.UPDATE_VOTE, 3)
                    net.WriteEntity(ply)
                    net.WriteUInt(map_id, 32)
                    net.WriteString(taille)
                net.Broadcast()
                -- end
            end
        end
    end
end)

if file.Exists( "mapvote/recentmaps.txt", "DATA" ) then
    recentmaps = util.JSONToTable(file.Read("mapvote/recentmaps.txt", "DATA"))
	print("---------------------------------")
	print("Bruuuuh le fichier recentmaps EXISTE ET JESSAYE DE LE LIRE :")
	if type(recentmaps) == "table" then
		PrintTable(recentmaps)
	else
		print(recentmaps)
	end
	print("---------------------------------")
else
    recentmaps = {}
end

if ConVarExists("mv_maplimit") then
	-- printVerbose("[MapVote] Loading ConVars...")
	MapVote.Config = {
		MapLimit 		= GetConVar("mv_maplimit"):GetInt(),
		TimeLimit 		= GetConVar("mv_timelimit"):GetInt(),
		AllowCurrentMap = GetConVar("mv_allowcurmap"):GetBool(),
		EnableCooldown 	= GetConVar("mv_cooldown"):GetBool(),
		MapsBeforeRevote = GetConVar("mv_mapbeforerevote"):GetInt(),
		RTVPlayerCount 	= GetConVar("mv_rtvcount"):GetInt(),
		MapPrefixes 	= string.Explode(",", GetConVar("mv_map_prefix"):GetString():lower())
	}
else
	MapVote.Config = {}
end

local conv = {
	["mv_maplimit"]		= function(cvar,old,new)
		if new && (new != nil || new != "") then
			MapVote.Config.MapLimit = tonumber(new)
		end
	end,
	["mv_timelimit"]	= function(cvar,old,new)
		if new && (new != nil || new != "") then
			MapVote.Config.TimeLimit = tonumber(new)
		end
	end,
	["mv_allowcurmap"]	= function(cvar,old,new)
		if new && (new != nil || new != "") then
			MapVote.Config.AllowCurrentMap = tobool(new)
		end
	end,
	["mv_cooldown"]		= function(cvar,old,new)
		if new && (new != nil || new != "") then
			MapVote.Config.EnableCooldown = tobool(new)
		end
	end,
	["mv_mapbeforerevote"]	= function(cvar,old,new)
		if new && (new != nil || new != "") then
			MapVote.Config.MapsBeforeRevote = 14
		end
	end,
	["mv_rtvcount"]		= function(cvar,old,new)
		if new && (new != nil || new != "") then
			MapVote.Config.RTVPlayerCount = tonumber(new)
		end
	end,
	["mv_mapprefix"]	= function(cvar,old,new)
		if new && (new != nil || new != "") then
			MapVote.Config.MapPrefixes = string.Explode(",", new:lower())
		end
	end
}

-- Precheck when the convar is changed
for cvar,func in pairs(conv) do
	-- printVerbose("[MapVote] Adding ConVar Callbacks for: "..cvar)
	cvars.AddChangeCallback(cvar, func)
end

function CoolDownDoStuff()
    cooldownnum = MapVote.Config.MapsBeforeRevote or 3
	
	-- print("Le mvconfigmapbeforerevote est egal a : ")
	-- print(MapVote.Config.MapsBeforeRevote)
	-- print("Son type :")
	-- print(type(MapVote.Config.MapsBeforeRevote))
    -- PrintTable(recentmaps)
    -- print(#recentmaps)
    -- print(cooldownnum)
    -- print(table.getn(recentmaps))
    -- print(table.getn(recentmaps) >= cooldownnum)

    if table.getn(recentmaps) >= cooldownnum then
		print("---------------------------------")
		print("Bruuuuh je supprime le dernier element de  recentmaps car + de 14 maps")
		print("Donc supprimé : "..recentmaps[cooldownnum])
		print("---------------------------------")
        table.remove(recentmaps,cooldownnum)
		-- print("---------------------------------")
		-- print("Pour confirmer, voici le nouveau : "..recentmaps[cooldownnum])
		-- print("---------------------------------")
    end

    local curmap = game.GetMap():lower()..".bsp"

    if not table.HasValue(recentmaps, curmap) then
        table.insert(recentmaps, 1, curmap)
    end

    file.Write("mapvote/recentmaps.txt", util.TableToJSON(recentmaps))
	-- print("---------------------------------")
	-- print("Le cooldownnum est egal a : ")
	-- print(cooldownnum)
	-- print("Son type :")
	-- print(type(cooldownnum))
	-- print("Bruuuuh j'écrase le fichier recentmaps avec ces maps :")
	-- PrintTable(recentmaps)
	-- print("---------------------------------")
end

function MapVote.GetFromULX()
	if (ulx == nil) then
		print("[!PH: Enhanced] Warning: ULX is not installed!")
		return false
	end

	if (ulx.votemaps) then
		return ulx.votemaps
	end
end

function MapVote.PHXStart(length, current, limit, prefix)
    current = current or MapVote.Config.AllowCurrentMap or false
    length = length or MapVote.Config.TimeLimit or 28
    limit = limit or MapVote.Config.MapLimit or 24
    cooldown = MapVote.Config.EnableCooldown or true
    prefix = prefix or MapVote.Config.MapPrefixes
    limit=40
    --BALEKOUILLES MTN DE LA LIMITE
    --ON EST GRAND MTN

    local is_expression = false
	local ulxmap = MapVote.GetFromULX()
	
    if not prefix then
        local info = file.Read(GAMEMODE.Folder.."/"..GAMEMODE.FolderName..".txt", "GAME")

        if(info) then
            local info = util.KeyValuesToTable(info)
            prefix = info.maps
        else
            error("MapVote Prefix can not be loaded from gamemode")
        end

        is_expression = true
    else
        if prefix and type(prefix) ~= "table" then
            prefix = {prefix}
        end
    end
    
	local maps = {}
	
	if GetConVar("mv_use_ulx_votemaps"):GetBool() && ulxmap ~= false then
		for _,map in pairs(ulxmap) do
			table.insert(maps, map..".bsp")
		end
	else
		maps = file.Find("maps/*.bsp", "GAME")
	end

    local les_maps = {
        ['petites'] = {},
        ['moyennes'] = {},
        ['grandes'] = {}
    }
    -- print(taillemapsserv['petites'][math.random(1,#taillemapsserv['petites'])])
    -- print(recentmaps)
    -- PrintTable(recentmaps)
    local k=0
    for i=1,8,1 do
        local ajout_map = taillemapsserv['petites'][math.random(1,#taillemapsserv['petites'])]
        -- print('petit rec '..tostring(table.HasValue(recentmaps,tostring(ajout_map)))..'/'..ajout_map)
        -- print('petit les '..tostring(table.HasValue(les_maps['petites'],tostring(ajout_map)))..'/'..ajout_map)
        while (table.HasValue(les_maps['petites'], tostring(ajout_map)) || table.HasValue(recentmaps,tostring(ajout_map)..'.bsp')) && k<50 do
            -- print('while petit'..tostring(table.HasValue(recentmaps,tostring(ajout_map)))..'/'..ajout_map)
            ajout_map = taillemapsserv['petites'][math.random(1,#taillemapsserv['petites'])]
            k=k+1
        end
        print(k)
        
        print('map petite ajoutée:'..ajout_map)
        if k<50 && (game.GetMap():lower()..".bsp" != (tostring(ajout_map)..'.bsp')) then
            table.insert(les_maps['petites'],ajout_map) 
        end
        k=0
    end
    k=0
    for i=1,6,1 do
        local ajout_map = taillemapsserv['moyennes'][math.random(1,#taillemapsserv['moyennes'])]
        -- print('moyen rec '..tostring(table.HasValue(recentmaps,tostring(ajout_map)))..'/'..ajout_map)
        -- print('moyen les '..tostring(table.HasValue(les_maps['moyennes'],tostring(ajout_map)))..'/'..ajout_map)
        while (table.HasValue(les_maps['moyennes'], tostring(ajout_map)) || table.HasValue(recentmaps,tostring(ajout_map)..'.bsp')) && k<50 do
            -- print('while  moyen'..tostring(table.HasValue(recentmaps,tostring(ajout_map)))..'/'..ajout_map)
            ajout_map = taillemapsserv['moyennes'][math.random(1,#taillemapsserv['moyennes'])]
            k=k+1
        end
        -- print(k)
        if k<50 && (game.GetMap():lower()..".bsp" != (tostring(ajout_map)..'.bsp')) then
        -- print('map moyenne ajoutée:'..ajout_map) 
            table.insert(les_maps['moyennes'],ajout_map)
        end
        k=0
    end
    k=0
    for i=1,6,1 do
        local ajout_map = taillemapsserv['grandes'][math.random(1,#taillemapsserv['grandes'])]
        -- print('grand rec '..tostring(table.HasValue(recentmaps,tostring(ajout_map)))..'/'..ajout_map)
        -- print('grand les '..tostring(table.HasValue(les_maps['grandes'],tostring(ajout_map)))..'/'..ajout_map)
        while (table.HasValue(les_maps['grandes'], tostring(ajout_map)) || table.HasValue(recentmaps,tostring(ajout_map)..'.bsp')) && k<50 do
            -- print('while grand'..tostring(table.HasValue(recentmaps,tostring(ajout_map)))..'/'..ajout_map)
            ajout_map = taillemapsserv['grandes'][math.random(1,#taillemapsserv['grandes'])]
            k=k+1
        end
        -- print(k)
        if k<50 && (game.GetMap():lower()..".bsp" != (tostring(ajout_map)..'.bsp')) then
        -- print('map grande ajoutée:'..ajout_map)
            table.insert(les_maps['grandes'],ajout_map)
        end
        k=0
    end

    -- PrintTable(les_maps)



    local vote_maps = {}
    
    local amt = 0

    for k, map in RandomPairs(maps) do
        local mapstr = map:sub(1, -5):lower()
        if(not current and game.GetMap():lower()..".bsp" == map) then continue end
        if(cooldown and table.HasValue(recentmaps, map)) then continue end

        if is_expression then
            if(string.find(map, prefix)) then -- This might work (from gamemode.txt)
                vote_maps[#vote_maps + 1] = map:sub(1, -5)
                amt = amt + 1
            end
        else
            for k, v in pairs(prefix) do
                if string.find(map, "^"..v) then
                    vote_maps[#vote_maps + 1] = map:sub(1, -5)
                    amt = amt + 1
                    break
                end
            end
        end
        
        if(limit and amt >= limit) then break end
    end
    
    -- if (0==1) then
        net.Start("RAM_MapVoteStart")
            -- net.WriteString('petites')
            -- PrintTable(les_maps)
            -- print(#les_maps['petites'])
            net.WriteUInt(#les_maps['petites'],4)
            for i = 1,#les_maps['petites'],1 do
                net.WriteString(les_maps['petites'][i])
                -- print("sv envoi map :" ..les_maps['petites'][i])
            end
            -- net.WriteString('moyennes')
            -- print(#les_maps['moyennes'])
            net.WriteUInt(#les_maps['moyennes'],4)
            for i = 1,#les_maps['moyennes'],1 do
                net.WriteString(les_maps['moyennes'][i])
            end
            -- net.WriteString('grandes')
            -- print(#les_maps['grandes'])
            net.WriteUInt(#les_maps['grandes'],4)
            for i = 1,#les_maps['grandes'],1 do
                net.WriteString(les_maps['grandes'][i])
            end
            --Temps du mapvote
            net.WriteUInt(length, 32)
            -- net.WriteUInt(10, 32)
        net.Broadcast()
    -- end
    
    -- PrintTable(vote_maps)
    -- net.Start("RAM_MapVoteStart")
    --     net.WriteUInt(#vote_maps, 32)
        
    --     for i = 1, #vote_maps do
    --         net.WriteString(vote_maps[i])
    --     end
        
    --     net.WriteUInt(length, 32)
    -- net.Broadcast()
    
    MapVote.Allow = true
    -- MapVote.CurrentMaps = les_maps
    MapVote.Votes = {}
    
    timer.Create("RAM_MapVote", length, 1, function()
        MapVote.Allow = false
        local map_results = {}
        -- PrintTable(MapVote.Votes)
        
        for k, v in pairs(MapVote.Votes) do
            if(not map_results[v[1]]) then
                map_results[v[1]] = 0
            end
            
            for k2, v2 in pairs(player.GetAll()) do
                if(v2:SteamID() == k) then
                    if(MapVote.HasExtraVotePower(v2)) then
                        map_results[v[1]] = map_results[v[1]] + 2
                    else
                        map_results[v[1]] = map_results[v[1]] + 1
                    end
                end
            end
            
        end
        
        CoolDownDoStuff()

        local winner = table.GetWinningKey(map_results) or 1
        print("gagnante:"..winner)
        --TODO: prendre une map random
        --ou vérifier si y'a d'autres maps a prendre qui ont été votés
        --vérifier aussi le table.GetWinningKey mais il me semble qu'il marche bien
        -- table.Random(table haystack)
        local map = "test"
        for k,v in pairs(MapVote.Votes) do
            if(v[1]==winner) then
                -- print(v[2])
                map = v[2]
            end
        end

        print("map trouvée:"..map)


        --Deuxième tentative de recherche de map
        local map_results_trie = table.SortByKey(map_results, false)
        local winnerDeux = map_results_trie[2]
        if map=="test" then
            for k,v in pairs(MapVote.Votes) do
                if v[1]==map_results[winnerDeux] then
                    map=v[2]
                    winner=winnerDeux
                end
            end    
            print("map trouvée v2:"..map)
            print("winner2:"..(winnerDeux or ""))
        end


        --Troisième et dernière tentative de recherche de map
        if map=="test" then
            if player.GetCount() < 8 then
                map=table.Random(taillemapsserv["petites"])
            elseif player.GetCount() < 14 then
                map=table.Random(taillemapsserv["moyennes"])
            else
                map=table.Random(taillemapsserv["grandes"])
            end
            winner=999
            print("map_random:"..map)
            -- print("winner:999")
        end
        
        
        net.Start("RAM_MapVoteUpdate")
            net.WriteUInt(MapVote.UPDATE_WIN, 3)
            
            net.WriteUInt(winner, 32)
        net.Broadcast()
        
        -- local map = MapVote.CurrentMaps[winner]
        -- PrintTable(MapVote.CurrentMaps)

        print("la map : "..map)

        
        
        timer.Simple(4, function()
            hook.Run("MapVoteChange", map)
            RunConsoleCommand("changelevel", map)
        end)
    end)
end

hook.Add( "Shutdown", "RemoveRecentMaps", function()
        if file.Exists( "mapvote/recentmaps.txt", "DATA" ) then
            file.Delete( "mapvote/recentmaps.txt" )
			print("---------------------------------")
			print("Bruuuuh JE SUPPRIME le fichier recentmaps")
			print("---------------------------------")
        end
end )

function MapVote.PHXCancel()
    if MapVote.Allow then
        MapVote.Allow = false

        net.Start("RAM_MapVoteCancel")
        net.Broadcast()

        timer.Destroy("RAM_MapVote")
    end
end
