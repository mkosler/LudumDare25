local Play = GS.new()

require 'src.obj.hero'
require 'src.obj.level'

local maps = require 'src.maps'
local level

function Play:enter(prev)
  local ranger = Ranger:new(200, 100)
  print(ranger.x, ranger.hp)
  level = Level(maps[1], Bag{Ranger:new(100, 100), Knight:new(100, 130), Berzerker:new(100, 150), Mage:new(100, 170)})
  love.graphics.setBackgroundColor(175, 238, 238)
end

function Play:update(dt)
  level:update(dt)
end

function Play:draw()
  level:draw()
end

function Play:keypressed(key, code)
end

function Play:keyreleased(key, code)
end

function Play:mousepressed(x, y, button)
end

function Play:mousereleased(x, y, button)
end

return Play
