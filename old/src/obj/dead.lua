local deadImage = love.graphics.newImage('assets/dead.png')

Dead = class('Dead')
function Dead:initialize(x, y)
  self.image = deadImage
  self.box = HC:addRectangle(x, y, self.image:getWidth(), self.image:getHeight())
  self.box.name = 'Dead'
  HC:addToGroup('redirect', self.box)
  self.velocity = { x = 0, y = 0 }
  self.maxVelocity = { x = 10, y = 10 }
  self.prevY = 0
end

local GRAVITY = 0.5
local FRICTION = 0.5

function Dead:__tostring()
  local l, t, r, b = self.box:bbox()
  return string.format('(%d, %d)', l, t)
end

function Dead:update(dt)
  local l, t, r, b = self.box:bbox()

  if t == self.prevY then self.velocity.y = 0 end

  if self.velocity.x > 0 then
    self.velocity.x = self.velocity.x - FRICTION
  elseif self.velocity.x < 0 then
    self.velocity.x = self.velocity.x + FRICTION
  end

  self.prevVelY = self.velocity.y

  self.velocity.y = self.velocity.y + GRAVITY

  self.box:move(self.velocity.x, self.velocity.y)

  self.prevY = t
end

function Dead:draw()
  local l, t = self.box:bbox()
  love.graphics.draw(self.image, l, t)
end
