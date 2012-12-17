local bossImage = love.graphics.newImage('assets/boss.png')

Boss = class('Boss')
function Boss:initialize(x, y, keys)
  self.image = bossImage
  self.box = HC:addRectangle(x, y, self.image:getWidth(), self.image:getHeight())
  self.box.name = 'Boss'
  HC:addToGroup('redirect', self.box)
  self.velocity = { x = 0, y = 0 }
  self.maxVelocity = { x = 5, y = 7 }
  self.box.flags = {
    damage = 0,
  }
  self.keys = keys
  self.flags = {
    left = false,
    right = false,
    jump = false,
    attack = false,
    pickup = false
  }
  self.hp = {
    max = 100,
    current = 100
  }
  self.prevY = 0
  self.prevVelY = 0
end

local GRAVITY = 0.25
local FRICTION = 0.5

function Boss:update(dt)
  local l, t, r, b = self.box:bbox()

  if t == self.prevY then self.velocity.y = 0 end

  if self.flags.left then
    self.velocity.x = math.max(self.velocity.x - 1.0, -self.maxVelocity.x)
  elseif self.flags.right then
    self.velocity.x = math.min(self.velocity.x + 1.0, self.maxVelocity.x)
  end

  if self.velocity.x > 0 then
    self.velocity.x = self.velocity.x - FRICTION
  elseif self.velocity.x < 0 then
    self.velocity.x = self.velocity.x + FRICTION
  end

  if self.flags.jump and self.velocity.y == 0 and self.prevVelY == 0 then
    self.flags.jump = false
    self.velocity.y = -self.maxVelocity.y
  end

  self.prevVelY = self.velocity.y

  self.velocity.y = self.velocity.y + GRAVITY

  self.box:move(self.velocity.x, self.velocity.y)

  if self.box.flags.damage > 0 then
    self.hp.current = self.hp.current - self.box.flags.damage
    self.box.flags.damage = 0
  end

  if self.flags.pickup and self.body ~= nil then
    self.body.velocity.y = -self.body.maxVelocity.y
    self.body = nil
  end

  self.prevY = t
end

function Boss:draw()
  local l, t, r, b = self.box:bbox()
  love.graphics.draw(self.image, l, t)

  love.graphics.setColor(255,   0,   0)
  love.graphics.rectangle('fill', l, t - 10, (r - l) * (self.hp.current / self.hp.max), 3)
  love.graphics.setColor(255, 255, 255)
end

function Boss:grab(o)
  self.body = o
end

function Boss:keypressed(key, code)
  for k,v in pairs(self.keys) do
    if key == v then
      self.flags[k] = true
    end
  end
end

function Boss:keyreleased(key, code)
  for k,v in pairs(self.keys) do
    if key == v then
      self.flags[k] = false
    end
  end
end
