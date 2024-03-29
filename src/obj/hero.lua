require 'src.obj.attack'

local heroSlashImage = love.graphics.newImage('assets/hero_slash.png')

local Hero = class('Hero')
function Hero:initialize(x, y, hp, armor, img, deadImg)
  local l = x
  local t = y + 20 - img:getHeight()
  self.box = HC:addRectangle(l, t, img:getWidth(), img:getHeight())
  HC:addToGroup('hero', self.box)
  self.box.parent = self
  self.image = img
  self.deadImage = deadImg
  self.name = 'Hero'
  self.hp = { current = hp, max = hp }
  self.armor = armor
  self.velocity = { x = 50, y = 0 }
  self.timer = { count = 0, delay = 3 }
  self.previous = { x = 0, y = 0 }
  self.removable = false
  self.facing = 'left'
end

function Hero:getFacing()
  return self.facing
end

function Hero:draw()
  local l, t, r, b = self.box:bbox()
  if self.facing == 'left' then
    love.graphics.draw(self.image, l, t)
  elseif self.facing == 'right' then
    love.graphics.draw(self.image, l, t, 0, -1, 1, self.image:getWidth())
  end

  love.graphics.setColor(255,   0,   0)
  love.graphics.rectangle('fill', l, t - 10, (r - l) * (self.hp.current / self.hp.max), 3)
  love.graphics.setColor(255, 255, 255)
end

function Hero:__tostring()
  local l, t = self.box:bbox()
  return string.format('Hero: (%d, %d)', l, t)
end

function Hero:callback(dt, o, dx, dy)
  if instanceOf(RedirectBlock, o) then
    if self.velocity.x ~= 0 and (self.velocity.y - GRAVITY) == 0 then
      self.box:move(dx * 4, dy)
      self.velocity.x = -self.velocity.x
    end
  elseif instanceOf(CollisionBlock, o) then
    self.box:move(dx, dy)
  elseif instanceOf(FloatingBlock, o) and not instanceOf(Dead, self) then
    if self.velocity.y > 0 then
      self.box:move(0, dy)
    end
  elseif instanceOf(WallBlock, o) then
    self.box:move(dx * 4, dy)
    self.velocity.x = -self.velocity.x
  else
    if not instanceOf(Dead, self) then
      for _,v in pairs{ Slash, Throw } do
        if instanceOf(v, o) then
          print('Hit hero with', o.name)
          self.hp.current = self.hp.current - o.damage
          o.removable = true
        end
      end
    end
  end
end

local rangerImage = love.graphics.newImage('assets/ranger.png')
local rangerDeadImage = love.graphics.newImage('assets/ranger_dead.png')
Ranger = class('Ranger', Hero)
function Ranger:initialize(x, y)
  Hero.initialize(self, x, y, 25, 0.75, rangerImage, rangerDeadImage)
end

function Ranger:attack(dt, boss)
  self.timer.count = self.timer.count + dt
  if self.timer.count < self.timer.delay then return end

  self.timer.count = 0

  local x1, y1 = self.box:center()
  local x2, y2 = boss.box:center()

  return Arrow:new(x1, y1, { x = x2 - x1, y = y2 - y1 }, 3)
end

function Ranger:update(dt, boss)
  if self.hp.current <= 0 then 
    self.removable = true
    return nil
  end

  local l, t, r, b = self.box:bbox()
  if t == self.previous.y then
    self.velocity.y = 0
  end

  if self.velocity.x < 0 then
    self.facing = 'left'
  elseif self.velocity.x > 0 then
    self.facing = 'right'
  end

  self.velocity.y = self.velocity.y + GRAVITY
  self.box:move(self.velocity.x * dt, self.velocity.y * dt)

  self.previous.y = t

  return self:attack(dt, boss)
end

local berzekerImage = love.graphics.newImage('assets/berzerker.png')
local berzerkerDeadImage = love.graphics.newImage('assets/berzerker_dead.png')
Berzerker = class('Berzerker', Hero)
function Berzerker:initialize(x, y)
  Hero.initialize(self, x, y, 150, 0.85, berzekerImage, berzerkerDeadImage)
  self.previous = {
    y = 0
  }
  self.timer = {
    count = 0,
    delay = 1.5
  }
  self.swingFacing = 'left'
