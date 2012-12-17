-- Libraries
GS = require 'lib.hump.gamestate'
Collider = require 'lib.HardonCollider'
Timer = require 'lib.hump.timer'
require 'lib.middleclass'

-- States
Menu = require 'src.states.menu'

function love.load()
  math.randomseed(os.time())
  math.random(); math.random(); math.random()

  HC = Collider()

  GS.registerEvents()
  GS.switch(Menu)
end
