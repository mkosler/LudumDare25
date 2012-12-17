local throwImage = love.graphics.newImage('assets/throw.png')
local bossImage = love.graphics.newImage('assets/boss.png')
Boss = class('Boss')
function Boss:initialize(x, y, keys)
  self.box = HC:addRectangle(x, y, bossImage:getWidth(), bossImage:getHeight())
  HC:addToGroup('redirect', self.box)
  self.box.parent = self
  self.name = 'Boss'
  self.image = bossImage
  self.velocity = {
    x = 0,
    y = 0,
    maxX = 5,
    maxY = 3.75
  }
  self.keys = keys
  self.flags = {
    left = false,
    right = false,
    jump = false,
    attack = false,
    throw = false
  }
  self.hp = {
    current = 100,
    max = 100
  }
  self.inHand = nil
  self.angle = 0
  self.previous = {
    x = 0,
    y = 0,
    velocity = { x = 0, y = 0 },
    throw = false
  }
end

function Boss:respond(dt)
  if self.inHand ~= nil then
    if self.flags.throw then
      if self.flags.left then
        -- Counter-clockwise
        self.angle = (self.angle - 5) % 360
        print('Angle:', self.angle)
      elseif self.flags.right then
        -- Clockwise
        self.angle = (self.angle + 5) % 360
        print('Angle:', self.angle)
      end
    else
      -- Throwing
      print('Throwing!')
      self.inHand.flags.thrown = true
    end
  else
    if self.flags.left then
      self.velocity.x = math.max(self.velocity.x - 1.0, -self.velocity.maxX)
    elseif self.flags.right then
      self.velocity.x = math.min(self.velocity.x + 1.0, self.velocity.maxX)
    end
  end

  if self.velocity.x > 0 then
    self.velocity.x = self.velocity.x - FRICTION
  elseif self.velocity.x < 0 then
    self.velocity.x = self.velocity.x + FRICTION
  end

  if self.flags.jump and self.velocity.y == 0 and self.previous.velocity.y == 0 then
    self.flags.jump = false
    self.velocity.y = -self.velocity.maxY
  end
end

function Boss:update(dt)
  local l, t, r, b = self.box:bbox()
  if t == self.previous.y then self.velocity.y = 0 end

  self:respond(dt)

  self.previous.velocity.y = self.velocity.y

  self.velocity.y = self.velocity.y + (GRAVITY * dt)
  self.box:move(self.velocity.x, self.velocity.y)

  self.previous.y = t
end

function Boss:draw()
  local l, t, r, b = self.box:bbox()
  love.graphics.draw(self.image, l, t)

  if self.flags.throw and self.inHand ~= nil then
    local cX, cY = self.box:center()
    local rad = self.angle * math.pi / 180.0
    print(cX, cY, throwImage:getWidth())
    love.graphics.draw(throwImage, cX, cY, rad, 1, 1, throwImage:getWidth() / 2, 0)
  end

  love.graphics.setColor(255,   0,   0)
  love.graphics.rectangle('fill', l, t - 10, (r - l) * (self.hp.current / self.hp.max), 3)
  love.graphics.setColor(255, 255, 255)
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

function Boss:__tostring()
  local l, t = self.box:bbox()
  return string.format('Boss: (%d, %d)', l, t)
end
