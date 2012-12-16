local Missile = Class('Missile')
function Missile:initialize(x, y, dmg, img)
  self.x = x
  self.y = y
  self.damage = dmg
  self.image = img
end

function Missile:draw()
  love.graphics.draw(self.image, self.x, self.y)
end

local arrowImage    = love.graphics.newImage('assets/arrow.png')
local fireballImage = love.graphics.newImage('assets/fireball.png')

Arrow = Class('Arrow', Missile)
function Arrow:initialize(x, y, dmg, speed, angle)
  Arrow.initialize(self, x, y, dmg, arrowImage)
  angle = angle * math.pi / 180.0
  self.velocity = { x = speed * math.cos(angle), y = speed * math.sin(angle) }
end

local GRAVITY = 0.1

function Arrow:update(dt)
  self.velocity.y = self.velocity.y - GRAVITY
  self.x = self.x + (self.velocity.x * dt)
  self.y = self.y + (self.velocity.y * dt)
end

Fireball = Class('Fireball', Missile)
function Fireball:initialize(x, y, dmg, speed, angle)
  Missile.construct(self, x, y, dmg, fireballImage)
  angle = angle * math.pi / 180.0
  self.velocity = { x = speed * math.cos(angle), y = speed * math.sin(angle) }
end

function Fireball:update(dt)
  self.x = self.x + (self.velocity.x * dt)
  self.y = self.y + (self.velocity.y * dt)
end
