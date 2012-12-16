local peasantImage = love.graphics.newImage('assets/peasant.png')

Peasant = Class('Peasant')
function Peasant:initialize(x, y)
  self.x = x
  self.y = y
  self.velocity = {
    x = 5,
    y = 0
  }
  self.hp = 20
  self.image = peasantImage
end

function Peasant:update(dt)
  self.x = self.x + (self.velocity.x * dt)
  self.y = self.y + (self.velocity.y * dt)
end

function Peasant:draw()
  love.graphics.draw(self.image, self.x, self.y)
end
