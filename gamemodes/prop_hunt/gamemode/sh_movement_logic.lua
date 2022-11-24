--Made by Gravious, edited by MrRangerLP.
AddCSLuaFile()

-- local function PlayerGround(ply,bWater)
	-- if not IsValid(ply) then return end
	
	-- ply:SetJumpPower(284)
-- end; hook.Add("OnPlayerHitGround","HitGround",PlayerGround)

local GroundFrames = {}
local function PlayerMove(ply,data)
	if not IsValid(ply) then return end

	local OnGround = ply:IsOnGround() --ply:IsFlagSet(FL_ONGROUND)
	if OnGround and not GroundFrames[ply] then
		GroundFrames[ply] = 0
	elseif OnGround and GroundFrames[ply] then
		GroundFrames[ply] = GroundFrames[ply] + 1
		if GroundFrames[ply] > 4 then
			ply:SetDuckSpeed(0.4)
			ply:SetUnDuckSpeed(0.2)
		end
	end

	if OnGround or not ply:Alive() then return end
	
	GroundFrames[ply] = 0
	ply:SetDuckSpeed(0)
	ply:SetUnDuckSpeed(0)

	local aim = data:GetMoveAngles()
	local forward, right = aim:Forward(), aim:Right()
	local fmove = data:GetForwardSpeed()
	local smove = data:GetSideSpeed()
	local strafing = false

	if data:KeyDown(IN_MOVERIGHT) then
		smove = (smove * 10) + 500
	elseif data:KeyDown(IN_MOVELEFT) then
		smove = (smove * 10) - 500
	end

	forward.z, right.z = 0,0
	forward:Normalize()
	right:Normalize()

	local wishvel = forward * fmove + right * smove
	wishvel.z = 0

	local wishspeed = wishvel:Length()
	if wishspeed > data:GetMaxSpeed() then
		wishvel = wishvel * (data:GetMaxSpeed() / wishspeed)
		wishspeed = data:GetMaxSpeed()
	end

	local wishspd = wishspeed
	wishspd = math.Clamp(wishspd, 0, 32.4)

	local wishdir = wishvel:GetNormal()
	local current = data:GetVelocity():Dot(wishdir)
	
	local addspeed = wishspd - current
	if addspeed <= 0 then return end

	local accelspeed = 120 * FrameTime() * wishspeed
	if accelspeed > addspeed then
		accelspeed = addspeed
	end

	local vel = data:GetVelocity()
	vel = vel + (wishdir * accelspeed)
	data:SetVelocity(vel)
	
	return false
end; hook.Add("FinishMove","StrafeMovement",PlayerMove)