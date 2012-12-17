Attack = class('Attack')
function Attack:initialize(x, y, damage, boss, img)
  self.box = HC:addRectangle(x, y, img:getWidth(), img:getHeight())
  HC:addToGroup('level', self.box)
  if boss then HC:addToGroup('boss', self.box) else HC:addToGroup('hero', self.box) end
  HC:setPassive(self.box)
  self.box.parent = self
  self.name = 'Attack'
  self.image = img
  self.damage = damage
  self.removable = false
end

function Attack:update(dt)
end

local arrowImage = love.graphics.newImage('assets/arrow.png')
Arrow = class('Arrow', Attack)
function Arrow:initialize(x, y, velocity, damage)
  Attack.initialize(self, x, y, damage, false, arrowImage)
  self.velocity = velocity
  self.angle = math.atan(velocity.y / velocity.x)
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

function Arrow:draw()
  local l, t = self.box:bbox()
  love.graphics.draw(self.image, l, t, self.angle)
end

Slash = class('Slash', Attack)
function Slash:initialize(damage, parent, boss, img)
  local l, t = parent.box:bbox()
  Attack.initialize(self, l, t, damage, boss, img)
  self.name = 'Slash'
  self.parent = parent
  self.timer = {
    count = 0,
    delay = 0.1
  }
end

function Slash:update(dt)
  local l, t, r = self.parent.box:bbox()
  local _,cY = self.parent.box:center()
  if self.parent:getFacing() == 'left' then
    self.box:moveTo(l - (self.image:getWidth() / 2.0) - 1, cY)
  elseif self.parent:getFacing() == 'right' then
    self.box:moveTo(r + (self.image:getWidth() / 2.0) + 1, cY)
  end

  self.timer.count = self.timer.count + dt
  if self.timer.count < self.timer.delay then return end

  print('Natural Slash death')
  self.removable = true
end

function Slash:draw()
  local l, t = self.box:bbox()
  if self.parent:getFacing() == 'left' then
    love.graphics.draw(self.image, l, t, 0, -1, 1, self.image:getWidth())
  elseif self.parent:getFacing() == 'right' then
    love.graphics.draw(self.image, l, t)
  end
end

Charge = class('Charge', Attack)
function Charge:initialize(damage, parent, img)
  local l, t = parent.box:bbox()
  Attack.initialize(self, l, t, damage, false, img)
  self.parent = parent
end

function Charge:update(dt)
  if self.parent.removable then
    print('How am I alive?')
    self.removable = true
    return
  end

  local l, t, r = self.parent.box:bbox()
  local _,cY = self.parent.box:center()
  if self.parent:getFacing() == 'left' then
    self.box:moveTo(l - (self.image:getWidth() / 2.0) - 1, cY)
  elseif self.parent:getFacing() == 'right' then
    self.box:moveTo(r + (self.image:getWidth() / 2.0) + 1, cY)
  end
end

function Charge:draw()
  local l, t = self.box:bbox()
  if self.parent:getFacing() == 'left' then
    love.graphics.draw(self.image, l, t, 0, -1, 1, self.image:getWidth())
  elseif self.parent:getFacing() == 'right' then
    love.graphics.draw(self.image, l, t)
  end
end

Throw = class('Throw', Attack)
function Throw:initialize(damage, parent, img)
  local l, t = parent.box:bbox()
  Attack.initialize(self, l, t, damage, true, img)
  self.name = 'Throw'
  self.parent = parent
  self.previous = { cY = 0 }
end

function Throw:update(dt)
  local cX, cY = self.parent.box:center()
  if cY == self.previous.cY then 
    self.removable = true
    return
  end

  self.box:moveTo(cX, cY)
  self.previous.cY = cY
end

function Throw:draw()
end
