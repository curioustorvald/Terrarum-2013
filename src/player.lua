-- player class
-- Author: Sean Laurvick
-- A simple player object for use in the Platformer game.

player = {} 
-- Constructor
function player:new()
    -- define our parameters here
    local object = {
    scale = 1,
    x = 0,
    y = 0,
    width = 0,
    height = 0,
    xSpeed = 0,
    ySpeed = 0,
    xSpeedMax = 128,
    xSprintSpeedMax = 256,
    ySpeedMax = 800,
    state = "",
    jumpSpeed = 0,
    runSpeed = 0,
    onFloor = false,
    isStand = false,
    isSprint = false,
    gamemode = 0, --0: survival, 1:creative
    isFlymode = false,
    noclip = false,
    mass = 0,
    health = 0,
    mana = 0,
    hasJumped = false,
    inventory = {}
    }
    setmetatable(object, { __index = player })
    return object
end

-- Movement functions
function player:jump()
    if self.onFloor and not self.isFlymode then
        self.ySpeed = self.jumpSpeed
        self.onFloor = false
    elseif self.isFlymode then
      self.ySpeed = self.jumpSpeed
      self.onFloor = false
    end
end

function player:moveRight()
    self.isStand = false
    --self.xSpeed = self.runSpeed
    
    if self.ySpeed ~= 0 then
      --Slowly accelerate player
      self.xSpeed = self.xSpeed + self.runSpeed * self.scale * 0.2
      if self.xSpeed > self.xSpeedMax then self.xSpeed = self.xSpeedMax end
    else
      --gradually accelerate player
      --self.xSpeed = self.xSpeed + self.runSpeed * self.scale
      --if self.xSpeed > self.xSpeedMax then self.xSpeed = self.xSpeedMax end
      self.xSpeed = self.runSpeed + self.xSpeed
    end
end

function player:moveLeft()
    self.isStand = false
    --self.xSpeed = -1 * (self.runSpeed)
    
    if self.ySpeed ~= 0  then
      --Slowly accelerate player, applying air friction
      self.xSpeed = self.xSpeed - self.runSpeed * self.scale * 0.2
      if self.xSpeed < -1 * self.xSpeedMax then self.xSpeed = -1 * self.xSpeedMax end
    else
      --gradually accelerate player, applying friction
      self.xSpeed = self.xSpeed - self.runSpeed * self.scale
      if self.xSpeed < -1 * self.xSpeedMax then self.xSpeed = -1 * self.xSpeedMax end
    end
end

function player:stop()
    self.state = "stand"
    self.isStand = true
    self.isSprint = false
    if self.isFlymode then
      self.ySpeed = 0
    end
    --self.xSpeed = 0
    --self.xSpeed = math.floor( self.xSpeed / 2 )
end

function player:moveDown()
  self.state = "fall"
  self.isStand = false
  self.isSprint = false
  
  self.ySpeed = -1 * self.jumpSpeed
  if self.ySpeed > self.ySpeedMax then self.ySpeed = self.ySpeedMax end
end
  
function player:setFlymode()
  self.isFlymode = true
  self.runSpeed = self.runSpeed * 2
  self.xSpeedMax = self.xSpeedMax * 2
  self.jumpSpeed = self.jumpSpeed * math.sqrt(2)
end

function player:unsetFlymode()
  self.isFlymode = false
  self.runSpeed = self.runSpeed / 2
  self.xSpeedMax = self.xSpeedMax / 2
  self.jumpSpeed = self.jumpSpeed / math.sqrt(2)
end


-- Do various things when the player hits a tile
function player:collide(event)
    if event == "floor" then
        self.ySpeed = 0
        self.onFloor = true
    end
    if event == "ceiling" then
        self.ySpeed = 0
    end
end

