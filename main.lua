-- Libraries
GS = require 'lib.hump.gamestate'
Collider = require 'lib.HardonCollider'
require 'lib.middleclass'

-- States
Menu = require 'src.states.menu'

-- Globals
GRAVITY = 9.5
FRICTION = 5.0

function love.load()
  math.randomseed(os.time())
  math.random(); math.random(); math.random()

  HC = Collider()

  GS.registerEvents()
  GS.switch(Menu)
end
