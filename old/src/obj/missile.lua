Missile = class('Missile')
function Missile:initialize(x, y, velocity, damage, img)
  self.box = HC:addRectangle(x, y, img:getWidth(), img:getHeight())
  HC:addToGroup('level', self.box)
  HC:addToGroup('missile', self.box)
  HC:setPassive(self.box)
  self.box.parent = self
  self.name = 'Missile'
  self.image = img
  self.velocity = velocity
  self.damage = damage
  self.removable = false
end

function Missile:draw()
  local l, t = self.box:bbox()
  love.graphics.draw(self.image, l, t)
end

local arrowImage = love.graphics.newImage('assets/arrow.png')
Arrow = class('Arrow', Missile)
function Arrow:initialize(x, y, velocity, damage)
  Missile.initialize(self, x, y, velocity, damage, arrowImage)
end

function Arrow:update(dt)
  if self.removable then return end

  local l, t, r, b = self.box:bbox()
  if l < 0 or r > love.graphics.getWidth() or t < 0 or b > love.graphics.getHeight() then
    self.removable = true
    return
  end

  self.box:move(self.velocity.x * dt, self.velocity.y * dt)
end

local fireballImage = love.graphics.newImage('assets/fireball.png')
Fireball = class('Fireball', Missile)
function Fireball:initialize(x, y, velocity, damage)
  Missile.initialize(self, x, y, velocity, damage, fireballImage)
end
