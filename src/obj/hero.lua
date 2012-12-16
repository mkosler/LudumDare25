local Hero = Class{
  function(self, x, y, img)
    self.x = x
    self.y = y
    self.image = img
  end
}

function Hero:applyDamage(dmg)
  self.hp = self.hp - (dmg * self.armor)
end

function Hero:draw()
  love.graphics.draw(self.image, self.x, self.y)
end

local rangerImage   = love.graphics.newImage('assets/archer.png')
local berzekerImage = love.graphics.newImage('assets/berserker.png')
local knightImage   = love.graphics.newImage('assets/knight.png')
local mageImage     = love.graphics.newImage('assets/mage.png')

Ranger = Class{
  inherits = Hero,
  function(self, x, y)
    self.hp = 75
    self.armor = 0.75
    Hero.construct(self, x, y, rangerImage)
  end
}

Berzerker = Class{
  inherits = Hero,
  function(self, x, y)
    self.hp = 150
    self.armor = 0.85
    Hero.construct(self, x, y, berzekerImage)
  end
}

Knight = Class{
  inherits = Hero,
  function(self, x, y)
    self.hp = 100
    self.armor = 0.5
    Hero.construct(self, x, y, knightImage)
  end
}

Mage = Class{
  inherits = Hero,
  function(self, x, y)
    self.hp = 50
    self.armor = 1.0
    Hero.construct(self, x, y, mageImage)
  end
}
