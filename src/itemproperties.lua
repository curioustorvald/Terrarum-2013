itemProperties = {}

function itemProperties:new()
  local object = {
    properties = {}
  }
  setmetatable(object, { __index = itemProperties})
end

function itemProperties:loadXML()
  local t = {}
  local JSON = require("src/external/json")
  local file = love.filesystem.read("res/properties/item.xml")
  
  t = JSON:decode(file)
  
  self.properties = t
  print("Item properties successfully loaded.")
end
