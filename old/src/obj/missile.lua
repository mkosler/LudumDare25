local Missile = class('Missile')
function Missile:initialize(x, y, dmg, img, vel)
  self.image = img
  self.velocity = vel
  self.box = HC:addRectangle(x, y, img:getWidth(), img:getHeight())
  HC:addToGroup('level', self.box)
  self.box.name = 'Missile'
  self.box.flags = {
    attack = dmg,
    remove = false
  }
end

function Missile:draw()
  local x, y = self.box:bbox()
  love.graphics.draw(self.image, x, y)
end

function Missile:isDead()
  return self.box.flags.remove
end

function Missile:__tostring()
  local t, l = self.box:bbox()
  return string.format('(%d, %d), %d | %s', t, l, self.box.flags.attack, tostring(self.box.flags.remove))
end

local arrowImage    = love.graphics.newImage('assets/arrow.png')
local fireballImage = love.graphics.newImage('assets/fireball.png')

Arrow = class('Arrow', Missile)
function Arrow:initialize(x, y, dmg, vel)
  Missile.initialize(self, x, y, dmg, arrowImage, vel)
end

local GRAVITY = 0.1

function Arrow:update(dt)
  local l, t, r, b = self.box:bbox()

  self.velocity.y = self.velocity.y + GRAVITY
  self.box:move(self.velocity.x * dt, self.velocity.y * dt)

  if l < 0 or r > love.graphics.getWidth() or t < 0 or b > love.graphics.getHeight() then
    self.box.flags.remove = true
  end
end

Fireball = class('Fireball', Missile)
function Fireball:initialize(x, y, dmg, vel)
  Missile.initialize(self, x, y, dmg, fireballImage, vel)
end

function Fireball:update(dt)
  self.box:move(self.velocity.x * dt, self.velocity.y * dt)
end
