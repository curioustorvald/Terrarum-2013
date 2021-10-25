tileProperties = {}

function tileProperties:new()
  local object = {
    properties = {}
  }
  setmetatable(object, { __index = tileProperties})
end

function tileProperties:loadDB()
  local t = {}
  local JSON = require("src/external/json")
  local file = love.filesystem.read("res/properties/terrain.json")
  
  t = JSON:decode(file)
  
  self.properties = t
  print("Tile properties successfully loaded.")
end

--Move it to player.lua
function tileProperties:isSolid(tileX,tileY,layer)
  if layer == nil then layer = "Terrain" end
  local tile = map.layer[layer][tileX][tileY]
  
  --properties[blockID+1][propertiesIndex].xarg.value
  if self.properties[tile+1][9].xarg.value == "true" then
    return true
  else
    return false
  end
end


function tileProperties:get(blockID,sProperties,layer)
  --convert sProperties to properties index
  local tProperties = {background=1,drop=2,fluid=3,fluidDensity=4,luminance=5,name=6,physics=7,resistance=8,solid=9,tool=10,toolTier=11,transparent=12}
  local properties = tProperties[sProperties]
  
  if layer == nil then layer = "Terrain" end
  local tile = map.layer[layer][tileX][tileY]
  
  return self.properties[tile+1][properties]
end