local Object = require 'lib.classic.classic'
local Level = Object:extend()

function Level:new()
  local options = options or {}
  for key, value in pairs(options) do
    self[key] = value
  end

  self.currentLevel = nil
  self.nextLevel = nil
  self.changeLevel = nil
  self.levelSequence = {'first', 'second', 'third'}
end

-- TODO: I think this can really be improved, but for now it's good enough
function Level:load(level)
  local currentLevel = self:getCurrentLevel()
  if level == 'first' then
    self.currentLevel = 'first'
    print("On level " .. self.currentLevel)
    self.nextLevel = self:getNextLevel(self.currentLevel)
    print("Next level " .. self.nextLevel)
    local statics, kinetics, tileset, quadInfo, playerX, playerY = self:first()
    return statics, kinetics, tileset, quadInfo, playerX, playerY
  elseif level == 'second' then
    self.currentLevel = 'second'
    print("On level " .. tostring(self.currentLevel))
    self.nextLevel = self:getNextLevel(self.currentLevel)
    print("Next level " .. tostring(self.nextLevel))
    local statics, kinetics, tileset, quadInfo, playerX, playerY = self:second()
    return statics, kinetics, tileset, quadInfo, playerX, playerY
  else
    return
  end
end

function Level:getCurrentLevel()
  return self.currentLevel
end

function Level:getNextLevel(level)
  local currentLevelIndex = Lume.find(self.levelSequence, level)
  local nextLevel = self.levelSequence[currentLevelIndex + 1]

  return nextLevel
end

function Level:destroyCurrentLevel()
  print("Level destruction begins")
  for i = #gameObjects, 1, -1 do
    local gameObject = gameObjects[i]
    if gameObject.level == self.currentLevel then
      print("Destroying level '" .. tostring(self.currentLevel) .. "' " .. tostring(gameObject.name) .. " #" .. tostring(i))
      gameObject.world:remove(gameObject)
      table.remove(gameObjects, i)
    else
      print("Skipped level object " .. tostring(i))
    end
    -- spawner:destroyGameObject(game_object, self.currentLevel)
  end
  self.changeLevel = false
end

function Level:update(dt)
  if self.changeLevel == true then
    self:destroyCurrentLevel()
    Game:loadLevel(self.nextLevel)
  end
end

function Level:first()
  local statics = [[
^####   ##^   ^##  ##  #^
^         ^   ^         ^
^         ^   ^         ^
^         ^   ^         ^
^      ## ^   ^         ^
^#        ^   ^         ^
^         ^   ^        #^
^         ^   ^         ^
^         ^   ^         ^
^###      ^   ^         ^
^         ^   ^         ^
^         ^   ^         ^
^         ^   ^         ^
^       ##^   ^         ^
^         ^   ^         ^
^         ^   ^         ^
^    ^#   ^   ^      #  ^
^    ^    ^   ^         ^
^    ^    ^   ^         ^
^   ##    ^   ^         ^
^         ^   ^         ^
^ *       ^   ^         ^
^         ^   ##  *     ^
]]

  -- TODO: Implement
  local kinetics -- = blah de dah, probably some blocks at certain locations?

  local tileSet = love.graphics.newImage('assets/countryside.png')

  local quadInfo = {
    {' ', 0, 0}, -- 1 grass
    {'#', 32, 0}, -- 2 box
    {'*', 0, 32}, -- 3 flowers
    {'^', 32, 32} -- boxtop
  }

  local playerX, playerY = 128, 64

  return statics, kinetics, tileset, quadInfo, playerX, playerY
end

function Level:second()
  local statics = [[
^#########^   ^#########^
^         ^   ^         ^
^         ^   ^         ^
^         ^   ^   *  #  ^
^         ^   ^         ^
^         ^   ^         ^
^                       ^
^         ^   ^        #^
^         ^   ^         ^
^   #     ^   ##    ##  ^
]]

  -- TODO: Implement
  local kinetics -- = blah de dah, probably some blocks at certain locations?

  local tileSet = love.graphics.newImage('assets/countryside.png')

  local quadInfo = {
    {' ', 0, 0}, -- 1 grass
    {'#', 32, 0}, -- 2 box
    {'*', 0, 32}, -- 3 flowers
    {'^', 32, 32} -- boxtop
  }

  local playerX, playerY = 128, 64

  return statics, kinetics, tileset, quadInfo, playerX, playerY
end

return Level

