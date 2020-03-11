
function GM:PlayerJoinTeam()
	return false
end

function GM:PlayerRequestTeam()
	return false
end

function GM:Move( p, md )
	local aim = md:GetMoveAngles()
	local forward, right = aim:Forward(), aim:Right()
	local fmove = md:GetForwardSpeed()
	local smove = md:GetSideSpeed()
	
	forward.z, right.z = 0,0
	forward:Normalize()
	right:Normalize()
	
	local wishvel = forward * fmove + right * smove
	wishvel.z = 0
	
	local wishspeed = wishvel:Length()
	
	if (wishspeed > md:GetMaxSpeed()) then
		wishvel = wishvel * (md:GetMaxSpeed() / wishspeed)
		wishspeed = md:GetMaxSpeed()
	end
	
	local wishspd, wishdir, current, addspeed, accelspeed
	
	if !p:IsOnGround() then
		wishspd = math.Clamp(wishspeed, 5, 50)
		wishdir = wishvel:GetNormal()
		current = md:GetVelocity():Dot(wishdir)
		addspeed = wishspd - current
		accelspeed = 100 * wishspeed * FrameTime()
		
		if (addspeed <= 0) then return end
		
		if(accelspeed > addspeed) then
			accelspeed = addspeed
		end
		
		md:SetVelocity(md:GetVelocity() + (wishdir * accelspeed))
	end
	
	return false
end

function GM:ShouldCollide( ent, ent2 )
	if ent:IsPlayer() and ent2:IsPlayer() then
		return false
	end
	
	return true
end
