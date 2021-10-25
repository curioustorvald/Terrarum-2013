block = {}
blockTile = {}
--block numbers: use Minecraft numbers
imgTerrain = love.graphics.newImage("graphics/terrain.png")
--usage: love.graphics.drawq(imgTerrain, blockTile[n], xpos, ypos)
blockTile[1] = love.graphics.newQuad(16,0,16,16,256,256)
blockTile[2] = love.graphics.newQuad(48,0,16,16,256,256)
blockTile[3] = love.graphics.newQuad(32,0,16,16,256,256)
blockTile[4] = love.graphics.newQuad(0,16,16,16,256,256)

blockTile[5] = love.graphics.newQuad(64,0,16,16,256,256)
blockTile[6] = love.graphics.newQuad(240,0,16,16,256,256)
blockTile[7] = love.graphics.newQuad(16,16,16,16,256,256)
blockTile[8] = love.graphics.newQuad(208,192,16,16,256,256)

blockTile[9] = love.graphics.newQuad(208,192,16,16,256,256) --moving water
blockTile[10] = love.graphics.newQuad(208,224,16,16,256,256)
blockTile[11] = love.graphics.newQuad(208,224,16,16,256,256) --moving lava
blockTile[12] = love.graphics.newQuad(32,16,16,16,256,256)

blockTile[13] = love.graphics.newQuad(48,16,16,16,256,256)
blockTile[14] = love.graphics.newQuad(0,32,16,16,256,256)
blockTile[15] = love.graphics.newQuad(16,32,16,16,256,256)
blockTile[16] = love.graphics.newQuad(32,32,16,16,256,256)

blockTile[17] = love.graphics.newQuad(64,16,16,16,256,256)
blockTile[18] = love.graphics.newQuad(64,48,16,16,256,256)
blockTile[19] = love.graphics.newQuad(0,48,16,16,256,256)
blockTile[20] = love.graphics.newQuad(16,48,16,16,256,256)

blockTile[21] = love.graphics.newQuad(0,160,16,16,256,256)
blockTile[22] = love.graphics.newQuad(0,144,16,16,256,256)
blockTile[23] = love.graphics.newQuad(224,32,16,16,256,256)
blockTile[24] = love.graphics.newQuad(0,192,16,16,256,256) --not chiseled

blockTile[25] = love.graphics.newQuad(160,64,16,16,256,256)
blockTile[26] = {} --bed
blockTile[26][1] = love.graphics.newQuad(112,144,16,16,256,256) --bedhead, oriented right
blockTile[26][2] = love.graphics.newQuad(96,144,16,16,256,256) --bedfoot, oriented right
blockTile[26][3] = love.graphics.newQuad(112,144,16,16,256,256) --bedhead, oriented left
blockTile[26][3]:flip(true,false) --flip left-right
blockTile[26][4] = love.graphics.newQuad(96,144,16,16,256,256) --bedfoot, oriented left
blockTile[26][4]:flip(true,false) --flip left-right
blockTile[27] = nil --powered rail
blockTile[28] = nil --detector rail

blockTile[29] = nil --sticky piston
blockTile[30] = love.graphics.newQuad(176,0,16,16,256,256)
blockTile[31] = love.graphics.newQuad(112,32,16,16,256,256)
blockTile[32] = love.graphics.newQuad(112,48,16,16,256,256)

blockTile[33] = nil --piston
blockTile[34] = nil --pistonhead
blockTile[35] = {} --wool
blockTile[35][1] = love.graphics.newQuad(0,64,16,16,256,256)
for i=2,8 do
  blockTile[35][i] = love.graphics.newQuad(32,16*(15-i),16,16,256,256)
end
for i=9,16 do
  blockTile[35][i] = love.graphics.newQuad(16,16*(23-i),16,16,256,256)
end
blockTile[36] = nil --block moved by piston

blockTile[37] = love.graphics.newQuad(208,0,16,16,256,256)
blockTile[38] = love.graphics.newQuad(192,0,16,16,256,256)
blockTile[39] = love.graphics.newQuad(208,16,16,16,256,256)
blockTile[40] = love.graphics.newQuad(192,16,16,16,256,256)

blockTile[41] = love.graphics.newQuad(112,16,16,16,256,256)
blockTile[42] = love.graphics.newQuad(96,16,16,16,256,256)
blockTile[43] = love.graphics.newQuad(80,0,16,16,256,256)
blockTile[44] = love.graphics.newQuad(80,0,16,8,256,256)

blockTile[45] = love.graphics.newQuad(112,0,16,16,256,256)
blockTile[46] = love.graphics.newQuad(128,0,16,16,256,256)
blockTile[47] = love.graphics.newQuad(48,32,16,16,256,256)
blockTile[48] = love.graphics.newQuad(64,32,16,16,256,256)

blockTile[49] = love.graphics.newQuad(80,32,16,16,256,256)
blockTile[50] = {} --torch
blockTile[50][1] = love.graphics.newQuad(0,80,16,16,256,256) --laid on block
blockTile[51] = {} --fire animation here
blockTile[52] = love.graphics.newQuad(16,64,16,16,256,256)

blockTile[53] = {} --stair side tex
blockTile[54] = {} --chest
blockTile[55] = nil --redstone wire
blockTile[56] = love.graphics.newQuad(32,48,16,16,256,256)

blockTile[57] = love.graphics.newQuad(128,16,16,16,256,256)
blockTile[58] = love.graphics.newQuad(176,48,16,16,256,256)
blockTile[59] = {} --wheat
for i=1,8 do
  blockTile[59][i] = love.graphics.newQuad(16*(7+i),80,16,16,256,256)
end
blockTile[60] = love.graphics.newQuad(32,1,16,15,256,256)

blockTile[254] = love.graphics.newQuad(96,32,16,16,256,256) --player spawn tile
blockTile[255] = love.graphics.newQuad(96,32,16,16,256,256) --air

for i=1,1 do--#blockTile do
  if blockTile[i] ~= nil and i < 10 then
    require("blocks/b00" .. i)
  elseif blockTile[i] ~= nil and i >= 10 and i < 100 then
    require("blocks/b0" .. i)
  elseif blockTile[i] ~= nil and i >= 100 then
    require("blocks/b" .. i)
  end
  i=i+1
end
