local Tutorial = GS.new()

function Tutorial:enter(prev)
end

function Tutorial:update(dt)
end

function Tutorial:draw()
  love.graphics.print("Inside Tutorial state...", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
end

function Tutorial:keypressed(key, code)
end

return Tutorial
