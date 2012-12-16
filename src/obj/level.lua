require 'src.obj.bag'

local blockImage        = love.graphics.newImage('assets/block.png')
local collideBlockImage = love.graphics.newImage('assets/collideBlock.png')

local Block = Class{
  function(self, x, y, coll)
    self.x = x
    self.y = y
    self.collidable = coll
    self.image = coll and blockImage or collideBlockImage
  end
}

function Block:draw()
  love.graphics.draw(self.image, self.x, self.y)
end

local function isCollidable(map, r, c)
  return (map[math.max(r - 1, 1)][c] ~= 0) and
    (map[math.min(r + 1, #map)][c] ~= 0) and
    (map[r][math.max(c - 1, 1)] ~= 0) and
    (map[r][math.min(c + 1, #map[r])] ~= 0)
end

local function buildMap(map)
  local m = {}
  for row = 1, #map do
    for col = 1, #map[row] do
      if map[row][col] == 1 then
        table.insert(m, Block((col - 1) * 20, (row - 1) * 20, isCollidable(map, row, col)))
      end
    end
  end
  return m
end

local function printMatrix(t)
  local str = ''
  for row = 1, #t do
    for col = 1, #t[row] do
      str = str .. tostring(t[row][col]) .. ' '
    end
    str = str .. '\n'
  end
  print(str)
end

Level = Class{
  function(self, map)
    self.map = buildMap(map)
    self.enemies = Bag()
  end
}

local function getBox(o)
  return { x = o.x, y = o.y, w = o.image:getWidth(), h = o.image:getHeight() }
end

local function haveCollided(a, b)
  local box1 = getBox(a)
  local box2 = getBox(b)

  return box1.x < (box2.x + box2.w) and 
    (box1.x + box1.w) > box2.x and 
    box1.y < (box2.y + box2.h) and 
    (box1.y + box1.h) > box2.y
end

function Level:update(dt)
  self.enemies:update(dt)

  for _,v1 in pairs(self.enemies) do
    for _,v2 in pairs(self.map) do
      if v2.collidable and haveCollided(v1, v2) then
      end
    end
  end
end

function Level:draw()
  self.enemies:draw()
  for _,v in pairs(self.map) do
    v:draw()
  end
end
