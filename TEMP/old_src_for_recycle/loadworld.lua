function loadWorld(name)
  require("maps/world_"..name)
  
  gameWorld = love.physics.newWorld(0,gravitationalAcceleration*16,true)
end