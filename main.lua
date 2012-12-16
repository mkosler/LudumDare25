-- Libraries
GS = require 'lib.hump.gamestate'
Class = require 'lib.hump.class'

--require 'assets'

-- States
Menu = require 'src.states.menu'

function love.load()
  math.randomseed(os.time())
  math.random(); math.random(); math.random()

  GS.registerEvents()
  GS.switch(Menu)
end