-- Update function
function player:update(dt, gravity, map)
    local halfX = self.width / 2
    local halfY = self.height / 2
    
    local noApplyGravity = false
    
    -- apply gravity (ignore when loading big shit)
    if not self.isFlymode and dt < 0.1 then
      self.ySpeed = self.ySpeed + (gravity) --should be ySpeed * gravity * dt to not slow down physics while FPS drops
    end
    
    -- limit the player's speed
    self.xSpeed = math.clamp(self.xSpeed, -self.xSpeedMax, self.xSpeedMax)
    self.ySpeed = math.clamp(self.ySpeed, -self.ySpeedMax, self.ySpeedMax)
    
    -- calculate vertical position and adjust if needed
    local nextY = math.floor(self.y + (self.ySpeed * dt))
    if self.ySpeed < 0 then -- check upward
        if not(self:isColliding(map, self.x - halfX, nextY - halfY))
            and not(self:isColliding(map, self.x + halfX - 1, nextY - halfY)) then
            -- no collision, move normally
            self.y = nextY
            self.onFloor = false
            noApplyGravity = false
        else
            -- collision, move to nearest tile border
            self.y = nextY + 16 - ((nextY - halfY) % 16)
            self:collide("ceiling")
            noApplyGravity = false
        end
    elseif self.ySpeed > 0 then -- check downward
        if not(self:isColliding(map, self.x - halfX, nextY + halfY))
            and not(self:isColliding(map, self.x + halfX - 1, nextY + halfY)) then
            self.y = nextY
            self.onFloor = false
            noApplyGravity = false
        else
            -- collision, move to nearest tile border
            self.y = nextY - ((nextY + halfY) % 16)
            self:collide("floor")
            noApplyGravity = true
        end
    end

    -- calculate horizontal position and adjust if needed
    local nextX = self.x + (self.xSpeed * dt)
    if self.xSpeed > 0 then -- check right
        if not(self:isColliding(map, nextX + halfX, self.y - halfY))
            and not(self:isColliding(map, nextX + halfX, self.y + halfY - 1)) then
            -- no collision
            self.x = nextX
        else
            -- collision, move to nearest tile
            self.x = nextX - ((nextX + halfX) % 16)
        end
    elseif self.xSpeed < 0 then -- check left
        if not(self:isColliding(map, nextX - halfX, self.y - halfY))
            and not(self:isColliding(map, nextX - halfX, self.y + halfY - 1)) then
            -- no collision
            self.x = nextX
        else
            -- collision, move to nearest tile
            self.x = nextX + 16 - ((nextX - halfX) % 16)
        end
    end
    
    -- update the player's state
    self.state = self:getState()
    
    -- decellerate player 
    if self.isStand and self.ySpeed ~= 0 and self.xSpeed < 0 then --moveLeft and in flight then
      self.xSpeed = self.xSpeed + 4 * self.scale
      if self.xSpeed > -4 then self.xSpeed = 0 end
    elseif self.isStand and self.xSpeed < 0 then --moveLeft
      self.xSpeed = self.xSpeed + 16 * self.scale
      if self.xSpeed > -16 then self.xSpeed = 0 end
    elseif self.isStand and self.ySpeed ~= 0 and self.xSpeed > 0 then --moveRight and in flight then
      self.xSpeed = self.xSpeed - 4 * self.scale
      if self.xSpeed < 4 then self.xSpeed = 0 end
    elseif self.isStand and self.xSpeed > 0 then --moveRight
      self.xSpeed = self.xSpeed - 16 * self.scale
      if self.xSpeed < 16 then self.xSpeed = 0 end
    end
end

-- returns true if the coordinates given intersect a map tile
function player:isColliding(map, x, y)
    -- get tile coordinates
    local layer = map.layer.Terrain
    local tileX, tileY = math.floor(math.abs(x / 16)), math.floor(math.abs(y / 16))
    
    -- grab the tile at given point
    local tile = layer[tileY][tileX]
    
    -- return true if the point overlaps a solid tile
    --return not(tile == nil)
    if self.noclip then
      return false
    elseif tile ~= 0 and not self.noclip then -- and tile.properties.solid == "true" and not self.noclip then
      return true
    else
      return false
    end
end

-- returns player's state as a string
function player:getState()
    local myState = ""
    if self.onFloor then
        if self.xSpeed > 0 and not stop then
            myState = "moveRight"
        elseif self.xSpeed < 0 and not stop then
            myState = "moveLeft"
        else
            myState = "stand"
        end
    end
    if self.ySpeed < 0 then
        myState = "jump"
    elseif self.ySpeed > 0 then
        myState = "fall"
    end
    return myState
end

function player:withinReach(x,y)
  --in absolute terrarum unit
  local reach = 64 * self.scale
  
  if math.sqrt( math.abs( self.x - x )^2 + math.abs( self.y - y )^2 ) <= reach then
    return true
  else
    return false
  end
end

function player:_isSolid(tileX,tileY)
  local tile = map.layer.Terrain[tileX][tileY]
  
  --properties[blockID+1][propertiesIndex].xarg.value
  if self.properties[tile+1][9].xarg.value == "true" then
    return true
  else
    return false
  end
end