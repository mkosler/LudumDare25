require 'src.obj.bag'
require 'src.obj.block'

local function buildMap(map)
  local m = {}
  for r = 1, #map do
    for c = 1, #map[r] do
      if map[r][c] == 1 then
        table.insert(m, CollisionBlock((c - 2) * 20, (r - 1) * 20))
      elseif map[r][c] == 2 then
        table.insert(m, RedirectBlock((c - 2) * 20, (r - 1) * 20))
      end
    end
  end
  return m
end

Level = class('Level')
function Level:initialize(map, bag)
  self.map = buildMap(map)
  self.bag = bag
end

function Level:update(dt)
  self.bag:update(dt)
end

function Level:draw()
  for _,v in pairs(self.map) do v:draw() end
  self.bag:draw()
end

function Level:keypressed(key, code)
  self.bag:keypressed(key, code)
end

function Level:keyreleased(key, code)
  self.bag:keyreleased(key, code)
end
