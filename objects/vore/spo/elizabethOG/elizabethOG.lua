function init()

  self.detectArea = entity.configParameter("detectArea")
  self.detectArea[1] = entity.toAbsolutePosition(self.detectArea[1])
  self.detectArea[2] = entity.toAbsolutePosition(self.detectArea[2])

  chatOptions = entity.configParameter("chatOptions", {})
  gulpLines = entity.configParameter("gulpLines", {})
  chatIdleEmpty = entity.configParameter("chatIdleEmpty", {})
  
-- Animation related
  animLock = false
  soundLock = false
  releaseLock = false
  idleTimer = 0
  eatingTimer = 0
  releaseTimer = 0

-- Chat related
  ohSnap = false
end

function update(dt)

  local players = world.entityQuery(self.detectArea[1], self.detectArea[2], {
      includedTypes = {"player"},
      boundMode = "CollisionArea"
  })
  
  if #players > 0 and not ohSnap then
  -- Displays the empty lines if the predator is empty, else full.
    if world.loungeableOccupied(entity.id()) == false then
    -- But only if it isnt already displaying a line.
	  if #chatIdleEmpty > 0 then
		entity.say(chatIdleEmpty[math.random(1, #chatIdleEmpty)])
	  end
	end
	ohSnap = true
    -- Sets ohSnap to false when no players are within the dection area.
  elseif #players == 0 and ohSnap then
    ohSnap = false
  end
-- Randomly displays the "Player inside Pred" lines
  if world.loungeableOccupied(entity.id()) and math.random(150) == 1 then
    if #chatOptions > 0 then
      entity.say(chatOptions[math.random(1, #chatOptions)])
    end
  end
  
  -- Animations that happens while the predator is empty (hungry).
  if world.loungeableOccupied(entity.id()) == false then
	  
	-- Resets the predator to the idle state
    if animLock == false then
	  entity.setAnimationState("bodyState", "waiting")
	  idleTimer = 0
      releaseLock = false
      releaseTimer = 0
	    -- If player leaves after being eaten, it plays the release animation.
		if eatingTimer >= 20 then
		  animLock = true
		  eatingTimer = 0
		  releaseLock = true
		  entity.setAnimationState("bodyState", "release")
		  entity.playSound("lay")
		end
	  end
	-- Randomises different animations, like  blink and waiting.

	if animLock == false and math.random(100) == 1 then
	  animLock = true
	  entity.setAnimationState("bodyState", "blink")
	end
	if animLock == false and math.random(400) == 1 then
	  animLock = true
	  entity.setAnimationState("bodyState", "idle1")
	end	  
	if animLock == false and math.random(400) == 1 then
	  animLock = true
	  entity.setAnimationState("bodyState", "idle2")
	end	  
	if animLock == false and math.random(1000) == 1 then
	  animLock = true
	  entity.setAnimationState("bodyState", "idle3")
	end	
  
	if idleTimer >= 60 or releaseTimer >= 12 then
	  animLock = false
	end
	  
	-- Counts time being idle and empty.
	idleTimer = idleTimer + 1
	  
	if releaseLock == true then
	  releaseTimer = releaseTimer + 1
	end
  elseif world.loungeableOccupied(entity.id()) == true and eatingTimer <= 20 then
    -- Swallow animation
	if soundLock == false then
	  entity.playSound("swallow")
      soundLock = true
	end
	  
	entity.setAnimationState("bodyState", "swallow")
	eatingTimer = eatingTimer + 1
	  
  else
    -- Animations that happens while the predator is full (digesting).
	
	soundLock = false
	entity.setAnimationState("bodyState", "fullbig")
  end
end
  
function onInteraction(args)

  if not prey then
    prey = nil
  end

  -- Makes sure only the pred only checks the health of the prey inside.
  if world.loungeableOccupied(entity.id()) == false then
    prey = args.sourceId
  end
  
  -- Unless the predator is full it will activate this code.
  if world.loungeableOccupied(entity.id()) == false then
  -- Swallows the prey, playing the gulp sound and displaying a line. Also sets the player to be "prey".
    if #gulpLines > 0 then
      entity.say(gulpLines[math.random(1, #gulpLines)])
	  prey = args.sourceId
    end
  end

end