--Map loader--
Loader = {}
-- A cache to store tileset images so we don't load them multiple times. Filepaths are keys.
local cache = setmetatable({}, {__mode = "v"})
-- This stores cached images' original dimensions. Images are weak keys.
local cache_imagesize = setmetatable({}, {__mode="k"})

-- Get the classes
require "src/MapLoader/Map"

function Loader.load(filename)
  local file = love.filesystem.read(filename)
  
  if file:byte(1) == 84 and file:byte(2) == 68 then
    -- read header
    local nLayer = file:byte(3) + file:byte(4)*256
    local mapDataSize = file:byte(5) + file:byte(6)*256 + file:byte(7)*65536 + file:byte(8)*16777216 -- Size of single layer
    local width = file:byte(9) + file:byte(10)*256
    local height = mapDataSize / width
    local offset = file:byte(11) + file:byte(12)*256
    print("Offset: "..offset)
    local spawnX = file:byte(13) + file:byte(14)*256
    local spawnY = file:byte(15) + file:byte(16)*256
    local originalSpawnX = file:byte(17) + file:byte(18)*256
    local originalSpawnY = file:byte(19) + file:byte(20)*256
    local mapName = ""
    for i = 21,offset do
      mapName = mapName .. string.char( file:byte(i) )
      i=i+1
    end
    -- get terrainLayer
    local tLayerTerrain = {}
    for i = 0,height-1 do
      tLayerTerrain[i] = {}
      for j = 0,width-1 do
        tLayerTerrain[i][j] = file:byte(offset+5 + (i)*width + j)
        j=j+1
      end
      i=i+1
    end
    -- get wallLayer
    local tLayerWall = {}
    for i = 0,height-1 do
      tLayerWall[i] = {}
      for j = 0,width-1 do
        tLayerWall[i][j] = file:byte(offset+9+mapDataSize + (i)*width + j)
        j=j+1
      end
      i=i+1
    end
    --create new map
    map = Map:new()
    --create new map table
    map.layer.Terrain = {}
    map.layer.Terrain = tLayerTerrain
    map.layer.Wall = {}
    map.layer.Wall = tLayerWall
    map.nLayer = nLayer
    map.width = width
    map.height = height
    map.spawnX = spawnX
    map.spawnY = spawnY
    map.originalSpawnX = originalSpawnX
    map.originalSpawnY = originalSpawnY
    map.name = mapName
    map.tilesetImg, map.tileset = Loader.loadTileset()
    --return map
    return map
  else
    assert("Wrong map file damnit")
  end  
end

function Loader.loadTileset()
  local tileset = {}
  --quads
  local tilesetImg = love.graphics.newImage("res/graphics/terrain/terrain.png")
  for i=0,15 do
    for j=0,15 do
      tileset[(i)*16 + j] = love.graphics.newQuad((j)*16, (i)*16, 16, 16, 256, 256)
    end
  end
  return tilesetImg, tileset
end