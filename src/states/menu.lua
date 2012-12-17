-- Libraries
GUI = require 'lib.Quickie'

-- States
local Play = require 'src.states.play'

local Menu = GS.new()

local titleImage = love.graphics.newImage('assets/title.png')

function Menu:enter(prev)
end

function Menu:update(dt)
  GUI.group.push{grow = 'down', pos = {love.graphics.getWidth() / 16, love.graphics.getHeight() / 16}}
  if GUI.Button{text = 'Play'} then
    GS.switch(Play)
  end
  if GUI.Button{text = 'Exit'} then
    love.event.quit()
  end
  GUI.group.pop()
end

function Menu:draw()
  GUI.core.draw()
  love.graphics.draw(titleImage, love.graphics.getWidth() / 4, love.graphics.getHeight() / 2)
end

function Menu:keypressed(key, code)
  GUI.keyboard.pressed(key, code)
end

return Menu
