local class = require 'middleclass'

Boy = class('Boy')

function Boy:initialize(x, y)
  self.x = x
  self.y = y
  self.w = 16
  self.h = 16
  self.img = love.graphics.newImage('diggin boy.png')
  self.power = 0.2
end


function Boy:update(dt)

end

function Boy:draw()
  love.graphics.setColor(1,1,1)
  love.graphics.draw(self.img, (self.x-1)*40, (self.y-1)*40, 0, 0.25)
  -- if ladderDeployed then
  --   love.graphics.setColor(1,1,1)
  --   love.graphics.draw(self.ladder, (self.ladderx-1)*40, (self.laddery-1)*40, 0, 0.25)
  -- end
end

return Boy
