local Play = GS.new()

require 'src.obj.hero'
require 'src.obj.level'

local maps = require 'src.maps'
local level

function Play:enter(prev)
  level = Level(maps[1])
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
