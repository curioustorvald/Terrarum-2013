--function love.load()
  --loading
  --[[love.graphics.print("Importing world...",20,40)
  love.graphics.present()

  loadWorld("test")
  
  love.graphics.print("Loading world data...",20,40)
  love.graphics.present()
  
  loadWorldImage("test")]]
  
--end

--print("# of world.geometry: "..#world.geometry)
require "player"

function game_load()
  g = love.graphics
  playerImage = g.newImage("graphics/player.png")
  groundColour = {25,200,25}
  
  player:init(1)
  player.x = 300
  player.y = 300
  player.jumpSpeed = -800
  player.runSpeed = 500
  
  gravitationalAcceration = 1800
  
  yFloor = 500
end

function game_update(dt)
  if love.keyboard.isDown("d") then
    player:moveRight()
  end
  if love.keyboard.isDown("a") then
    player:moveLeft()
  end
  
  if love.keyboard.isDown(" ") then
    player:jump()
  end
  
  player:update(dt,gravitationalAcceleraton)
  
  --stop player when hit border
  if player.x > 800 - player.width then player.x = 800 - player.width end
  if player.x < 0 then player.x = 0 end
  if player.y < 0 then player.y = 0 end
  if player.y > yFloor - player.height then
    player:hitFloor(yFloor)
  end
end

function game_draw()
  local x = math.floor(p.x)
  local y = math.floor(p.y)
  
  --draw player shape
  g.draw(playerImage,x,y)
  
  --draw ground
  g.setColor(groundColour)
  g.rectangle("fill",0,yFloor,800,100)
  
  -- debug information
  g.setColor(255, 255, 255)
  local isTrue = ""
  g.print("Player coordinates: ("..x..","..y..")", 5, 5)
  g.print("Current state: "..player.state, 5, 20)
end
  
function love.keyreleased(key)
    if (key == "d") or (key == "a") then
        player:stop()
    end
end


--[[function game_draw()
  love.graphics.setBackgroundColor(144,192,255)
  for i=1,25 do
    love.graphics.drawq(imgTerrain, blockTile[i], (i-1)*16, 0)
  end
  
  love.graphics.setBackgroundColor({156,192,255}) --normally it depend on class (worldname)
  updateWorld(world)
  
  love.graphics.print("playerX (in block): "..(playerPosX/16)..", playerY (in block)"..(playerPosY/16),0,32)
  
end

function love.keypressed(k)
  if k == "a" then
    playerPosX = playerPosX - 16
  elseif k == "d" then
    playerPosX = playerPosX + 16
  elseif k == "w" then
    playerPosY = playerPosY - 16
  elseif k == "s" then
    playerPosY = playerPosY + 16
  end
end]]

--[[function game_update(dt)
  love.keypressed(k)
  gameWorld:update(dt)
end]]