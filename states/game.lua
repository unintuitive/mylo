Game = {}

function Game:init()
  -- Order of these definitions is important. Don't alter!
  spawner = Spawner()
  world = Bump.newWorld(32)
  self.currentLevel = nil
  level = Level()
end

function Game:enter()
  windowOffset = Vector(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)

  self:loadLevel('first')
end

function Game:loadLevel(levelNumber)
  local statics, kinetics, tileset, quadInfo, playerX, playerY = level:load(levelNumber)
  map = Map(32, 32, world, statics, kinetics, tileset, quadInfo, levelNumber)
  map:build()
  print("Creating Game level map from mapstring:")
  print(map.mapString)
  self.currentLevel = level:getCurrentLevel()
  -- TODO: implement
  -- kineticMap = staticMap:add('platform')

  player = spawner:createGameObject('Player', {world = world, x = playerX, y = playerY, w = 32, h = 32})

  -- Center the camera on the player
  camera = Camera(player.body.position:unpack())
end

function Game:changeLevel()
  level.changeLevel = true
end

-- Forces game updates to be locked to 60FPS
-- update interval in seconds
local interval = 1/60
-- maximum frame skip
local maxsteps = 5
-- accumulator
local accum = 0

function Game:update(dt)
  local steps = 0
  -- update the simulation
  accum = accum + dt
  while accum >= interval do
    -- -- Spawn new entities at pre-defined intervals
    -- spawner:update(dt)

    self:updateGameObjects(dt)
    level:update(dt)

    -- The camera follows the movement of the player
    local playerPosition = Vector(player.body.position.x, player.body.position.y)
    camera:lockX(playerPosition.x, camera.smooth.linear(700))
    camera:lockY(playerPosition.y, camera.smooth.linear(700))

    accum = accum - interval
    steps = steps + 1
    if steps >= maxsteps then
      break
    end
  end
end

-- Check if a game object exists and is not dead. If so, update it.
-- Remove objects from the gameObjects table when they die and remove them
-- from the bump to prevent ghost collisions.
function Game:updateGameObjects(dt)
  for i = #gameObjects, 1, -1 do
    local game_object = gameObjects[i]
    if game_object.dead then
      table.remove(gameObjects, i)
      world:remove(game_object)
    else
      game_object:update(dt)
    end
  end
end

function Game:draw()
  -- Begin camera tracking
  -- Everything between the camera functions will be drawn to the camera.
  camera:attach()

  map:draw()

  for i = 1, #gameObjects do
    local game_object = gameObjects[i]
    if game_object.dead ~= true then
      game_object:draw()
    end
  end

  -- End camera tracking
  if shouldDrawDebug then
    self:drawDebug()
  end

  camera:detach()
end


function Game:drawDebug()
  BumpDebug.draw(world)

  local statistics = ("fps: %d, mem: %dKB, items: %d"):format(love.timer.getFPS(), collectgarbage("count"), world:countItems())
  love.graphics.setColor(255, 255, 255)
  love.graphics.printf(statistics, 0, 580, 790, 'right')
end


-- TODO: use the below code to convert all keydowns to keypressed
-- Consolidate all of these things into the Controls class.
-- local keysPressed = {}

-- function love.keypressed(k)
--   keysPressed[k] = true
-- end

-- function love.keyreleased(k)
--   keysPressed[k] = nil
-- end

-- function love.draw()
--   love.graphics.print("Keys pressed:", 10, 10)
--   local y = 30
--   for k,_ in pairs(keysPressed) do
--     love.graphics.print(k, 20, y)
--     y = y + 15
--   end
-- end

function Game:keypressed(k)
  if k == "tab"    then shouldDrawDebug = not shouldDrawDebug end
  if k == "escape" then love.event.quit() end
  if k == 'w' and player.grounded then
    player.body:jump(player.jumpVelocity, player.jumpTerm, 'up')
    player.grounded = false
  end
  -- if k == 'a' then
  --   player.body:applyVelocityDirection(dt, 'left')
  -- end
end

function Game:keyreleased(k)
  if k == 'w' then
    player.body:releaseJump()
  end
end

function Game:addEnemies(number)
  -- -- Insert enemies
  -- for i = 1, number do
  --   local px = (math.random(0, love.graphics.getWidth()) - windowOffset.x)
  --   local py = (math.random(0, love.graphics.getHeight()) - windowOffset.y)
  --   px = px + player.body.position.x + 100
  --   py = py + player.body.position.y + 100
  --   spawner:createGameObject('Enemy', {world = world, w = 40, h = 40, playerX = px, playerY = py})
  -- end
end

function Game:addBlocks(number)
  -- -- Insert blocks
  -- for i = 1, 10 do
  --   local px = (math.random(0, love.graphics.getWidth()) - windowOffset.x)
  --   local py = (math.random(0, love.graphics.getHeight()) - windowOffset.y)
  --   px = px + player.body.position.x + 100
  --   py = py + player.body.position.y + 100
  --   spawner:createGameObject('Block', {world = world, w = 80, h = 80, playerX = px, playerY = py})
  -- end
end
