local Slug = Entity:extend()
local Utils = require 'mixins.utils'
local Physics = require 'mixins.physics'

Slug:implement(Utils)
Slug:implement(Physics)

function Slug:new(type, options)
  local options = options or {}
  for key, value in pairs(options) do
    self[key] = value
  end
  Entity.new(self, options)

  self.name = type

  self.dead = false
  self.lifetime = 2.5 -- 1.5 second

  self.position = self.origin
  self.x, self.y = self.position:unpack()

  -- Physics settings
  if self.startingVelocity ~= nil then
    self.velocity = self.startingVelocity
  else
    self.velocity = Vector(0, 0)
  end
  self.speed = 900
  self.damping = 20.5
  self.body = Physics(self, self.world, self.x, self.y, self.w, self.h, 0, 0)
  -- Set slug's velocity and direction based on player position and mouse target
  self.body.velocity = (self.target - self.body.position):normalized() * self.speed
end

function Slug:update(dt)
  self.lifetime = self.lifetime - dt

  if self.lifetime <= 0 then
    self.dead = true
  end

  self.body:applyGravity(dt)
  self.body:applyVelocity(dt)
  self.body:applyDamping(dt)
  self.body:moveInWorld(dt, self.collisionResponse) -- Callback to collisionResponse
end

-- Used by Physics module to handle collisions differently upon initial contact
function Slug:filter(other)
  if other.name == 'Player' then
    return 'cross'
  elseif other.name == 'Block' then
    return 'touch'
  end
end

-- Used by Physics module to determine what happens after a collision takes place
function Slug:collisionResponse(collision)
  if collision.other.name == 'Block' then
    -- print('boing')
  elseif collision.other.name == 'Player' then
    -- print('Slug collided with Player')
  end
end

function Slug:draw()
  self:drawBox(self.body:getX(), self.body:getY(), self.w, self.h, 255, 255, 255)
end

return Slug
