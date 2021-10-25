Game = {}
Game.__index = Game
local blockDiggingTime = 0.125 --TODO:change 0.125 respective for tools
hangTime = 0
animFrame = 1

function Game:update(dt)
  camX, camY = camera._x, camera._y
  mouseX = love.mouse.getX()
  mouseY = love.mouse.getY()
  mouseTileX = math.floor( (mouseX + camX) / 16)
  mouseTileY = math.floor( (mouseY + camY) / 16)
  tileX = math.floor(p.x / 16)
  tileY = math.floor(p.y / 16)
  cursorInReach = p:withinReach(mouseX + camX, mouseY + camY)
  
  --self:updateKeypress(dt)
  self:updatePlayer(dt)
  self:updateDraw(dt)
  self:editWorld(dt)
end

function Game:keypressed(key)
	if key == "d" then
	    --prevent sprite from flipping when in flight
	    if p.ySpeed == 0 then
	    	animation:flip(false, false)
	    end
	    --then move
	    p:moveRight()
	elseif key == "a" then
	    --prevent sprite from flipping when in flight
	    if p.ySpeed == 0 then
	    	animation:flip(true, false)
	    end
	    --then move
	    p:moveLeft()
	end
	
	if key == " " or ( key == "w" and p.isFlymode ) then
    	p:jump()
	elseif ( key == "lshift" or key == "s") and p.isFlymode then
    	p:moveDown()
	end
	
	--= Set flymode and noclip =--
	------------------------------
	if key == "f" and not p.isFlymode and p.gamemode == 1 then
		p:setFlymode()
	elseif key == "f" and p.isFlymode and p.gamemode == 1 then
		p:unsetFlymode()
	end
	    
	if key == "v" and not p.isFlymode and p.gamemode == 1 then
		p:setFlymode()
		p.noclip = true
	elseif key == "v" and p.isFlymode and p.gamemode == 1 then
		p:unsetFlymode()
		p.noclip = false  
	end
	
	--= open and close inventory =--
	--------------------------------
	if key == "q" and not menubar.opened then
		menubar:openInventory()
	elseif key == "q" and menubar.opened then
		menubar:closeInventory()
	end
end

function Game:updatePlayer(dt)
  --get mouseblock
  if cursorInReach then
    mouseBlock = map.layer.Terrain[mouseTileY][mouseTileX]
  end
    
  --Temporal: change holding block
  if love.keyboard.isDown("[") then
    holdingBlock = holdingBlock + 1
    love.timer.sleep(0.1)
  elseif love.keyboard.isDown("]") then
    holdingBlock = holdingBlock - 1
    love.timer.sleep(0.1)
  end
    
  if holdingBlock == 0 then holdingBlock = 255 end
  if holdingBlock == 256 then holdingBlock = 1 end
    
  --= update the player's position and check for collisions =--
  -------------------------------------------------------------
  p:update(dt, gravity, map)
  
  --= stop the player when they hit the borders =--
  -------------------------------------------------
  if p.x < p.width/2 then p.x = p.width/2 end
  --right side barrier: bedrock wall
  if p.y < p.height/2 then p.y = p.height/2 end
  if p.y > map.height*16 - p.height then p.y = map.height*16 - p.height end
  
end

function Game:updateDraw(dt)
  --= update the sprite animation =--
  -----------------------------------
  if (p.state == "stand") then
    animation:switch(1, 3, 200)
  end
  if (p.state == "moveRight") or (p.state == "moveLeft") then
    animation:switch(2, 3, 65) --60 for mario?
  end
  if (p.state == "jump") then
    animation:reset()
    animation:switch(3, 1, 300)
  end
  if (p.state == "fall") then
    animation:reset()
    animation:switch(4, 1, 300)
  end
  animation:update(dt)
    
  --= center the camera on player =--
  -----------------------------------
  camera:setPosition(math.floor(p.x - w / 2), math.floor(p.y - h / 2))
  
end
 
