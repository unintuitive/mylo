local Object = require 'lib.classic.classic'
local Map = Object:extend()

local lg = love.graphics

function Map:new(tileW, tileH, world, mapString, kinetics, tileset, quadInfo, levelNumber)
  self.tileW, self.tileH = tileW or 32, tileH or 32
  self.tileset = tileset or lg.newImage('assets/countryside.png')
  self.tilesetW, self.tilesetH = self.tileset:getWidth(), self.tileset:getHeight()
  self.world = world

  self.mapString = mapString
  self.quadInfo = quadInfo
  self.quads = {}
  self.mapTable = {}
  self.mapWidth = #(self.mapString:match('[^\n]+'))
  self.levelNumber = levelNumber
end

-- Process all quad and tileset data
function Map:build()
  -- Sets the number of columns of characters will exist in the table
  for x = 1, self.mapWidth, 1 do
    self.mapTable[x] = {}
  end

  -- Correlates the alphanumeric character found in the mapString to the location in pixels on the tileset.
  -- Assigns that mapping to a table that will be used to draw the level.
  for _, coord in ipairs(self.quadInfo) do
    self.quads[coord[1]] = lg.newQuad(coord[2], coord[3], self.tileW, self.tileH, self.tilesetW, self.tilesetH)
  end

  -- Loops by column and row, incrementing x and y coordinates by the tile width and height (32x32) along the way,
  -- adding a block to the world at those coordinates to match the character layout in the mapString.
  local rowIndex, columnIndex = 1, 1
  for row in self.mapString:gmatch('[^\n]+') do
    assert(#row == self.mapWidth, 'Grid is not aligned: width of row ' .. tostring(rowIndex) .. ' should be ' .. tostring(gridWidth) .. ', but it is ' .. tostring(#row))
    local columnIndex = 1
    local lastTile
    for character in row:gmatch(".") do
      self.mapTable[columnIndex][rowIndex] = character
      local x = (columnIndex - 1) * self.tileW
      local y = (rowIndex - 1) * self.tileH
      local w, h = self.tileW, self.tileH

      self:addTileToWorld(character, x, y, w, h)
      columnIndex = columnIndex + 1
      lastTile = character
    end
    rowIndex = rowIndex + 1
  end
end

-- Adds the appropriate game object type given the character of the mapString
function Map:addTileToWorld(character, x, y, w, h)
  local tile
  if character == '^' or character == '#' then
    spawner:createGameObject('Block', {world = self.world, playerX = x, playerY = y, w = w, h = h, level = self.levelNumber})
  elseif character == '*' then
    spawner:createGameObject('Goal', {world = self.world, x = x, y = y, w = w, h = h, level = self.levelNumber})
  end
end

-- TODO: Must be able to place a kinetic entity instance at given position coordinates
function Map:addKineticToWorld()
  --
end

-- Draws the tileset quads at the same coordinates where the blocks were added to the world.
function Map:draw(tileset )
  lg.setColor(200, 200, 200)
  for columnIndex, column in ipairs(self.mapTable) do
    for rowIndex, char in ipairs(column) do
      local x, y = (columnIndex - 1) * self.tileW, (rowIndex - 1) * self.tileH
      lg.draw(self.tileset, self.quads[char], x, y)
    end
  end
end

return Map
