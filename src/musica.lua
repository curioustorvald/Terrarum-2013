--[[HEADER AND TICK DATA READING
00 01 02 03|04 05 06 07|08 09 0A 0B|0C 0D 0E~Offset-1
M  U  S  I  C  A Offset Length in T Tempo Song title
Offset -> a,
a a+1 a+2 a+3|a+4 a+5 ...
1st tick  2nd tick    ...

Since each tick takes up 3 bytes, range is 2 octave.
Format is Big endian.
a   a+1  a+2
0-7 8-15 16-23]]

musica = {}

function musica:new()
  local object = {true
  }
  setmetatable(object, { __index = musica })
  return object
end

function musica:_readTape(filename)
  local tape, size = love.filesystem.read(filename)
  
  --read header
  if tape:byte(1) == 77 and tape:byte(2) == 85 and tape:byte(3) == 83 and tape:byte(4) == 73 and tape:byte(5) == 67 and tape:byte(6) == 65 then -- header starts with MUSICA
    local ticks = {}
    local startByte = tape:byte(7) + tape:byte(8)*256
    local length = tape:byte(9) + tape:byte(10)*256 + tape:byte(11)*65536 + tape:byte(12)*16777216
    local tempo = tape:byte(13) + tape:byte(14)*256
    local title = ""
    for i=15,startByte do
      title = title .. string.char( tape:byte(i) )
      i=i+1
    end
    --return array of tape hole in bin
    local cursor = startByte + 1
    for i=1, (size - startByte)/3 do
      ticks[i] = tape:byte(cursor) + tape:byte(cursor + 1)*256 + tape:byte(cursor + 2)*65536
      cursor = cursor + 3
      i=i+1
    end
    
    print("startByte: "..startByte)
    print("Title: "..title)
    print("Tempo: "..tempo)
    print("Length: "..#ticks)
    
    return title, tempo, ticks
  else
    return false
  end
end

function musica:play(filename)
  --src1:setPitch( 2^(p/12) ), p=integer pitch, can be negative, 12 = F#4 (maximum pitch)
  local src = {}
  local title, tempo, data = self:_readTape(filename)
  
  for i=1,1 do--#data do
    src = {} --reset table
    local holes = tostring( Dec2Bin( tostring(data[i]) , 24) ) --convert decimal to binary
    print(holes..", "..type(holes) )
    --decode holes
    for j=1,24 do
      if string.byte(holes,i) == 49 then
        table.insert( src, love.audio.newSource("res/sounds/musicbox.ogg","static") )
        print("Inserted source audio to index "..#src)
        src[#src]:setPitch( 2^(((24-j)-12)/12) )
      end
    end
    --play sound
    if #src > 0 then --if not rest then
      for j=1,#src do
        print("Emit")
        love.audio.play(src[j])
        j=j+1
      end
    else
      print("Rest")
      love.timer.sleep( 0.5 )
    end
    
    i=i+1
  end
end