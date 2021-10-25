player = {}

--Constructor
function player:init(scale)
  if scale == nil then scale = 1 end
  
  local object = {
  x = 0,
  y = 0,

  width = 24*scale,
  height = 46*scale,

  xSpeed = 0,
  ySpeed = 0,

  state = "",

  jumpSpeed = 0,
  runSpeed = 0,

  canJump = false
  }
  setmetatable(object, { __index = player })
  return object
end

function player:jump()
  if self.canJump then
    self.ySpeed = self.jumpSpeed
    self.canJump = false
  end
end

function player:moveRight()
  self.xSpeed = self.runSpeed
  self.state = "moveRight"
end

function player:moveLeft()
  self.xSpeed = -1*self.runSpeed
  self.state = "moveLeft"
end

function player:stop()
  self.xSpeed = 0
end

function player:hitFloor(maxY)
  self.y = maxY - self.height
  self.ySpeed = 0
  self.canJump = true
end

--update player
function player:update(dt,gravity)
  --update position
  self.x = self.x + (self.xSpeed*dt)
  self.y = self.y + (self.ySpeed*dt)
  
  --gravity
  self.ySpeed = seld.ySpeed + gravity*dt
  
  --update state
  if not self.canJump then
    if self.ySpeed < 0 then
      self.state = "jump"
    elseif self.ySpeed > 0 then
      self.state = "fall"
    end
  else
    if self.xSpeed > 0 then
      self.state = "moveRight"
    elseif self.xSpeed < 0 then
      self.state = "moveLeft"
    else
      self.state = "stand"
    end
  end
end