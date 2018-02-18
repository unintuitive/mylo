local Entity = Object:extend()

function Entity:new(type, options)
  -- Allow for arbitrary entity attributes by assigning a key/value pair
  -- when instantiating new Entity
  local options = options or {}
  for key, value in pairs(options) do
    self[key] = value
  end

  self.dead = false
  self.friction = damping or 5
  self.world = world
end

function Entity:update(dt)
  --
end

function Entity:draw()
  --
end

function Entity:die()
  print("Entity removed: " .. tostring(self))
  self.world:remove(self)
end

function Entity:collisionResponse(collision)
  -- This space intentionally left blank
end

return Entity
