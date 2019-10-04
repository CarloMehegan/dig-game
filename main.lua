-- Carlo Mehegan
-- First independent project for Advanced Programming
-- Sept 2019

-- Rules
-- WASD to move and dig
-- You are a miner looking for a secret cavern.
-- The cavern contains the rarest gem in the world.
-- Go find the cavern and get the gem.
-- tip- darker rocks = harder to break

tiles = {}
function love.load()
  -- love.graphics.setBackgroundColor(0.2, 0.2, 0.2)
  w = 30
  h = 20
  cavefound = false
  love.window.setMode(40*w, 40*h)
  for x=1,w do
    tiles[x] = {}
    for y=1,h do
      -- tiles[x][y] = Tile(x*61+100,y*61+300,60,60)
      tiles[x][y] = Tile:Create( {x = x, y = y, w = 40, h = 40} )
    end
  end


  -- algorithm start ======================================================
  local x = w/2
  local y = h/2

  for i = 1, 50 do

    local dx = love.math.random(-1,1)
    local dy = love.math.random(-1,1)

    if x + dx > 0 and x + dx <= w and y + dy > 0 and y + dy <= h then
      tiles[x+dx][y+dy].broken = true
      tiles[x+dx][y+dy].name = "cave"
    end

    if x + dx > 0 and x + dx <= w then
      x = x + dx
    end
    if y + dy > 0 and y + dy <= h then
      y = y + dy
    end

    if i == 50 then
      if x + dx > 0 and x + dx <= w and y + dy > 0 and y + dy <= h then
        tiles[x+dx][y+dy].broken = false
        tiles[x+dx][y+dy].name = "gem"
        gemshine = 0
        gemshinefade = false
      else
        tiles[w/2][h/2].name = "gem"
      end
    end
  end
  -- algorithm end ========================================================


  for x=1, w do
    tiles[x][1].broken = true
  end
  boy = Boy:Create({x = 3, y = 1})
end

function love.update(dt)
  boy:Update(dt)
  if tiles[boy.x][boy.y+1] and tiles[boy.x][boy.y+1].broken == true then
    boy.y = boy.y + 1
  end
  if tiles[boy.x][boy.y].name == "cave" and cavefound == false then
    cavefound = true
    gemshine = 10
    gemshinefade = true
  end
  if gemshinefade == true then
    if gemshine > 1 then
      if gemshine < 2 then
        gemshine = 1
        gemshinefade = false
      else
        gemshine = gemshine - 0.1
      end
    else
      gemshine = 1
      gemshinefade = false
    end
  end
  for x=1,w do
    for y=1,h do
      tiles[x][y]:Update(dt)
    end
  end
end

function love.draw()
  for x=1,w do
    for y=1,h do
      prox = FindProximity(x,y)
      tiles[x][y]:Draw(prox)
    end
  end
  boy:Draw()
end

function FindProximity(x,y)
  x0 = (x - boy.x)^2
  y0 = (y - boy.y)^2
  return math.sqrt(x0+y0)
end

function Move(key)

  if key == "d" and boy.x < w then
    if tiles[boy.x + 1][boy.y].broken == true then
      boy.x = boy.x + 1
    elseif tiles[boy.x + 1][boy.y].broken == false then
      Mine(boy.x + 1, boy.y)
    end
  end
  if key == "s" and boy.y < h then
    if tiles[boy.x][boy.y + 1].broken == true then
      boy.y = boy.y + 1
    elseif tiles[boy.x][boy.y + 1].broken == false then
      Mine(boy.x, boy.y + 1)
    end
  end
  if key == "a" and boy.x > 1 then
    if tiles[boy.x - 1][boy.y].broken == true then
      boy.x = boy.x - 1
    elseif tiles[boy.x - 1][boy.y].broken == false then
      Mine(boy.x - 1, boy.y)
    end
  end
  if key == "w" and boy.y > 1 then
    if tiles[boy.x][boy.y-1].broken == true then
      -- boy.y = boy.y = 1
    elseif tiles[boy.x][boy.y-1].broken == false then
      Mine(boy.x, boy.y-1)
    end
  end

end

function Mine(x,y)
  if tiles[x][y].broken == false then
    if tiles[x][y].name == "gem" then
      tiles[x][y].a = tiles[x][y].a + boy.power/3
      tiles[x][y].c = {.90,.1,.1, tiles[x][y].a}
    else
      tiles[x][y].a = tiles[x][y].a + boy.power
      tiles[x][y].c = {.71,.40,.11, tiles[x][y].a}
    end
    if tiles[x][y].a >= 0.9 then
      tiles[x][y].a = 0
      tiles[x][y].broken = true
    end
  end
end


Boy = {
  x, y, w = 16, h = 16, img = love.graphics.newImage('diggin boy.png'), power = 0.2
}
function Boy:Create(boy)
  local boy = boy or {}

  -- boy.x = x
  -- boy.y = y
  -- boy.w = 16
  -- boy.h = 16
  -- boy.img = love.graphics.newImage('diggin boy.png')

  function boy:Update(dt)

  end


  function boy:Draw()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(self.img, (self.x-1)*40, (self.y-1)*40, 0, 0.25)
  end

  setmetatable(boy, self)
  self.__index = self
  return boy
end

Tile = {
  x, y, w, h, c, s, name
}
function Tile:Create(tile)
  local tile = tile or {}
  tile.a = love.math.random(40,90)/100.0
  tile.c = {.71,.40,.11, tile.a}
  -- tile.a = love.math.random(50,100)/100.0
  tile.s = 1
  tile.broken = false

  function tile:Update(dt)

  end

  function tile:Draw(prox)
    if self.broken == false then
      if self.name == "gem" and cavefound then
        love.graphics.setColor(.90,.1,.1,1/(prox/gemshine/self.a))
        love.graphics.rectangle("fill", (self.x-1)*40, (self.y-1)*40, self.w, self.h)
      end
      love.graphics.setColor(self.c[1],self.c[2],self.c[3],self.c[4]/(prox))
      love.graphics.rectangle("fill", (self.x-1)*40, (self.y-1)*40, self.w, self.h)
    elseif self.broken == true then
      if self.name == "cave" and cavefound then
        love.graphics.setColor(0.2,0.1,0.1,.8/(prox/15)) --cave is glowy red
        love.graphics.rectangle("fill", (self.x-1)*40, (self.y-1)*40, self.w, self.h)
      end
      love.graphics.setColor(0.2,0.2,0.2,.8/(prox/3))
      love.graphics.rectangle("fill", (self.x-1)*40, (self.y-1)*40, self.w, self.h)
    end
  end

  setmetatable(tile, self)
  self.__index = self
  return tile
end



function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then
    love.event.quit()
  end
  if key == "d" then
    Move("d")
  end
  if key == "s" then
    Move("s")
  end
  if key == "a" then
    Move("a")
  end
  if key == "w" then
    Move("w")
  end
end

function onePressKey(key, bool) -- doesnt work for nothin
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
