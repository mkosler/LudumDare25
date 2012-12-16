local Missile = Class{
  function(self, x, y, dmg, img)
    self.x = x
    self.y = y
    self.damage = dmg
    self.image = img
  end
}

function Missile:draw()
  love.graphics.draw(self.image, self.x, self.y)
end

local arrowImage    = love.graphics.newImage('assets/arrow.png')
local fireballImage = love.graphics.newImage('assets/fireball.png')

local Arrow = Class{
  inherits = Missile,
  function(self, x, y, dmg, speed, angle)
    angle = angle * math.pi / 180.0
    self.velocity = { x = speed * math.cos(angle), y = speed * math.sin(angle) }
    Arrow.construct(self, x, y, dmg, arrowImage)
  end
}

local GRAVITY = 0.1

function Arrow:update(dt)
  self.velocity.y = self.velocity.y - GRAVITY
  self.x = self.x + (self.velocity.x * dt)
  self.y = self.y + (self.velocity.y * dt)
end

local Fireball = Class{
  inherits = Missile,
  function(self, x, y, dmg, speed, angle)
    angle = angle * math.pi / 180.0
    self.velocity = { x = speed * math.cos(angle), y = speed * math.sin(angle) }
    Missile.construct(self, x, y, dmg, fireballImage)
  end
}

function Fireball:update(dt)
  self.x = self.x + (self.velocity.x * dt)
  self.y = self.y + (self.velocity.y * dt)
end