end

function Berzerker:getFacing()
  return self.swingFacing
end

function Berzerker:attack(dt, boss)
  self.timer.count = self.timer.count + dt
  if self.timer.count < self.timer.delay then return nil end
  self.timer.count = 0

  local l = self.box:bbox()
  local bL = boss.box:bbox()

  if self.velocity.x < 0 then
    self.facing = 'left'
  elseif self.velocity.x > 0 then
    self.facing = 'right'
  end

  self.swingFacing = l > bL and 'left' or 'right'

  return Slash:new(15, self, false, heroSlashImage)
end

function Berzerker:update(dt, boss)
  if self.hp.current <= 0 then 
    self.removable = true
    return nil
  end

  local _,t = self.box:bbox()
  if t == self.previous.y then self.velocity.y = -200 end

  self.velocity.y = self.velocity.y + GRAVITY

  self.box:move(self.velocity.x * dt, self.velocity.y * dt)

  self.previous.y = t

  return self:attack(dt, boss)
end

local knightImage = love.graphics.newImage('assets/knight.png')
local knightDeadImage = love.graphics.newImage('assets/knight_dead.png')
Knight = class('Knight', Hero)
function Knight:initialize(x, y)
  Hero.initialize(self, x, y, 100, 0.5, knightImage, knightDeadImage)
  self.heldAttack = nil
  self.newAttack = false
  self.timer = {
    count = 2.0,
    delay = 2.0
  }
end

function Knight:attack(dt, boss)
  self.timer.count = self.timer.count + dt
  if self.timer.count < self.timer.delay then 
    self.heldAttack = nil
    return 
  end

  local _,_,_, b = self.box:bbox()
  local _,_,_,bB = boss.box:bbox()

  if self.heldAttack == nil and math.floor(b) == math.floor(bB) then 
    self.newAttack = true
    self.heldAttack = Charge:new(35, self, heroSlashImage)
  elseif self.heldAttack ~= nil and math.floor(b) ~= math.floor(bB) then
    self.heldAttack.removable = true
    self.heldAttack = nil
  end
end

function Knight:update(dt, boss)
  if self.hp.current <= 0 then 
    self.removable = true
    return nil
  end

  local l, t, r, b = self.box:bbox()
  if t == self.previous.y then
    self.velocity.y = 0
  end

  if self.velocity.x > 0 then
    self.facing = 'right'
  elseif self.velocity.x < 0 then
    self.facing = 'left'
  end

  self.velocity.y = self.velocity.y + GRAVITY

  self:attack(dt, boss)
  if self.heldAttack ~= nil then
    self.box:move(self.velocity.x * dt * 3, self.velocity.y * dt)
  else
    self.box:move(self.velocity.x * dt, self.velocity.y * dt)
  end

  self.previous.y = t

  if self.newAttack then
    self.newAttack = false
    return self.heldAttack
  else
    return nil
  end
end

local deadImage = love.graphics.newImage('assets/dead.png')
Dead = class('Dead', Hero)
function Dead:initialize(x, y, img)
  Hero.initialize(self, x, y, 0, 0, img)
  self.velocity = { x = 0, y = 0 }
  self.name = 'Dead'
  self.flags = {
    thrown = false,
    angle = 0
  }
end

function Dead:attack(dt)
  if self.flags.thrown then
    self.flags.thrown = false
    local rad = self.flags.angle * math.pi / 180.0
    self.velocity = { x = 600 * math.cos(rad), y = 600 * math.sin(rad) }
    return Throw:new(25, self, self.image)
  else
    return nil
  end
end

function Dead:update(dt)
  local l, t, r, b = self.box:bbox()

  if t == self.previous.y then self.velocity.y = 0 end

  local attack = self:attack(dt)

  if self.velocity.x > 0 then
    self.velocity.x = self.velocity.x - FRICTION
  elseif self.velocity.x < 0 then
    self.velocity.x = self.velocity.x + FRICTION
  end

  self.velocity.y = self.velocity.y + GRAVITY
  self.box:move(self.velocity.x * dt, self.velocity.y * dt)

  self.previous.y = t

  return attack
end

function Dead:draw()
  local l, t, r, b = self.box:bbox()
  love.graphics.draw(self.image, l, t)
end
