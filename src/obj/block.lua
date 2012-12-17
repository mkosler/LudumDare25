local blockImage = love.graphics.newImage('assets/block.png')
local Block = class('Block')
function Block:initialize(x, y, img)
  self.box = HC:addRectangle(x, y, 20, 20)
  HC:addToGroup('level', self.box)
  HC:setPassive(self.box)
  self.box.parent = self

  -- Fields
  self.image = img
  self.name = 'Block'
end

function Block:draw()
  local l, t = self.box:bbox()
  love.graphics.draw(self.image, l, t)
end

local collideBlockImage = love.graphics.newImage('assets/collideBlock.png')
CollisionBlock = class('CollisionBlock', Block)
function CollisionBlock:initialize(x, y)
  Block.initialize(self, x, y, collideBlockImage)
  self.name = 'CollisionBlock'
end

local redirectBlockImage = love.graphics.newImage('assets/redirectBlock.png')
RedirectBlock = class('RedirectBlock', Block)
function RedirectBlock:initialize(x, y)
  Block.initialize(self, x, y, redirectBlockImage)
  HC:addToGroup('redirect', self.box)
  self.name = 'RedirectBlock'
end

function RedirectBlock:draw()
end
