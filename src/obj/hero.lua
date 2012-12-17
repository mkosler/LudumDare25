require 'src.obj.missile'

local Hero = class('Hero')
function Hero:initialize(x, y, hp, armor, img)
  self.box = HC:addRectangle(x, y, img:getWidth(), img:getHeight())
  HC:addToGroup('hero', self.box)
  HC:addToGroup('missile', self.box)
  self.box.parent = self
  self.image = img
  self.name = 'Hero'
  self.hp = { current = hp, max = hp }
  self.armor = armor
  self.velocity = { x = 50, y = 0 }
  self.timer = { count = 0, delay = 3 }
  self.previous = { x = 0, y = 0 }
end

--local function callback(dt, v1, v2, dx, dy)
  --print(v1.parent.name, v2.parent.name)
  --if v2.parent.name == 'RedirectBlock' then
    --if dy == 0 then
      --v1:move(dx, dy)
      --v1.parent.velocity.x = -v1.parent.velocity.x
    --end
  --else
    --v1:move(dx, dy)
  --end
--end

function Hero:attack(dt, boss)
end

function Hero:update(dt, boss)
  --HC:setCallbacks(callback)

  local l, t, r, b = self.box:bbox()
  if t == self.previous.y then
    self.velocity.y = 0
  end

  self.velocity.y = self.velocity.y + GRAVITY
  self.box:move(self.velocity.x * dt, self.velocity.y * dt)

  self.previous.y = t

  return self:attack(dt, boss)
end

function Hero:draw()
  local l, t, r, b = self.box:bbox()
  love.graphics.draw(self.image, l, t)

  love.graphics.setColor(255,   0,   0)
  love.graphics.rectangle('fill', l, t - 10, (r - l) * (self.hp.current / self.hp.max), 3)
  love.graphics.setColor(255, 255, 255)
end

function Hero:__tostring()
  local l, t = self.box:bbox()
  return string.format('Hero: (%d, %d)', l, t)
end

local rangerImage = love.graphics.newImage('assets/archer.png')
Ranger = class('Ranger', Hero)
function Ranger:initialize(x, y)
  Hero.initialize(self, x, y, 75, 0.75, rangerImage)
end

function Ranger:attack(dt, boss)
  self.timer.count = self.timer.count + dt
  if self.timer.count < self.timer.delay then return end

  self.timer.count = 0

  local x1, y1 = self.box:center()
  local x2, y2 = boss.box:center()

  return Arrow:new(x1, y1, { x = x2 - x1, y = y2 - y1 }, 3)
end

local berzekerImage = love.graphics.newImage('assets/berserker.png')
Berzerker = class('Berzerker', Hero)
function Berzerker:initialize(x, y)
  Hero.initialize(self, x, y, 150, 0.85, berzekerImage)
end

function Berzerker:attack(dt, boss)
end

local knightImage = love.graphics.newImage('assets/knight.png')
Knight = class('Knight', Hero)
function Knight:initialize(x, y)
  Hero.initialize(self, x, y, 100, 0.5, knightImage)
end

function Knight:attack(dt, boss)
end

local mageImage = love.graphics.newImage('assets/mage.png')
Mage = class('Mage', Hero)
function Mage:initialize(x, y)
  Hero.initialize(self, x, y, 50, 1.0, mageImage)
end

function Mage:attack(dt, boss)
end

local deadImage = love.graphics.newImage('assets/dead.png')
Dead = class('Dead', Hero)
function Dead:initialize(x, y)
  Hero.initialize(self, x, y, 0, 0, deadImage)
  self.velocity = { x = 0, y = 0 }
  self.name = 'Dead'
  self.flags = {
    thrown = false
  }
end

function Dead:update(dt)
  local l, t, r, b = self.box:bbox()

  if t == self.previous.y then self.velocity.y = 0 end

  if self.velocity.x > 0 then
    self.velocity.x = self.velocity.x - (FRICTION * dt)
  elseif self.velocity.x < 0 then
    self.velocity.x = self.velocity.x + (FRICTION * dt)
  end

  if self.flags.thrown then
    print('Thrown!!!')
    self.flags.thrown = false
    self.velocity.y = -200
  end

  self.velocity.y = self.velocity.y + GRAVITY
  self.box:move(self.velocity.x * dt, self.velocity.y * dt)

  self.previous.y = t

  return nil
end

function Dead:draw()
  local l, t, r, b = self.box:bbox()
  love.graphics.draw(self.image, l, t)
end