function Game:editWorld(dt)
  --= place and remove block =--
  ------------------------------
  if p.gamemode == 1 and cursorInReach and mouseX < w-26 and  map.layer.Terrain[mouseTileY][mouseTileX] ~= 17 then
  	if love.mouse.isDown("r") then
    	map.layer.Terrain[mouseTileY][mouseTileX] = 6
  	elseif love.mouse.isDown("l") then
    	map.layer.Terrain[mouseTileY][mouseTileX] = 0
	end
  elseif p.gamemode == 0 and cursorInReach and mouseX < w-26 and  map.layer.Terrain[mouseTileY][mouseTileX] ~= 17 then
		if love.mouse.isDown("l") and map.layer.Terrain[mouseTileY][mouseTileX] ~= 0 then
			--when mouse down, add up immediately
			if hangTime > 1 then
				hangTime = 0
			else
				hangTime = hangTime + dt
			end
			
			if hangTime == nil or hangTime >= blockDiggingTime then
				self:dig(dt)
			end
		elseif love.mouse.isDown("r") then
			--when mouse down, add up immediately
			if hangTime > 1 then
				hangTime = 0
			else
				hangTime = hangTime + dt
			end
			--hang for 8^-1 sec
			if hangTime == nil or hangTime >= 0.2 then
				self:place(dt)
			end
		end
  end
  --reset frame if mouse not down
  if not love.mouse.isDown("l") then
  	animFrame = 1
  end
  if hangTime <= 1 then
  	hangTime = hangTime + dt
  end
end

function Game:dig(dt)
	-- get quickslot num and inventory
	g.drawq(breakImage, breakOverlay[animFrame], mouseTileX*16 - camX, mouseTileY*16 - camY )
	g.present()
	if hangTime >= blockDiggingTime/10 then
		animFrame = animFrame+1
	end
	-- remove block
	if animFrame >= 10 then
		map.layer.Terrain[mouseTileY][mouseTileX] = 0
		animFrame = 1
		hangTime = 0
		--map:draw(true)
	end
end

function Game:place(dt,selectedBlock)
	map.layer.Terrain[mouseTileY][mouseTileX] = selectedBlock or 1
	hangTime = 0
end

function Game:draw()
  camera:set()
  
  -- round down our x, y values
  local x, y = math.floor(p.x), math.floor(p.y)
  local camX, camY = camera._x, camera._y
  
  local mouseX, mouseY = love.mouse.getX(), love.mouse.getY()
  
  local mouseTileX = math.floor( (mouseX + camX) / 16)
  local mouseTileY = math.floor( (mouseY + camY) / 16)
  
  --draw the map
  map:draw(true)
  
  -- draw the player
  animation:draw(x - p.width / 2, y - p.height / 2)
  
  camera:unset()

  --cursor overlay
  if p:withinReach(mouseX + camX, mouseY + camY) and mouseX < w-26 then
    g.draw(cursorOverlay, mouseTileX*16 - camX, mouseTileY*16 - camY )
  end
  
  --UI and other little things
  menubar:draw()
  --g.draw(menubarImg, w-30, 0)
  --health bar
  local fullHealth = math.ceil(baseHealth*p.scale^(3) )
  local fullMana = baseMana
  
  g.setColor(255,55,55)
  g.rectangle("fill",w-26, h-4 - math.floor( 106*(p.health/fullHealth) ) ,8, math.floor( 106*(p.health/fullHealth) ) )
  
  g.setColor(64,64,255)
  g.rectangle("fill",w-12, h-4 - math.floor( 106*(p.mana/fullMana) ) ,8, math.floor( 106*(p.mana/fullMana) ) )
  
  g.setFont(statFont)
  
  g.setColor(255,255,255)
  g.print(p.health, w-18, h-10 - ( math.floor(math.log10(p.health)) * 7 ), math.pi/2)
  g.print(p.mana, w-4, h-10 - ( math.floor(math.log10(p.mana)) * 7 ), math.pi/2)
  
  g.setFont(mainFont)
end