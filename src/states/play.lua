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

local level
local iterator = 1

function Play:enter(prev)
  love.graphics.setBackgroundColor(49, 79, 79)

  level = Level:new(maps[iterator], 'scripts/tut' .. iterator .. '.txt')

  HC:setCallbacks(callback)
end

local function switchLevel(i)
  level:cleanUp()
  if iterator < 5 then
    level = Level:new(maps[iterator], 'scripts/tut' .. iterator .. '.txt')
  else
    level = Level:new(maps[iterator])
  end
  return i
end

function Play:update(dt)
  level:update(dt)
  if level:finished() then iterator = switchLevel(iterator + 1) end
  HC:update(dt)
end

function Play:draw()
  love.graphics.setColor(255, 255, 255)
  level:draw()
end

function Play:keypressed(key, code)
  if key == 'r' then iterator = switchLevel(iterator) end
  level:keypressed(key, code)
end

function Play:keyreleased(key, code)
  level:keyreleased(key, code)
end

return Play
