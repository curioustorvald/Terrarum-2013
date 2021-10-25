Item = {}
Item.__index = Item

--load Item image (quads)
function Item:loadTileset()
	local tileset = {}
	local tilesetImg = love.graphics.newImage("res/graphics/items/items.png")
	--must rearrange items by its item code
	for i=0,15 do
    for j=0,15 do
      tileset[(i)*16 + j] = love.graphics.newQuad((j)*16, (i)*16, 16, 16, 256, 256)
    end
  end
  return tilesetImg, tileset
end

-- make object 'item' to use
function Item:newObject(dataValue, quantity, damage, newName, newTooltip, filePath)
  if damage == nil then damage = 0 end
  if quantity == nil then quantity = 1 end
  
  if dataValue < 256 then
    local prop = tileProperties[dataValue]
  else
    local prop = itemProperties[dataValue]
  end
  local t = {}
  t["properties"] = prop
  t["id"] = dataValue
  t["quantity"] = quantity
  t["damage"] = damage
  t["newName"] = newName
  t["newTooltip"] = newTooltip
  t["linkedFilePath"] = filePath
  return t
end