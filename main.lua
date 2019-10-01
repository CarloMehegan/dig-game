-- Carlo Mehegan
-- First independent project for Advanced Programming
-- Sept 2019

tiles = {}
function love.load()
  -- love.graphics.setBackgroundColor(0.2, 0.2, 0.2)
  w = 30
  h = 20
  love.window.setMode(40*w, 40*h)
  for x=1,w do
    tiles[x] = {}
    for y=1,h do
      -- tiles[x][y] = Tile(x*61+100,y*61+300,60,60)
      tiles[x][y] = Tile:Create( {x = x, y = y, w = 40, h = 40} )
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
      tiles[x][y]:Draw()
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

  boy.leftpressed = false
  function boy:Update(dt)
    if onePressKey('a', self.leftpressed) then
      self.x = self.x + 10
    end
  end

  function boy:Draw()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(boy.img, (self.x-1)*40, (self.y-1)*40, 0, 0.25)
  end

  return boy
end

Tile = {
  x, y, w, h, c
}
function Tile:Create(tile)
  local tile = tile or {}

  tile.c = {.71,.40,.11,love.math.random(50,100)/100.0}
  -- tile.a = love.math.random(50,100)/100.0

  tile.broken = false

  function tile:Update(dt)

  end

  function tile:Draw()
    if self.broken == false then
      love.graphics.setColor(self.c)
      love.graphics.rectangle("fill", (self.x-1)*40, (self.y-1)*40, self.w, self.h)
    end
  end

  setmetatable(tile, self)
  self.__index = self
  return tile
end



function love.keypressed(key, scancode, isrepeat)
  -- body...
end

function onePressKey(key, bool)
  if love.keyboard.isDown(key) and bool == false then
    bool = true
    return true
  elseif love.keyboard.isDown(key) == false and bool == true then
    bool = false
    return false
  elseif love.keyboard.isDown(key) == true and bool == true then
    return false
  end
end
