local iterator = 0

local bossSlashImage = love.graphics.newImage('assets/boss_slash.png')
local throwImage = love.graphics.newImage('assets/throw.png')
local bossImage = love.graphics.newImage('assets/boss.png')
Boss = class('Boss')
function Boss:initialize(x, y, keys)
  self.box = HC:addRectangle(x, y, bossImage:getWidth(), bossImage:getHeight())
  HC:addToGroup('boss', self.box)
  HC:addToGroup('redirect', self.box)
  self.box.parent = self
  self.name = 'Boss ' .. iterator
  iterator = iterator + 1
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
  self.facing = 'left'
  self.timer = {
    count = 0,
    delay = 0.1
  }
end

function Boss:getFacing()
  return self.facing
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
      self.inHand.flags.angle = self.angle
      self.inHand = nil
    end
  else
    if self.flags.left then
      self.facing = 'left'
      self.velocity.x = math.max(self.velocity.x - 1.0, -self.velocity.maxX)
    elseif self.flags.right then
      self.facing = 'right'
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

  self.timer.count = self.timer.count + dt
  if self.flags.attack and self.timer.count >= self.timer.delay then
    print('Attack!!!')
    self.timer.count = 0
    if self.facing == 'left' then
      return Slash:new(10, self, true, bossSlashImage)
    elseif self.facing == 'right' then
      return Slash:new(10, self, true, bossSlashImage)
    end
  else
    return nil
  end
end

function Boss:draw()
  local l, t, r, b = self.box:bbox()
  if self.facing == 'left' then
    love.graphics.draw(self.image, l, t, 0, -1, 1, self.image:getWidth())
  elseif self.facing == 'right' then
    love.graphics.draw(self.image, l, t)
  end

  love.graphics.setColor(255,   0,   0)
  love.graphics.rectangle('fill', l, t - 10, (r - l) * (self.hp.current / self.hp.max), 3)
  love.graphics.setColor(255, 255, 255)

  if self.flags.throw and self.inHand ~= nil then
    local cX, cY = self.box:center()
    local rad = self.angle * math.pi / 180.0
    print(cX, cY, throwImage:getWidth())
    love.graphics.draw(throwImage, cX, cY, rad, 1, 1, throwImage:getWidth() / 2, 0)
  end

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

function Boss:callback(dt, o, dx, dy)
  if instanceOf(CollisionBlock, o) or instanceOf(WallBlock, o) then
    self.box:move(dx, dy)
  elseif instanceOf(FloatingBlock, o) then
    if self.velocity.y > 0 then
      self.box:move(0, dy)
    end
  elseif instanceOf(Dead, o) then
    if self.flags.throw then
      self.inHand = o
    else
      self.inHand = nil
    end
  elseif instanceOf(Door, o) then
    if o.openable then
      print('Opening door...', self.name, o.name)
      o.opened = true
    end
  else
    for _,v in pairs{ Arrow, Charge, Slash } do
      if instanceOf(v, o) then
        self.hp.current = self.hp.current - o.damage
        o.removable = true
        if instanceOf(Charge, o) then
          o.parent.timer.count = 0
        end
      end
    end
  end
end

function Boss:cleanUp()
  HC:remove(self.box)
end
