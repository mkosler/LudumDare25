require 'src.obj.bag'

local blockImage         = love.graphics.newImage('assets/block.png')
local collideBlockImage  = love.graphics.newImage('assets/collideBlock.png')
local redirectBlockImage = love.graphics.newImage('assets/redirectBlock.png')

local Block = class('Block')
function Block:initialize(x, y, img)
  self.image = img or blockImage
  self.box = HC:addRectangle(x, y, 20, 20)
  self.box.name = 'Block'
  HC:addToGroup('level', self.box)
  HC:setPassive(self.box)
end

function Block:draw()
  local x, y = self.box:bbox()
  love.graphics.draw(self.image, x, y)
end

local CollisionBlock = class('CollisionBlock', Block)
function CollisionBlock:initialize(x, y)
  Block.initialize(self, x, y, collideBlockImage)
  self.box.name = 'CollisionBlock'
end

local RedirectBlock = class('RedirectBlock', Block)
function RedirectBlock:initialize(x, y)
  Block.initialize(self, x, y, redirectBlockImage)
  self.box.name = 'RedirectBlock'
  HC:addToGroup('redirect', self.box)
end

function RedirectBlock:draw()
  -- RedirectBlock's are invisible
end

local function buildMap(map)
  local m = {}
  for row = 1, #map do
    for col = 1, #map[row] do
      if map[row][col] == 1 then
        table.insert(m, CollisionBlock((col - 2) * 20, (row - 1) * 20))
      elseif map[row][col] == 2 then
        table.insert(m, RedirectBlock((col - 2) * 20, (row - 1) * 20))
      end
    end
  end
  return m
end

local function levelCallback(dt, v1, v2, dx, dy)
  if v1.name == 'Boss' and v2.name == 'Missile' then
    print('HIT!', v2.flags.attack)
    v1.flags.damage = v2.flags.attack
    v2.flags.remove = true
  end

  if v2.name == 'CollisionBlock' then
    v1:move(dx, dy)
  elseif v2.name == 'RedirectBlock' then
    print('Redirecting:', dx, dy)
    if dy == 0 then
      v1:move(dx, dy)
      v1.flags.redirect = true
    end
  end
end

Level = class('Level')
function Level:initialize(map, bag)
  self.map = buildMap(map)
  self.bag = bag
  HC:setCallbacks(levelCallback)
end

function Level:update(dt)
  self.bag:update(dt)
  HC:update(dt)
end

function Level:draw()
  self.bag:draw()
  for _,v in pairs(self.map) do
    v:draw()
  end
end

function Level:keypressed(key, code)
  self.bag:keypressed(key, code)
end

function Level:keyreleased(key, code)
  self.bag:keyreleased(key, code)
end
