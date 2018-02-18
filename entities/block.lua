local Block = Entity:extend()
local Utils = require 'mixins.utils'
local Physics = require 'mixins.physics'

Block:implement(Utils)
Block:implement(Physics)

function Block:new(type, options)
  local options = options or {}
  for key, value in pairs(options) do
    self[key] = value
  end
  Entity.new(self, options)

  -- Block settings
  self.name = type

  -- Physics settings
  self.startPosition = Vector(self.playerX, self.playerY)
  self.x, self.y = self.startPosition:unpack()
  self.damping = 5
  self.body = Physics(self, self.world, self.startPosition.x, self.startPosition.y, self.w, self.h, 0, 0)
end

function Block:update(dt)
  self.body:applyDamping(dt)
  self.body:applyVelocity(dt)
  self.body:moveInWorld(dt, self.collisionResponse) -- Callback to collisionResponse
end

-- Drawing disabled
function Block:draw()
  -- self:drawBox(self.x, self.y, self.w, self.h, 255, 255, 255)
end

function Block:collisionResponse(collision)
  if collision.other.name == 'Player' then
    -- print('Player hit me!')
  end
end

return Block
