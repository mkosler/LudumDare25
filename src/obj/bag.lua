Bag = Class{
  function(self)
    self.objects = {}
  end
}

function Bag:add(o)
  table.insert(self.objects, o)
end

function Bag:clean()
  for i,v in ipairs(self.objects) do
    if v:isDead() then table.remove(self.objects, i) end
  end
end

function Bag:update(dt)
  for _,v in pairs(self.objects) do v:update(dt) end
end

function Bag:draw()
  for _,v in pairs(self.objects) do v:draw() end
end
