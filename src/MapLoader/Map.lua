Map = {}
Map.__index = Map

function Map:new()
  local map = {}
    map.layer = {} --layer.layername = {data}, data stores CODE of block
    map.nLayer = 0
    map.width = 0
    map.height = 0
    map.spawnX = 0
    map.spawnY = 0
    map.originalSpawnX = 0
    map.originalSpawnY = 0
    map.name = ""
    map.layer = {} --layer.layername = {data}, data stores CODE of block
    map.tileSetImage = {}
    map.tileset = {} --stores like: tileset[2] = image QUAD of stone  
    map.drawList = {} --also stores like: drawList.layername = {data}
  setmetatable(map, Map)
  return map
end

function Map:draw(update,forceRedraw)
  --update drawList if needed
  --[[Should be global:
  local w = love.graphics.getWidth()
  local h = love.graphics.getHeight()
  local tilesW = math.ceil( (w-30)/16 )
  tilesH = math.ceil( h / 16 )
  camX, camY
  ]]
  local camX, camY = camera._x, camera._y
  if update then
    self.drawList.Wall = {}
    for i=0,tilesH-1 do
      self.drawList.Wall[i] = {}
      for j=0,tilesW-1 do
        self.drawList.Wall[i][j] = self.layer.Wall[math.floor(camY/16) +i][math.floor(camX/16) +j]
        j=j+1
      end
      i=i+1
    end
    
    self.drawList.Terrain = {}
    for i=0,tilesH-1 do
      self.drawList.Terrain[i] = {}
      for j=0,tilesW-1 do
        self.drawList.Terrain[i][j] = self.layer.Terrain[math.floor(camY/16) +i][math.floor(camX/16) +j]
        j=j+1
      end
      i=i+1
    end
  end
  --draw map
  for i=0,tilesH-1 do
    for j=0,tilesW-1 do
      if self.drawList.Wall[i][j] > 0 then
        love.graphics.drawq(self.tilesetImg, self.tileset[ self.drawList.Wall[i][j] ], (j)*16+camX + (-1*(camX%16)) ,(i)*16+camY + (-1*(camY%16)) )
      end
      if self.drawList.Terrain[i][j] > 0 then
        love.graphics.drawq(self.tilesetImg, self.tileset[ self.drawList.Terrain[i][j] ], (j)*16+camX + (-1*(camX%16)) ,(i)*16+camY + (-1*(camY%16)) )
      end
      j=j+1
    end
    i=i+1
  end
  --force redraw
  if forceRedraw then
  	camera:set()
  	love.graphics.present()
  	camera:unset()
  end
end