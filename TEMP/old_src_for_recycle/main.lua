function runfile(filename)
  local ok, filechunk, result
  ok, filechunk = pcall(love.filesystem.load, filename)
  if not ok then
    print( tostring(filechunk) )
  else
    ok, result = pcall(filechunk)
    if not ok then
      print( tostring(chunk) )
    else
      print(result)
    end
  end
end

function love.load()
  love.graphics.clear()
  
  love.graphics.print("Loading",20,20)
  love.graphics.present()
  
  require "class"
  require "variables"
  require "loadblocks"
  
  --require "loadworld"
  --equire "rendermap"
  
  require "game"
  game_load()
end

function love.update(dt)
  game_update(dt)
end

function love.draw()
  --love.graphics.draw(gameField,0,0)
  game_draw()
  
  
  love.graphics.print("Löve2D Sidescroller",0,0)
  love.graphics.print(gameversion,0,16)
  
  love.timer.sleep(1/20) --ingame tick
end