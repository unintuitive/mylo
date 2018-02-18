local Object = require 'lib.classic.classic'
local Spawner = Object:extend()

function Spawner:new()
  self.enemyTimer = 0
  self.goalTimer = 0
  self.enemySpawnChance = 3
  wallSpawnWindowOffset = Vector(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
  self.timer = 0

  gameObjects = {}
end

function Spawner:update(dt)
  self:spawnEnemy(dt)
  -- self:spawnWall(dt)
  -- self:spawnGoal(dt)
end

function Spawner:spawnEntity(entity, world, w, h, offset)
  local offset = offset or windowOffset
  local p = Vector(math.random(0, love.graphics.getWidth()) - offset.x, math.random(0, love.graphics.getHeight()) - offset.y )
  p = p + (p - player.position):normalized() * 150
  self:createGameObject(entity, {world = world, w = w, h = h, playerX = p.x, playerY = p.y})
end

function Spawner:spawnEnemy(dt)
  -- Spawn enemies every 5 seconds
  local spawnEnemies = false
  self.enemyTimer = self.enemyTimer + dt
  if self.enemyTimer > 5 then
    spawnEnemies = true
    self.enemyTimer = 0
  end

  if spawnEnemies and not player.dead and math.random(self.enemySpawnChance) == 1 then
    self:spawnEntity('Enemy', world, 40, 40, windowOffset)
  end
end

-- function Spawner:spawnGoal(dt)
--   local spawnGoals = false
--   self.goalTimer = self.goalTimer + dt
--   if self.goalTimer > 2 then
--     spawnGoals = true
--     self.goalTimer = 0
--   end

--   if spawnGoals and not player.dead then
--     self:spawnEntity('Goal', windowOffset, 15, 15)
--   end
-- end

-- function Spawner:spawnWall(dt)
--   local spawnWalls = false
--   self.timer = self.timer + dt
--   if self.timer > 2 then
--     spawnWalls = true
--     self.timer = 0
--   end

--   if spawnWalls and not player.dead then
--     self:spawnEntity('Wall', wallSpawnWindowOffset, 250, 60)
--   end
-- end

function Spawner:createGameObject(type, options)
  local game_object = _G[type](type, options)
  table.insert(gameObjects, game_object)
  return game_object
end

function Spawner:destroyGameObject(gameObject, level)
  -- Destroy the object in a given level...
  if level then
    if gameObject.level == level then
      print("Spawner destroying " .. tostring(gameObject))
      table.remove(gameObjects, gameObject)
    end
  else
    table.remove(gameObjects, gameObject)
  end
end

-- -- Doesn't work
-- function Spawner:spawnAfter(dt, waitTime, entity, w, h, offset, timer)
--   local offset = offset or windowOffset
--   local spawn = false
--   local timer = timer or 0

--   timer = timer + dt

--   if timer > waitTime then
--     spawn = true
--     timer = 0
--   end

--   if spawn and not player.dead then
--     self:spawnEntity(entity, offset, w, h)
--   end
-- end

return Spawner
