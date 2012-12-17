local peasantImage = love.graphics.newImage('assets/peasant.png')

Peasant = Class('Peasant')
function Peasant:initialize(x, y)
  self.hp = 20
  self.image = peasantImage
  self.box = HC:addRectangle(x, y, self.image:getWidth(), self.image:getHeight())
  self.box.name = 'Peasant'
  self.velocity = {
    x = 5,
    y = 0
  }
end

function Peasant:update(dt)
  self.box:move(self.velocity.x, self.velocity.y)
end

function Peasant:draw()
  local x, y = self.box:bbox()
  love.graphics.draw(self.image, x, y)
end
