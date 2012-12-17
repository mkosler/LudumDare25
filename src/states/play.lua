local Play = GS.new()

require 'src.obj.hero'
require 'src.obj.level'
require 'src.obj.boss'
require 'src.obj.bag'

local maps = require 'src.maps'
local level

local function callback(dt, v1, v2, dx, dy)
  -- Check Hero
  for _,v in pairs{ Ranger, Berzerker, Knight, Dead } do
    if instanceOf(v, v1.parent) then
      v1.parent:callback(dt, v2.parent, dx, dy)
    elseif instanceOf(v, v2.parent) then
      v2.parent:callback(dt, v1.parent, dx, dy)
    end
  end

  -- Check Boss
  if instanceOf(Boss, v1.parent) then
    v1.parent:callback(dt, v2.parent, dx, dy)
  elseif instanceOf(Boss, v2.parent) then
    v2.parent:callback(dt, v1.parent, dx, dy)
  end
end

local levels = {}
local level
local iterator = 1

function Play:enter(prev)
  table.insert(levels, Level:new(maps[3], Bag:new{ Boss:new(20, 300, { left = 'left', right = 'right', jump = ' ', attack = 'a', throw = 's' }), Ranger:new(160, 300) }, 'scripts/tut1.txt'))
  table.insert(levels, Level:new(maps[3], Bag:new{ Boss:new(20, 300, { left = 'left', right = 'right', jump = ' ', attack = 'a', throw = 's' }), Berzerker:new(160, 300) }, 'scripts/tut2.txt'))
  table.insert(levels, Level:new(maps[3], Bag:new{ Boss:new(20, 300, { left = 'left', right = 'right', jump = ' ', attack = 'a', throw = 's' }), Knight:new(160, 300) }, 'scripts/tut3.txt'))
  love.graphics.setBackgroundColor(49, 79, 79)

  level = levels[1]

  HC:setCallbacks(callback)
end

function Play:update(dt)
  level:update(dt)
  if levels[iterator]:finished() then
    level:cleanUp()
    table.remove(levels, 1)
    level = levels[1]
  end
  HC:update(dt)
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
