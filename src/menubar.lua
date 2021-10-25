menubar = {}

function menubar:new()
  local object = {
    menubarImage = nil,
    inventoryImage = nil,
    opened = false
  }
  setmetatable(object, { __index = menubar })
  return object
end

--menubar = {}

--menubarImage = love.graphics.newImage("graphics/gui/menubar.png")

local function transition(x,duration,scrollSize)
	return -0.5*scrollSize*math.cos(math.pi/duration*x) + 0.5*scrollSize
end

function menubar:fastEffect(step,scrollSize,duration)
	return -1*(scrollSize/(duration)^2)*(step-duration)^2+scrollSize
end



function menubar:draw()
  love.graphics.draw(self.menubarImage, w - 30 , 0)
  
  if self.opened then
    love.graphics.draw(self.inventoryImage, ( w - self.inventoryImage:getWidth() )/2 , ( h - self.inventoryImage:getHeight() )/2)
  end
end

function menubar:openInventory()
  
  --game must pause when menubar open, map loading, ...
  self.opened = true
end

function menubar:closeInventory()
  self.opened = false
end