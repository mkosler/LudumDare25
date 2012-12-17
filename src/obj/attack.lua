Attack = class('Attack')
function Attack:initialize(x, y, damage, boss, img)
  self.box = HC:addRectangle(x, y, img:getWidth(), img:getHeight())
  HC:addToGroup('level', self.box)
  if not boss then HC:addToGroup('hero', self.box) end
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

slashImage = love.graphics.newImage('assets/slash.png')
Slash = class('Slash', Attack)
function Slash:initialize(damage, parent, boss, img)
  local l, t = parent.box:bbox()
  Attack.initialize(self, l, t, damage, boss, img)
  self.parent = parent
  self.timer = {
    count = 0,
    delay = 0.1
  }
end

function Slash:update(dt)
  local l, t, r = self.parent.box:bbox()
  if self.parent.facing == 'left' then
    self.box:moveTo(l - 1, t)
  elseif self.parent.facing == 'right' then
    self.box:moveTo(r + 1, t)
  end

  self.timer.count = self.timer.count + dt
  if self.timer.count < self.timer.delay then return end

  self.removable = true
end

function Slash:draw()
  local pL, pT, pR, pB = self.parent.box:bbox()
  local l, t, r, b = self.box:bbox()
  print(pL, pT, pR, pB, l, t, r, b, self.parent.facing)
  if self.parent.facing == 'left' then
    love.graphics.draw(self.image, l, t, 0, -1, 1)
  elseif self.parent.facing == 'right' then
    love.graphics.draw(self.image, l, t)
  end
end

function Slash:callback(dt, o, dx, dy)
end

Charge = class('Charge', Attack)
function Charge:initialize(damage, parent, img)
  local l, t = parent.box:bbox()
  Attack.initialize(self, l, t, damage, false, img)
  self.parent = parent
end

function Charge:draw()
  print('Inside Charge:draw()...')
  local l, t, r, b = self.parent.box:bbox()
  if self.parent.facing == 'left' then
    love.graphics.draw(self.image, l, t, 0, -1, 1)
  elseif self.parent.facing == 'right' then
    love.graphics.draw(self.image, r, t)
  end
end
