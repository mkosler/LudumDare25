local peasantImage = love.graphics.newImage('assets/peasant.png')

Peasant = Class{
  function(self, x, y)
    self.x = x
    self.y = y
    self.hp = 20
    self.image = peasantImage
  end
}

function Peasant:update(dt)
end

function Peasant:draw()
  love.graphics.draw(self.image, self.x, self.y)
end
