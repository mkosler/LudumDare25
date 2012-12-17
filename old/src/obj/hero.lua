require 'src.obj.missile'

local Hero = class('Hero')
function Hero:initialize(x, y, img)
  self.image = img

  self.box = HC:addRectangle(x, y, img:getWidth(), img:getHeight())
  HC:addToGroup('heroes', self.box)
  self.box.name = 'Hero'
  self.box.flags = {
    redirect = false,
    remove = false,
    damage = 0
  }

  self.velocity = {
    x = 25,
    y = 0
  }

  self.timer = {
    count = 0,
    delay = 3.0
  }

  self.prevY = 0
end

function Hero:isDead()
  return self.box.flags.remove
end

local GRAVITY = 1.0

function Hero:respond()
  if self.box.flags.redirect then
    self.box.flags.redirect = false
    self.velocity.x = -self.velocity.x
  end

  if self.box.flags.damage > 0 then
    self.hp = self.hp - self.box.flags.damage
    self.box.flags.damage = 0
  end
end

function Hero:attack(dt, boss)
end

function Hero:update(dt)
  self:respond()

  local l, t, r, b = self.box:bbox()

  if t == self.prevY then self.velocity.y = 0 end

  self.velocity.y = self.velocity.y + GRAVITY
  self.box:move(self.velocity.x * dt, self.velocity.y * dt)

  self.prevY = t
end

function Hero:draw()
  local x, y = self.box:bbox()
  love.graphics.draw(self.image, x, y)
end

local rangerImage   = love.graphics.newImage('assets/archer.png')
local berzekerImage = love.graphics.newImage('assets/berserker.png')
local knightImage   = love.graphics.newImage('assets/knight.png')
local mageImage     = love.graphics.newImage('assets/mage.png')

Ranger    = class('Ranger', Hero)
function Ranger:initialize(x, y)
  Hero.initialize(self, x, y, rangerImage)
  self.hp = 75
  self.armor = 0.75
end

function Ranger:attack(dt, boss)
  self.timer.count = self.timer.count + dt
  if self.timer.count < self.timer.delay then return end

  self.timer.count = 0

  local cX, cY = self.box:center()
  local bCX, bCY = boss.box:center()

  return Arrow:new(cX, cY, 1.0, { x = bCX - cX, y = bCY - cY })
end

Berzerker = class('Berzerker', Hero)
function Berzerker:initialize(x, y)
  Hero.initialize(self, x, y, berzekerImage)
  self.hp = 150
  self.armor = 0.85
end

Knight    = class('Knight', Hero)
function Knight:initialize(x, y)
  Hero.initialize(self, x, y, knightImage)
  self.hp = 100
  self.armor = 0.5
end

Mage      = class('Mage', Hero)
function Mage:initialize(x, y)
  Hero.initialize(self, x, y, mageImage)
  self.hp = 50
  self.armor = 1.0
end
