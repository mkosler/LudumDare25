Bag = class('Bag')
function Bag:initialize(tbl)
  self.boss = tbl.boss
  self.objects = {}
  self.bodies = {}
  self.missiles = {}

  for _,v in pairs(tbl) do
    if instanceOf(Boss, v) then
      print('Setting boss...')
      self.boss = v
    elseif instanceOf(Dead, v) then
      print('Adding to bodies...')
      table.insert(self.bodies, v)
    else
      print('Adding to objects...')
      table.insert(self.objects, v)
    end
  end
end

function Bag:add(o)
  if o == nil then return end

  if instanceOf(Boss, o) then
    print('Setting boss...')
    self.boss = o
  elseif instanceOf(Dead, o) then
    print('Adding to bodies...')
    table.insert(self.bodies, o)
  elseif instanceOf(Missile, o) then
    print('Adding to missiles...')
    table.insert(self.missiles, o)
  else
    print('Adding to objects...')
    table.insert(self.objects, o)
  end
end

function Bag:cleanTable(tbl)
  for i,v in ipairs(tbl) do
    if v.removable then
      HC:remove(v.box)
      table.remove(tbl, i)
    end
  end
end

function Bag:updateTable(dt, tbl)
  for _,v in pairs(tbl) do
    self:add(v:update(dt, self.boss))
  end
end

function Bag:drawTable(tbl)
  for _,v in pairs(tbl) do v:draw() end
end

function Bag:update(dt)
  --print(self.boss)
  self.boss:update(dt)
  self:updateTable(dt, self.objects)
  self:updateTable(dt, self.missiles)
  self:updateTable(dt, self.bodies)

  self:cleanTable(self.objects)
  self:cleanTable(self.missiles)
end

function Bag:draw()
  self.boss:draw()
  self:drawTable(self.objects)
  self:drawTable(self.missiles)
  self:drawTable(self.bodies)
end

function Bag:keypressed(key, code)
  self.boss:keypressed(key, code)
end

function Bag:keyreleased(key, code)
  self.boss:keyreleased(key, code)
end
