require 'src.obj.bag'
require 'src.obj.block'
require 'src.obj.door'

local function buildMap(map)
  local m = {}
  local d = nil
  local b = Bag:new{}
  for r = 1, #map do
    for c = 1, #map[r] do
      if map[r][c] == 1 then
        table.insert(m, CollisionBlock:new((c - 2) * 20, (r - 1) * 20))
      elseif map[r][c] == 2 then
        table.insert(m, RedirectBlock:new((c - 2) * 20, (r - 1) * 20))
      elseif map[r][c] == 3 then
        table.insert(m, FloatingBlock:new((c - 2) * 20, (r - 1) * 20))
      elseif map[r][c] == 4 then
        table.insert(m, WallBlock:new((c - 2) * 20, (r - 1) * 20))
      elseif map[r][c] == 5 then
        d = Door:new((c - 2) * 20, (r - 1) * 20)
      elseif map[r][c] == 6 then
        b:add(Ranger:new((c - 2) * 20, (r - 1) * 20))
      elseif map[r][c] == 7 then
        b:add(Berzerker:new((c - 2) * 20, (r - 1) * 20))
      elseif map[r][c] == 8 then
        b:add(Knight:new((c - 2) * 20, (r - 1) * 20))
      elseif map[r][c] == 9 then
        b:add(Boss:new((c - 2) * 20, (r - 1) * 20,
        {
          left = 'left',
          right = 'right',
          jump = ' ',
          attack = 'a',
          throw = 's'
        }))
      end
    end
  end
  return m, d, b
end

local function splitScript(script)
  if script == nil then return nil end

  local segments = {}
  for line in love.filesystem.lines(script) do
    if line ~= '' then
      table.insert(segments, line)
    end
  end
  print('Total segments:', #segments)
  return segments
end

Level = class('Level')
function Level:initialize(map, script)
  self.map, self.door, self.bag = buildMap(map)
  self.script = splitScript(script)
  self.timer = {
    count = 0,
    delay = 5.0
  }
  self.iterator = 0
end

function Level:update(dt)
  self.bag:update(dt)

  if self.script ~= nil then
    self.timer.count = self.timer.count + dt
    if self.timer.count >= self.timer.delay then
      self.timer.count = 0
      self.iterator = (self.iterator + 1) % #self.script
    end
  end

  if #self.bag.objects == 0 then
    self.door.openable = true
  end
end

function Level:finished()
  return self.door.opened
end

function Level:draw()
  for _,v in pairs(self.map) do v:draw() end
  self.door:draw()
  self.bag:draw()

  if self.script ~= nil then
    love.graphics.printf(self.script[self.iterator + 1], 10, 10, 100)
  end

  if self.bag.boss.dead then
    love.graphics.print('Press R to restart level', love.graphics.getWidth() / 2, 10)
  end
end

function Level:cleanUp()
  for _,v in pairs(self.map) do v:cleanUp() end
  self.door:cleanUp()
  self.bag:cleanUp()
end

function Level:keypressed(key, code)
  self.bag:keypressed(key, code)
end

function Level:keyreleased(key, code)
  self.bag:keyreleased(key, code)
end
