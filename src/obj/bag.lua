Bag = class('Bag')
function Bag:initialize(tbl)
  self.objects = {}
  self.bodies = {}
  self.attacks = {}

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
  elseif instanceOf(Attack, o) then
    print('Adding to attacks...')
    table.insert(self.attacks, o)
  else
    print('Adding to objects...')
    table.insert(self.objects, o)
  end
end

function Bag:cleanObjects(tbl)
  for i,v in ipairs(tbl) do
    if v.removable then
      local l, t = v.box:bbox()
      HC:remove(v.box)
      table.remove(tbl, i)
      print('Adding dead...')
      self:add(Dead:new(l, t, v.deadImage))
    end
  end
end

function Bag:cleanTable(tbl)
  for i,v in ipairs(tbl) do
    if v.removable then
      print('Cleaned object', v.name)
      HC:remove(v.box)
      table.remove(tbl, i)
    end
  end
end

function Bag:updateTable(dt, tbl)
  for _,v in pairs(tbl) do self:add(v:update(dt, self.boss)) end
end

function Bag:drawTable(tbl)
  for _,v in pairs(tbl) do v:draw() end
end

function Bag:update(dt)
  self:add(self.boss:update(dt))
  self:updateTable(dt, self.objects)
  self:updateTable(dt, self.attacks)
  self:updateTable(dt, self.bodies)

  self:cleanObjects(self.objects)
  self:cleanTable(self.attacks)
end

function Bag:draw()
  self.boss:draw()
  self:drawTable(self.objects)
  self:drawTable(self.attacks)
  self:drawTable(self.bodies)
end

function Bag:keypressed(key, code)
  self.boss:keypressed(key, code)
end

function Bag:keyreleased(key, code)
  self.boss:keyreleased(key, code)
end

function Bag:cleanUp()
  self.boss:cleanUp()
end
