-- Libraries
GUI = require 'lib.Quickie'

-- States
local Play = require 'src.states.play'
local Tutorial = require 'src.states.tutorial'

local Menu = GS.new()

function Menu:enter(prev)
end

function Menu:update(dt)
  GUI.group.push{grow = 'down', pos = {love.graphics.getWidth() / 16, love.graphics.getHeight() / 16}}
  if GUI.Button{text = 'Play'} then
    GS.switch(Play)
  end
  if GUI.Button{text = 'How To Play'} then
    GS.switch(Tutorial)
  end
  if GUI.Button{text = 'Exit'} then
    love.event.quit()
  end
  GUI.group.pop()
end

function Menu:draw()
  GUI.core.draw()
end

function Menu:keypressed(key, code)
  GUI.keyboard.pressed(key, code)
end

return Menu
