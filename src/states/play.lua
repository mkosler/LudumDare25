local Play = GS.new()

require 'src.obj.hero'
require 'src.obj.level'
require 'src.obj.boss'

local maps = require 'src.maps'
local level

local function callback(dt, v1, v2, dx, dy)
  --print(v1.parent.name, v2.parent.name)
  if instanceOf(RedirectBlock, v2.parent) then
    if dy == 0 then
      v1:move(dx, dy)
      v1.parent.velocity.x = -v1.parent.velocity.x
    end
  elseif instanceOf(CollisionBlock, v2.parent) then
    v1:move(dx, dy)
  end

  if instanceOf(Boss, v1.parent) then
    if instanceOf(Missile, v2.parent) then
      print('HIT!', v1:center(), v2:center())
      v1.parent.hp.current = v1.parent.hp.current - v2.parent.damage
      v2.parent.removable = true
    end
  end

  if instanceOf(Dead, v1.parent) and instanceOf(Boss, v2.parent) then
    if v2.parent.flags.throw then
      v2.parent.inHand = v1.parent
    else
      v2.parent.inHand = nil
    end
  elseif instanceOf(Boss, v1.parent) and instanceOf(Dead, v2.parent) then
    if v1.parent.flags.throw then
      v1.parent.inHand = v2.parent
    else
      v1.parent.inHand = nil
    end
  end
end

function Play:enter(prev)
  level = Level(maps[2], Bag{ Boss:new(20, 100, { left = 'left', right = 'right', jump = ' ', attack = 'a', throw = 's' }), Ranger:new(160, 100), Dead:new(160, 200) } )
  --level = Level(maps[2], Bag:new{ Boss:new(20, 100, { left = 'left', right = 'right', jump = ' ', attack = 'a', throw = 's' }), Ranger:new(160, 100) })
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
