local Hero = class('Hero')
function Hero:initialize(x, y, img)
  self.x = x
  self.y = y
  self.image = img
  self.velocity = {
    x = 5,
    y = 0
  }
end

local GRAVITY = 1.0

function Hero:update(dt)
  self.velocity.y = self.velocity.y + GRAVITY
  self.x = self.x + (self.velocity.x * dt)
  self.y = self.y + (self.velocity.y * dt)
end

function Hero:draw()
  love.graphics.draw(self.image, self.x, self.y)
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
