/*  ------------------
	Auto Taunt Section 
	------------------  */

local function TauntTimeLeft(ply)
	-- Always return 1 when the conditions are not met
	if !IsValid(ply) || !ply:Alive() || ply:Team() != TEAM_PROPS then return 1; end
	
	local lastTauntTime = ply:GetLastTauntTime( "LastTauntTime" )
	local nextTauntTime = lastTauntTime + PHX:GetCVar( "ph_autotaunt_delay" )
	local currentTime = CurTime()
	return nextTauntTime - currentTime
end

local function AutoTauntThink()

	if PHX:GetCVar( "ph_autotaunt_enabled" ) then
		
		for _, ply in ipairs(team.GetPlayers(TEAM_PROPS)) do
			local timeLeft = TauntTimeLeft(ply)
			
			if IsValid(ply) && ply:Alive() && ply:Team() == TEAM_PROPS && timeLeft <= 0 then
				local pitch = 100
				local pitchRandEnabled 	= ply:GetInfoNum( "ph_cl_pitch_apply_random", 0 )
				local pitchlevel 		= ply:GetInfoNum( "ph_cl_pitch_level", 100 )
				local isRandomized 		= ply:GetInfoNum( "ph_cl_pitch_randomized_random", 0 )
				local rand_taunt 		= table.Random(PHX.AUTOTAUNTS)
				
				-- if !isstring(rand_taunt) then rand_taunt = tostring(rand_taunt); end
				
				PHX:PlayTaunt( ply, rand_taunt, pitchRandEnabled, pitchlevel, isRandomized, "Autotaunt" )

			end
		end
		
	end
end
timer.Create("PHX.AutoTauntThinkTimer", 1, 0, AutoTauntThink)

/*  --------------------
	Custom Taunt Section 
	--------------------   */

-- Validity check to prevent some sort of spam
local function IsDelayed(ply)
	local delay = ply:GetLastTauntTime( "CLastTauntTime" ) + PHX:GetCVar( "ph_customtaunts_delay" )
	return { delay > CurTime(), delay - CurTime() }
end
local function CheckValidity( tauntName, sndFile, plyTeam )
	-- print(file.Exists("sound/"..sndFile, "GAME"))
	-- print((PHX.CachedTaunts[plyTeam][tauntName] ~= nil))
	-- print(table.HasValue( PHX.CachedTaunts[plyTeam], sndFile ))
	return file.Exists("sound/"..sndFile, "GAME") and (PHX.CachedTaunts[plyTeam][tauntName] ~= nil) and table.HasValue( PHX.CachedTaunts[plyTeam], sndFile )
end
local function CheckValidity2( tauntName, sndFile, plyTeam )
	-- print(file.Exists("sound/"..sndFile[1], "GAME"))
	-- print((PHX.CachedTaunts[plyTeam][tauntName] ~= nil))
	-- print(table.HasValue( PHX.CachedTaunts[plyTeam], sndFile ))
	return file.Exists("sound/"..sndFile[1], "GAME") and (PHX.CachedTaunts[plyTeam][tauntName] ~= nil) and table.HasValue( PHX.CachedTaunts[plyTeam], sndFile )
end

local function SetLastTauntDelay( ply )
	ply:SetLastTauntTime( "CLastTauntTime", CurTime() )
	ply:SetLastTauntTime( "LastTauntTime", CurTime() )
end

net.Receive("CL2SV_PlayThisTaunt", function(len, ply)
	local name		= net.ReadString()
	-- print("nom du taunt ajouer venant du c menu :"..name)
	-- print(PHX.CachedTaunts[ply:Team()][name])
	-- PrintTable(PHX.CachedTaunts[ply:Team()])
	-- if PHX.CachedTaunts[ply:Team()] != nil then
	-- 	PrintTable(PHX.CachedTaunts[ply:Team()][name])
	-- end
	local snd 		= net.ReadString()
	snd = PHX.CachedTaunts[ply:Team()][name]
	-- PrintTable(snd)
	local bool 		= net.ReadBool()	-- enable fake taunt
	
	local isPitchEnabled = PHX:GetCVar( "ph_taunt_pitch_enable" )
	
	if (ply and IsValid(ply)) then
	
		local delay 		= IsDelayed(ply)
		local isDelay 		= delay[1]
		local TauntTime 	= delay[2]
		local playerTeam	= ply:Team()
        local plPitchOn     = ply:GetInfoNum( "ph_cl_pitch_taunt_enable", 0 )
		local plApplyOnFake = ply:GetInfoNum( "ph_cl_pitch_apply_fake_prop", 0 )
        local plPitchRandomized = ply:GetInfoNum( "ph_cl_pitch_randomized", 0 )
        local randFakePitch = ply:GetInfoNum( "ph_cl_pitch_fake_prop_random", 0 )
		local desiredPitch	= ply:GetInfoNum( "ph_cl_pitch_level", 100 )
		local pitch			= 100
	
		if !isDelay then
			if bool then --if it's Fake Taunt
				if PHX:GetCVar( "ph_randtaunt_map_prop_enable" ) then
					local Count = ply:GetTauntRandMapPropCount()
                    
                    if ply:Team() ~= TEAM_PROPS then
                        ply:PHXChatInfo( "ERROR", "PHX_CTAUNT_RAND_PROPS_NOT_PROP" )
                        return
                    end
					
					if Count > 0 or PHX:GetCVar( "ph_randtaunt_map_prop_max" ) == -1 then
						
						-- Don't use PHX:PlayTaunt here. This is NOT player entity!!
						if CheckValidity2( name, snd, playerTeam ) then							
							if isPitchEnabled and tobool(plApplyOnFake) then
                                if tobool(randFakePitch) then
                                    pitch = math.random(PHX:GetCVar( "ph_taunt_pitch_range_min" ), PHX:GetCVar( "ph_taunt_pitch_range_max" ))
                                else
                                    pitch = math.Clamp(desiredPitch, PHX:GetCVar( "ph_taunt_pitch_range_min" ), PHX:GetCVar( "ph_taunt_pitch_range_max" ))
                                end
							end
							
							local props = ents.FindByClass("prop_physics")
                            table.Add( props, ents.FindByClass("ph_fake_prop") ) -- add ph_fake_prop as well.
							local randomprop = table.Random( props ) -- because of table.Add, it become non-sequential.
							
							if IsValid(randomprop) then
								randomprop:EmitSound(snd[1], 100, 100)
								ply:SubTauntRandMapPropCount()
								SetLastTauntDelay( ply )
							end
						else
							ply:PHXChatInfo( "WARNING", "TM_DELAYTAUNT_NOT_EXIST" )
						end
						
					else
						ply:PHXChatInfo( "WARNING", "PHX_CTAUNT_RAND_PROPS_LIMIT" )
					end
				end
			else	-- if it's Player Taunt
				if CheckValidity2( name, snd, playerTeam ) then
				
					PHX:PlayTaunt( ply, snd, plPitchOn, desiredPitch, plPitchRandomized, "CLastTauntTime" )
					-- ply:SetLastTauntTime( "LastTauntTime", CurTime() )
					
				else
					ply:PHXChatInfo( "WARNING", "TM_DELAYTAUNT_NOT_EXIST" )
				end
			end
		end
		
	end
end)
