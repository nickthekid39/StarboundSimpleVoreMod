animState = "blank"

beat = 0.3
timer = 0

eatLock = true
swallowLock = true

function init()

end

function update(dt)
	
	if world.loungeableOccupied(entity.id()) then

		timer = timer + dt
	
		if timer < 4 then
--			coil1

			animator.setAnimationState("bodyState", "coil1")
			beat = beat + dt
			if beat >=0.6 then
				animator.playSound("coil")
				beat = beat - 0.6
			end

		elseif timer < 7 then
--			coil2

			animator.setAnimationState("bodyState", "coil2")
			beat = beat + dt
			if beat >=0.4 then
				animator.playSound("coil")
				beat = beat - 0.4
			end
			
		elseif timer < 10 then
--			swallow

			animator.setAnimationState("bodyState", "swallow")
			if eatLock and timer < 10.5 then
				animator.playSound("eat")
				eatLock = false
			elseif swallowLock and timer < 11 then
				animator.playSound("swallow")
				swallowLock = false
			end
		elseif timer < 13 then
		
			beat = beat + dt
			if beat >=0.8 then
				animator.playSound("digest")
				beat = beat - 0.8
			end
		elseif timer < 17 then
--			fed2

			animator.setAnimationState("bodyState", "fed2")
			beat = beat + dt
			if beat >=0.8 then
				animator.playSound("digest")
				beat = beat - 0.8
			end
		elseif timer < 21 then
--			fed3

			animator.setAnimationState("bodyState", "fed3")
			beat = beat + dt
			if beat >=0.8 then
				animator.playSound("digest")
				beat = beat - 0.8
			end
		else
--			fed4

			animator.setAnimationState("bodyState", "fed4")
			beat = beat + dt
			if beat >=0.8 then
				animator.playSound("digest")
				beat = beat - 0.8
			end
		end
	else
		beat = 0.3
		timer = 0
		eatLock = true
		swallowLock = true
		animState = animator.animationState("bodyState")
		
		if animState == "fed1" or animState == "fed2" or animState == "fed3" or animState == "fed4" then
			animator.setAnimationState("bodyState", "release")
			animator.playSound("eat")
		elseif animState == "coil1" or animState == "coil2" or animState == "swallow" then
			animator.setAnimationState("bodyState", "idle1")
		elseif animState == "idle1" and math.random(500) == 1 then
			animator.setAnimationState("bodyState", "idle2")
		end
	end
end