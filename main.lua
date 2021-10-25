require "src/MapLoader/Loader"

require "src/player"
require "src/SpriteAnimation"
require "src/camera"

require "src/external/bdh"

require "src/tileproperties"
require "src/menubar"
require "src/inventory"
require "src/worldedit"
require "src/game"
require "src/musica"

--ATLgrid = require("AdvTiledLoader/Grid")

print(_VERSION)
 
function love.load()
  --[[splash
  local splash = love.graphics.newImage("res/graphics/splash/splash.png")
  love.graphics.draw(splash)
  love.graphics.present()
  love.timer.sleep(2)
  love.graphics.clear()]]
  
  
  loading = true
  print("Loading game...")
  
  --g = love.graphics
  
  w = love.graphics.getWidth()
  h = love.graphics.getHeight()
  
  halfW, halfH = w/2, h/2
  
  tilesW = math.ceil( (w-30)/16 )
  tilesH = math.ceil( h / 16 )--+ 1 )
  
  baseHealth = 200
  baseMana = 100
  
  love.graphics.setDefaultImageFilter("nearest","nearest")
  
  mainFont = love.graphics.newFont("res/graphics/fonts/Stoclet ITC Bold.ttf",18)
  statFont = love.graphics.newImageFont("res/graphics/fonts/numberSmallBulky.png","0123456789")
  love.graphics.setFont( mainFont )
  
  --= Temporal: Loading screen =--
  love.graphics.print("Loading map...",5,5)
  love.graphics.present()
  
  love.graphics.setBackgroundColor(156, 192, 255)
  
  --= Load up the map =--
  -----------------------
  map = Loader.load("test/maps/testmap")
  -- Map info
  print("Map information")
  print("Filename: test/maps/testmap2")
  if map.layer.Terrain[63][63] ~= nil then print("map.Layer.Terrain checked") end
  if map.layer.Wall[63][63] ~= nil then print("map.Layer.Wall checked") end
  if map.tileset[256] ~= nil then print("map.tileset checked") end
  print("Number of layer (layer): "..#map.layer)
  print("Number of layer (nLayer): "..map.nLayer)
  print("Width: "..map.width)
  print("Height: "..map.height)
  print("Current spawn point: ("..map.spawnX..", "..map.spawnY..")")
  print("Original spawn point: ("..map.originalSpawnX..", "..map.originalSpawnY..")")
  print("Map name: "..map.name)
  -- Map info end
  
  --= restrict camera =--
  -----------------------
  camera:setBounds(0,0,map.width * 16 - w, map.height * 16 - h)
  
  --= load properties =--
  -----------------------
  tileProp = tileProperties:new()
  tileProp = tileProperties:loadDB()
  
  --itemProp = itemProperties:new()
  --itemProp = tileProperties:loadXML()
  
  --= Set class value 'player' =--
  --------------------------------
  p = player:new()
  p.x = 290
  p.y = 500
  p.width = 16 * p.scale - 2
  p.height = 32 * p.scale
  p.jumpSpeed = -230 * math.sqrt(p.scale)
  p.runSpeed = 16 * p.scale --MUST be powers of 2
  p.xSpeedMax = 128 * p.scale --128 is default
  p.mass = 70 * p.scale^3
  p.health = math.ceil(baseHealth*p.scale^(3) )-- * p.scale^(0.75))
  p.mana = baseMana
  p.isSprint = false
  p.gamemode = 0
  p.hasJumped = false
  delay = 120
  
  p.inventory = inventory:new()

  --= Load player animation =--
  -----------------------------
  animation = SpriteAnimation:new("res/graphics/sprites/linkanimations.png", 16, 32, 3, 4, p.scale, p.scale)
  animation:load(delay)
  
  --= load GUI image =--
  ----------------------
  menubar:new()
  menubar.menubarImage = love.graphics.newImage("res/graphics/gui/menubar.png")
  menubar.inventoryImage = love.graphics.newImage("res/graphics/gui/inventory/inventoryPopup.png")
  
  --= load various images =--
  ---------------------------
  breakImage = love.graphics.newImage("res/graphics/breakAnim.png")
  breakOverlay = {}
  for i=1,10 do
  	breakOverlay[i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, 160, 16)
  end
  
  cursorOverlay = love.graphics.newImage("res/graphics/cursoroverlay.png")
  
  --= Misc variables =--
  ----------------------
  gravity = 9.8
  
  loading = false
  print("Game served, bitches!")
end
 
function love.update(dt)
  Game:update(dt)
end
 
function love.draw()
  
  Game:draw()
  
  -- debug information
  local mouseX, mouseY = love.mouse.getX(), love.mouse.getY()
  local camX, camY = camera._x, camera._y
  local x, y = math.floor(p.x), math.floor(p.y)
  local tileX = math.floor(p.x / 16)
  local tileY = math.floor(p.y / 16)
  local mouseTileX = math.floor( (mouseX + camX) / 16)
  local mouseTileY = math.floor( (mouseY + camY) / 16)
  local cursorInReach = p:withinReach(mouseX + camX, mouseY + camY)
  
  love.graphics.setColor(255,255,255)
  love.graphics.print("player coordinates: ("..x..","..y..") | Current tile: ("..tileX..","..tileY..") | Current state: "..p.state, 5, 5)
  love.graphics.print("Mouse coordinates: ("..love.mouse.getX()..","..love.mouse.getY()..") | Mouse tile: ("..mouseTileX..","..mouseTileY..")", 5, 20)
  love.graphics.print("Camera coordinates: ("..camX..","..camY..")",5,35)
  love.graphics.print("p.xSpeed: "..p.xSpeed..", p.ySpeed: "..p.ySpeed,5,50)
  love.graphics.print("FPS: "..love.timer.getFPS(),5,65)
  if p.isFlymode and p.noclip then love.graphics.print("Fly mode | Noclip",5,80) end
  if p.isFlymode then love.graphics.print("Fly mode",5,80) end
  if cursorInReach then
    love.graphics.print("Cursor in reach",5, 95)
  elseif not cursurInReach then
    love.graphics.print("Cursor not in reach",5,95)
  end
  if love.mouse.isDown("l") then
    love.graphics.print("Left mouse down",5, 110)
  elseif not love.mouse.isDown("l") then
    love.graphics.print("Left mouse not down",5, 110)
  end
  if hangTime ~= nil then
  	love.graphics.print("hangTime: "..hangTime,5,125)
  end
  if animFrame ~= nil then
  	love.graphics.print("animFrame = "..animFrame,5,140)
  end
  --                                     [kinetic energy, absorbtion is already shipped w/ HP]
  love.graphics.print("Fall damage = "..math.floor( 0.5*p.mass*(p.ySpeed/60/16)^2) , 200, 110)
  --love.graphics.print("Holding block = ",5, 125)
  --love.graphics.drawq(map.tilesetImg, map.tileset[holdingBlock],115, 125)
end

function love.keypressed(key)
	Game:keypressed(key)
end

function love.keyreleased(key)
  if key == "escape" then
      --gamemenu:appear or so?
  end
  if key == "d" or key == "a" then
      p:stop()
  end
  if key == " " or key == "w" then
      --p.hasJumped = false
      if p.isFlymode then
        p:stop()
      end
  end
  if ( key == "lshift" or key == "s" ) and p.isFlymode then
    p:stop()
  end
end
 
function math.clamp(x, min, max)
  return x < min and min or (x > max and max or x)
end