local Play = GS.new()

require 'src.obj.hero'
require 'src.obj.level'
require 'src.obj.boss'

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

function Play:enter(prev)
  level = Level(maps[2], Bag{ Boss:new(20, 100, { left = 'left', right = 'right', jump = ' ', attack = 'a', throw = 's' }), Ranger:new(160, 100), Knight:new(160, 200) } )
  --level = Level(maps[2], Bag{ Boss:new(20, 100, { left = 'left', right = 'right', jump = ' ', attack = 'a', throw = 's' }), Ranger:new(160, 100) })
  --level = Level(maps[3], Bag{ Boss:new(20, 200, { left = 'left', right = 'right', jump = ' ', attack = 'a', throw = 's' }), Knight:new(160, 200) })
  --level = Level(maps[3], Bag{ Boss:new(20, 200, { left = 'left', right = 'right', jump = ' ', attack = 'a', throw = 's' }) })
  love.graphics.setBackgroundColor(175, 238, 238)

  HC:setCallbacks(callback)
end

function Play:update(dt)
  level:update(dt)
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
