local Play = GS.new()

require 'src.obj.hero'
require 'src.obj.level'
require 'src.obj.boss'
require 'src.obj.dead'

local maps = require 'src.maps'
local level

function Play:enter(prev)
  level = Level(maps[2], 
    Bag(Boss:new(
      20, 
      100, 
      { 
        left = 'left', 
        right = 'right', 
        jump = ' ', 
        attack = 'a',
        pickup = 's'
      }), 
      {Ranger:new(160, 100)},
      {Dead:new(160, 200)}))
  love.graphics.setBackgroundColor(175, 238, 238)
end

function Play:update(dt)
  level:update(dt)
end

function Play:draw()
  love.graphics.setColor(255, 255, 255)
  level:draw()
end

function Play:keypressed(key, code)
  level:keypressed(key, code)
end

function Play:keyreleased(key, code)
  level:keyreleased(key, code)
end

return Play
