Bag = class('Bag')
function Bag:initialize(boss, obj, bodies)
  self.boss = boss
  self.objects = obj or {}
  self.missiles = {}
  self.bodies = bodies
end

function Bag:add(o)
  if o == nil then return end
  if o.box.name == 'Missile' then
    table.insert(self.missiles, o)
  elseif o.box.name == 'Dead' then
    table.insert(self.bodies, o)
  else
    table.insert(self.objects, o)
  end
end

local function tprint(tbl)
  for k,v in ipairs(tbl) do print(k,v) end
end

function Bag:clean()
  for i,v in ipairs(self.objects) do
    if v:isDead() then 
      HC:remove(v.box)
      table.remove(self.objects, i)
    end
  end
  for i,v in ipairs(self.missiles) do
    if v:isDead() then
      HC:remove(v.box)
      table.remove(self.missiles, i)
    end
  end
end

function Bag:update(dt)
  self.boss:update(dt)
  for _,v in pairs(self.objects) do 
    v:update(dt)
    self:add(v:attack(dt, self.boss))
  end

  for _,v in pairs(self.missiles) do
    v:update(dt)
  end

  for _,v in pairs(self.bodies) do
    v:update(dt)
  end

  self:clean()
end

function Bag:draw()
  self.boss:draw()
  for _,v in pairs(self.objects) do v:draw() end
  for _,v in pairs(self.missiles) do v:draw() end
  for _,v in pairs(self.bodies) do v:draw() end
end

function Bag:keypressed(key, code)
  self.boss:keypressed(key, code)
end

function Bag:keyreleased(key, code)
  self.boss:keyreleased(key, code)
end
