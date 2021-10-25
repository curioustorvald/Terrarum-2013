worldEdit = {}

function worldEdit:new() 
  local object = {
    map = {},
    asdf = nil
  }
  setmetatable(object, { __index = worldEdit })
  return object
end

function worldEdit:loadWorld(name)
  
end

function worldEdit:placeBlock(x, y, layer, block)
  local WElayer = map.tl[WElayer]
  
  WElayer.tileData:set(x, y, block)
end

function worldEdit:getTile(x,y,layer)
  local map = self.map
  local WElayer = map.tl[layer]
  
  return WElayer.tileData(x,y)
end