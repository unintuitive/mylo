local Object = require 'lib.classic.classic'
local Utils = require 'mixins.utils'
local Physics = Object:extend()

function Physics:new(parent, world, x, y, w, h, acceleration, damping)
  self.parent = parent
  self.world = world
  self.x, self.y = x, y
  self.w, self.h = w, h
  self.world:add(self.parent, self.x, self.y, self.w, self.h)

  self.acceleration = acceleration
  self.damping = damping
  self.position = Vector(self.x, self.y)
  self.velocity = Vector(0, 0)

  self.teleportX, self.teleportY = nil, nil

  self.gravity = 2600
end

function Physics:applyAcceleration(dt)
  self.velocity = Vector(self.velocity.x + self.acceleration * dt, self.velocity.y + self.acceleration * dt)
end

function Physics:applyVelocityDirection(dt, direction)
  if direction == 'up' then
    self.velocity.y = self.velocity.y - self.acceleration * dt
  elseif direction == 'down' then
    self.velocity.y = self.velocity.y + self.acceleration * dt
  elseif direction == 'left' then
    self.velocity.x = self.velocity.x - self.acceleration * dt
  elseif direction == 'right' then
    self.velocity.x = self.velocity.x + self.acceleration * dt
  end
end

function Physics:applyDamping(dt)
  self.velocity = self.velocity / (1 + self.damping * 1.3 * dt)
end

function Physics:applyVelocity(dt)
  self.position = self.position + self.velocity * dt
end

function Physics:applyGravity(dt)
  self.velocity.y = self.velocity.y + self.gravity * dt
  if self.velocity.y > self.gravity then -- Prevents warp speed falls!
    self.velocity.y = self.gravity
  end
end

function Physics:applyDirection(dt, goal)
  local goalDirection = (goal.body.position - self.position):normalized()

  -- Tweak the magnitude (and thus overall velocity) of the goalDirection here
  self.velocity = self.velocity + (goalDirection * 10)
end

-- Requires a callback function from the parent entity
function Physics:moveInWorld(dt, callback)
  local world = self.world

  -- The goal_x and y is the position that the Player intends to travel towards based on keydowns
  local goal = self.position + self.velocity * dt

  -- Move the object in the Bump world and handle collisions. Refer to parent entity to see filter definition.
  local actualX, actualY, collisions, collisionLength = world:move(self.parent, goal.x, goal.y, self.parent.filter)

  -- If a collision is detected, call back to the injected function to resolve
  for i = 1, collisionLength do
    local col = collisions[i]
    callback(self, col)
  end

  self.position = Vector(actualX, actualY)
end

function Physics:applyTeleportation(position)
  -- local world = self.world
  local teleportDestination = position
  print("Begin teleportation of " .. tostring(self.parent.name) .. " to " .. tostring(teleportDestination.x) .. " " .. tostring(teleportDestination.y))

  local actualX, actualY, collisions, collisionLength = world:check(self.parent, teleportDestination.x, teleportDestination.y)

  print("Actual xy destination " .. tostring(actualX) .. " " .. tostring(actualY))

  world:update(self.parent, actualX, actualY)
  print("World updated with new player location")
  self.position.x, self.position.y = actualX, actualY
  print("Teleported position " .. tostring(self.position.x) .. " " .. tostring(self.position.y))
end

function Physics:jump(jumpVelocity, jumpTerm)
  if self.inAir == false and self.velocity.y > 0 then
    self.grounded = false
    self.inAir = true

    self.velocity.y = self.velocity.y - jumpVelocity
  end
end

function Physics:releaseJump()
    self.inAir = false
    if self.parent.body.velocity.y < 0 then
      self.parent.body.velocity.y = 0
    end
end

function Physics:getX() return self.position.x end
function Physics:getY() return self.position.y end

function Physics:getW() return self.w end
function Physics:getH() return self.h end

return Physics
