-- Carlo Mehegan
-- First independent project for Advanced Programming
-- Sept 2019

-- Rules
-- WASD to move and dig
-- You are a miner looking for a secret cavern.
-- The cavern contains the rarest gem in the world.
-- Go find the cavern and get the gem.
-- tip: darker rocks = harder to break

local Boy = require 'boy'
local Tile = require 'tile'
tiles = {}

function love.load()
  -- best to keep width and height greater than 5
  w = love.math.random(10,35)
  h = love.math.random(7,20)
  cavefound = false
  ladderimg = love.graphics.newImage('ladder.png')
  love.window.setMode(40*w, 40*h)

  for x=1,w do --creating tile grid
    tiles[x] = {}
    for y=1,h do
      tiles[x][y] = Tile:new(x, y)
    end
  end

  -- algorithm start ======================================================
  -- placing cave
  local x = math.floor(w/2)
  local y = math.floor(h/2)

  for i = 1, 50 do

    local dx = love.math.random(-1,1)
    local dy = love.math.random(-1,1)

    if x + dx > 0 and x + dx < w and y + dy > 0 and y + dy < h then
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
        tiles[math.floor(w/2)][math.floor(h/2)].name = "gem"
      end
    end
  end
  -- algorithm end ========================================================

  -- algorithm start ======================================================
  -- placing diamond bunch
  local x = love.math.random(2,w-1)
  local y = love.math.random(2,h-1)

  for i = 1, 5 do

    local dx = love.math.random(-1,1)
    local dy = love.math.random(-1,1)

    if x + dx > 0 and x + dx < w and y + dy > 0 and y + dy < h then
      tiles[x+dx][y+dy].name = "diamond"
    end

    if x + dx > 0 and x + dx <= w then
      x = x + dx
    end
    if y + dy > 0 and y + dy <= h then
      y = y + dy
    end

  end
  -- algorithm end ========================================================

  for x=1, w do -- creating Boy, clearing top row of tiles
    tiles[x][1].broken = true
  end
  boy = Boy:new(3, 1)
end

function love.update(dt)
  boy:update(dt)
  if tiles[boy.x][boy.y+1] and tiles[boy.x][boy.y+1].broken == true then
    if tiles[boy.x][boy.y+1].ladder == false then
      boy.y = boy.y + 1
    end
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
      tiles[x][y]:update(dt)
    end
  end
end

function love.draw()
  for x=1,w do
    for y=1,h do
      prox = FindProximity(x,y)
      tiles[x][y]:draw(prox)
    end
  end
  boy:draw()
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
      tiles[boy.x][boy.y].ladder = true
      boy.y = boy.y-1
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
