local Goal = Entity:extend()
local Utils = require 'mixins.utils'
local Physics = require 'mixins.physics'

Goal:implement(Utils)
Goal:implement(Physics)

function Goal:new(type, options)
  local options = options or {}
  for key, value in pairs(options) do
    self[key] = value
  end
  Entity.new(self, options)

  -- Goal settings
  self.name = type

  -- Physics settings
  self.startPosition = Vector(self.x, self.y)
  self.x, self.y = self.startPosition:unpack()
  self.damping = 5
  self.body = Physics(self, self.world, self.startPosition.x, self.startPosition.y, self.w, self.h, 0, 0)
end

function Goal:update(dt)
  self.body:applyDamping(dt)
  self.body:applyVelocity(dt)
  if self.dead ~= true then
    self.body:moveInWorld(dt, self.collisionResponse) -- Callback to collisionResponse
  end
end

-- Drawing disabled
function Goal:draw()
  -- self:drawBox(self.x, self.y, self.w, self.h, 255, 255, 255)
end

function Goal:collisionResponse(collision)
  print("Goal collided with " .. tostring(collision.other.name))
  if collision.other.name == 'Player' then
    print("Goal collision response removing " .. tostring(collision.item.name))
    collision.item.dead = true
  end
end

return Goal
