local blockImage = love.graphics.newImage('assets/block.png')
local Block = class('Block')
function Block:initialize(x, y, img)
  self.box = HC:addRectangle(x, y, img:getWidth(), img:getHeight())
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

function Block:cleanUp()
  HC:remove(self.box)
end

CollisionBlock = class('CollisionBlock', Block)
function CollisionBlock:initialize(x, y)
  Block.initialize(self, x, y, blockImage)
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

local floatingBlockImage = love.graphics.newImage('assets/float.png')
FloatingBlock = class('FloatingBlock', Block)
function FloatingBlock:initialize(x, y)
  Block.initialize(self, x, y, floatingBlockImage)
  self.name = 'FloatingBlock'
end

WallBlock = class('WallBlock', Block)
function WallBlock:initialize(x, y)
  Block.initialize(self, x, y, redirectBlockImage)
  self.name = 'WallBlock'
end

function WallBlock:draw()
end
