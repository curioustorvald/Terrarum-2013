inventory = {}

function inventory:new()
  local object = {}
  
  object["itemSlot"] = {}
  object["currencySlot"] = {}
  object["armourSlot"] = {}
  object["equipmentSlot"] = {}
  object["ammoSlot"] = {}
  
  setmetatable(object, { __index = inventory })
  return object
end

function inventory:insert(tItemData,sSlot)
  if sSlot == nil then sSlot = "itemSlot" end --set default slot
  local dupItemIndex = self:_isAlreadyExists(tItemData.name, sSlot)
  
  if not dupItemIndex and ( ( sSlot == "itemSlot" and #self[sSlot] < 40 ) or ( ( sSlot == "currencySlot" or sSlot == "armourSlot" ) and #self[sSlot] < 4 ) or ( ( sSlot == "equipmentSlot" or sSlot == "ammoSlot" ) and #self[sSlot] < 6 ) ) then--slot < self.slot and compeletely new item then
    table.insert(self[sSlot], tItemData)
  elseif dupItemIndex then--tItemData is already exist in self.slot then
    self[dupItemIndex]["quantity"] =  self[dupItemIndex]["quantity"] + tItemData.quantity
  end
end

function inventory:_isAlreadyExist(item,sSlot) --itemData? or item index(item name)?
  local itemSlot = self[sSlot]
  for i=1, #self[sSlot] do
    --assuming something like self.itemSlot[3] = { item.name = "something", item.damage = 12, item.quantity = 6, ... }
    if itemSlot[i]["name"] == item then --and itemSlot[i]["quantity"] < 250 then 
      local a = i
      break
    end
    i=i+1
  end
  
  if a ~= nil then
    return a
  else
    return false
  end
end

function inventory:draw()
  
end