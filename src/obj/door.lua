local iterator = 0

local doorImage = love.graphics.newImage('assets/door.png')
Door = class('Door')
function Door:initialize(x, y)
  local l = x
  local t = y + 20 - doorImage:getHeight()
  self.box = HC:addRectangle(l, t, doorImage:getWidth(), doorImage:getHeight())
  self.box.parent = self
  self.name = 'Door ' .. iterator
  iterator = iterator + 1
  self.image = doorImage
  self.openable = false
  self.opened = false
end

function Door:draw()
  local l, t = self.box:bbox()
  love.graphics.draw(self.image, l, t)
end

function Door:cleanUp()
  HC:remove(self.box)
end
