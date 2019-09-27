-- Carlo Mehegan
-- First independent project for Advanced Programming
-- Sept 2019

tiles = {}
function love.load()
  w = 30
  h = 20
  love.window.setMode(40*w, 40*h)
  for x=1,w do
    tiles[x] = {}
    for y=1,h do
      -- tiles[x][y] = Tile(x*61+100,y*61+300,60,60)
      tiles[x][y] = Tile( x, y, 40, 40)
    end
  end
  tiles[w/2][h/2].broken = true
  boy = Boy(w/2,h/2)
end

function love.update(dt)
  boy:Update(dt)
end

function love.draw()
  for x=1,w do
    for y=1,h do
      tiles[x][y]:Draw(.71,.40,.11)
    end
  end
  boy:Draw()
end


function Boy(x,y)
  local boy = {}

  boy.x = x
  boy.y = y
  boy.w = 16
  boy.h = 16
  boy.img = love.graphics.newImage('diggin boy.png')

  function boy:Update(dt)

  end

  function boy:Draw()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(boy.img, (self.x-1)*40, (self.y-1)*40, 0, 0.25)
  end

  return boy
end

function Tile(x,y,w,h)
  local tile = {}

  tile.x = x
  tile.y = y
  tile.w = w
  tile.h = h

  tile.a = love.math.random(50,100)/100.0

  tile.broken = false

  function tile:Update(dt)

  end

  function tile:Draw(r,g,b)
    if self.broken == false then
      love.graphics.setColor(r, g, b, self.a)
      love.graphics.rectangle("fill", (self.x-1)*40, (self.y-1)*40, self.w, self.h)
    end
  end

  return tile
end



function love.keypressed(key, scancode, isrepeat)
  -- body...
end
