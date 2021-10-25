--[[function love.draw() 
  love.graphics.draw(canvas,0,0)
end]]

local function dotToBlock(b,g,r)
  colourTable = {}
  --r*65536 + g*256 + b ->0xrrggbb
  colourTable[16777215] = 255 --FF FF FF
  colourTable[3781962] = 2 --39 B5 4A
  colourTable[6306067] = 3 --60 39 13
  colourTable[9013641] = 1 --89 89 89
  colourTable[16711680] = 254 --FF 00 00
  colourTable[15537243] = 45 --ED 14 5B
  colourTable[0] = 7 --00 00 00
  
  return colourTable[r*65536 + g*256 + b]
end

function loadWorldImage(worldname)
  local image, size = love.filesystem.read("maps/"..worldname..".bmp",all)
  
  --If using Photoshop, you must FLIP ROW ORDER when you save.
  if image:byte(1) == 66 and image:byte(2) == 77 then
    local offset = image:byte(11) + image:byte(12)*256 + image:byte(13)*65536 + image:byte(14)*16777216
    print("BMP offset "..offset)
    if image:byte(15) == 40 then --Windows V3
      print("Header type: Windows V3")
      imageW = image:byte(19) + image:byte(20)*256 + image:byte(21)*65536 + image:byte(22)*16777216
      imagesize = image:byte(35) + image:byte(36)*256 + image:byte(37)*65536 + image:byte(38)*16777216 - 2
      imageH = (imagesize/3)/imageW
    elseif image:byte(15) == 12 then --OS/2 V1
      print("Header type: OS/2 V1")
      imageW = image:byte(19) + image:byte(20)*256
      imageH = image:byte(21) + image:byte(22)*256
    else
      error("Unsupported header; Save BMP as Windows V3 header.")
    end
    --reject image larger than 65535*65535
    if imageW > 65535 or imageH > 65535 then
      error("Image too large; Image size must be less than 65536*65536.")
    end
    --convert image into map data
    cursor = offset + 1
    for i=1,imageH do
      world.geometry[i] = {}
      blockBody[i] = {}
      for j=1,imageW do
        --save block ID to table
        world.geometry[i][j] = dotToBlock( image:byte(cursor), image:byte(cursor+1), image:byte(cursor+2) )
        cursor = cursor + 3
        j=j+1
      end
      i=i+1
    end
    --setup variable
    world.w = #world.geometry[#world.geometry]
    world.h = #world.geometry
    
    print("Loaded map image \"maps/"..worldname..".bmp\". Image file size: "..size)
    print("**** World info ****")
    print("Width: "..#world.geometry[#world.geometry])
    print("Height: "..#world.geometry)
  else
    print("File maps/"..worldname..".bmp is not a supported bitmap image file.")
    print("File must start with \"BM\".")
  end
end

function updateWorld(world)
  local drawX, drawY = 0, 0
  for i=math.ceil(( playerPosY - math.ceil(h/2) )/16), math.ceil(( playerPosY + math.ceil(h/2) )/16) do --row
    blockShape[i] = {}
    blockFixture[i] = {}
    drawX = 0
    for j =math.ceil(( playerPosX - math.ceil(w/2) )/16),math.ceil(( playerPosX + math.ceil(w/2) )/16) do --col
      
      if i<1 then i = 1 end
      if j<1 then j = 1 end
      --draw block image
      love.graphics.drawq( imgTerrain, blockTile[ world.geometry[i][j] ], drawX*16, drawY*16 )
      drawX = drawX + 1
    end
    drawY = drawY + 1
  end
      
      
end