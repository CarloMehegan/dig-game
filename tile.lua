local class = require 'middleclass'

Tile = class('Tile')

function Tile:initialize(x, y)
  self.x = x
  self.y = y
  self.w = 40
  self.h = 40
  self.a = love.math.random(40,90)/100.0
  self.c = {.71,.40,.11, self.a}
  self.s = 1
  self.broken = false
  self.ladder = false
end

function Tile:update(dt)

end

function Tile:draw(prox)
  if self.broken == false then
    if self.name == "gem" and cavefound then
      love.graphics.setColor(.90,.1,.1,1/(prox/gemshine/self.a))
      love.graphics.rectangle("fill", (self.x-1)*40, (self.y-1)*40, self.w, self.h)
    elseif self.name == "diamond" then
      love.graphics.setColor(self.c[1],self.c[2],self.c[3],self.c[4]/(prox)) -- dirt
      love.graphics.rectangle("fill", (self.x-1)*40, (self.y-1)*40, self.w, self.h)
      love.graphics.setColor(50/255,181/255,237/255,self.c[4]/(prox)) -- diamond
      love.graphics.rectangle("fill", ((self.x-1)*40) + 10, ((self.y-1)*40) + 10, self.w/4, self.h/4)
      love.graphics.rectangle("fill", ((self.x-1)*40) + 20, ((self.y-1)*40) + 26, self.w/4, self.h/4)
      love.graphics.rectangle("fill", ((self.x-1)*40) + 25, ((self.y-1)*40) + 19, self.w/4, self.h/6)
      love.graphics.rectangle("fill", ((self.x-1)*40) + 30, ((self.y-1)*40) + 7, self.w/6, self.h/6)
      love.graphics.rectangle("fill", ((self.x-1)*40) + 3, ((self.y-1)*40) + 13, self.w/6, self.h/6)
      love.graphics.rectangle("fill", ((self.x-1)*40) + 5, ((self.y-1)*40) + 20, self.w/6, self.h/6)
      -- love.graphics.rectangle("fill", ((self.x-1)*40) + 5, ((self.y-1)*40) + 5, self.w - 10, self.h - 10)
    else
      love.graphics.setColor(self.c[1],self.c[2],self.c[3],self.c[4]/(prox))
      love.graphics.rectangle("fill", (self.x-1)*40, (self.y-1)*40, self.w, self.h)
    end
  elseif self.broken == true then
    love.graphics.setColor(0.2,0.2,0.2,.8/(prox/4))
    love.graphics.rectangle("fill", (self.x-1)*40, (self.y-1)*40, self.w, self.h)
    if self.name == "cave" and cavefound then
      love.graphics.setColor(0.2,0.1,0.1,.8/(prox/15)) --cave is glowy red
      love.graphics.rectangle("fill", (self.x-1)*40, (self.y-1)*40, self.w, self.h)
    elseif self.name == "cave" and cavefound == false then
      love.graphics.setColor(0.16,0.1,0.1,.8/(prox/4)) --cave is glowy red
      love.graphics.rectangle("fill", (self.x-1)*40, (self.y-1)*40, self.w, self.h)
    end
    if self.ladder then
      if self.name == "cave" and cavefound then
        love.graphics.setColor(0.9,0.9,0.9,self.c[4]/(prox/6))
      else
        love.graphics.setColor(0.9,0.9,0.9,self.c[4]/(prox))
      end
      love.graphics.draw(ladderimg, (self.x-1)*40, (self.y-1)*40, 0, 0.25)
    end
    -- love.graphics.setColor(0.2,0.2,0.2,.8/(prox/3))
    -- love.graphics.rectangle("fill", (self.x-1)*40, (self.y-1)*40, self.w, self.h)
  end
end

return Tile
