-- Mylo Escapes the System
-- Pre-alpha construction phase began 20160214

-- 3rd Party Libraries
Object = require 'lib.classic.classic'
Bump = require 'lib.bump.bump'
BumpDebug = require 'lib.bump.bump_debug'
Vector = require 'lib.hump.vector'
Camera = require 'lib.hump.camera'
Gamestate = require 'lib.hump.gamestate'
Lume = require 'lib.lume.lume'

-- Entities
Entity = require 'entities.entity'
Player = require 'entities.player'
Enemy = require 'entities.enemy'
Slug = require 'entities.slug'
Block = require 'entities.block'
Goal = require 'entities.goal'

-- Local libraries
Spawner = require 'world.spawner'
Utils = require 'mixins.utils'
AI = require 'mixins.ai'
Map = require 'world.map'
Level = require 'world.level'

-- States
require 'states.game'

function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(Game)
end

function love.update(dt)

end

function love.draw()

end

function love.keypressed(k)

end

function love.keyreleased(k)

end
