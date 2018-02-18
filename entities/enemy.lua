local Enemy = Entity:extend()
local Utils = require 'mixins.utils'
local Physics = require 'mixins.physics'
local AI = require 'mixins.ai'

-- Mixins
Enemy:implement(Utils)
Enemy:implement(Physics)
Enemy:implement(AI)

function Enemy:new(type, options)
  local options = options or {}
  for key, value in pairs(options) do
    self[key] = value
  end
  self.name = type
  Entity.new(self, options)

  self.position = Vector(self.playerX, self.playerY)

  -- self.maxHealth = 100
  -- self.health = 100
  self.dead = false
  self.damping = 4 -- overriding the Entity friction of 5

  -- Physics settings
  self.acceleration = 1500
  self.friction = 0
  self.body = Physics(self, self.world, self.position.x, self.position.y, self.w, self.h, self.acceleration, self.damping)

  self.attackRange = 300
  self.rateOfFire = 1.5
  self.heat = 0

  self.ai = AI(self)
end

function Enemy:update(dt)
  self.body:applyDamping(dt)
  self.body:applyVelocity(dt)
  -- TODO: Try getting this into AI
  self.body:applyDirection(dt, player)
  self.body:moveInWorld(dt, self.collisionResponse) -- Callback to collisionResponse
  self.ai:rangedAttack(dt)
end

function Enemy:collisionResponse(collision)
  if collision.other.name == "Block" then
    -- print("hit by block")
  elseif collision.other.name == "Enemy" then
    -- TODO: Try getting this into AI
    local awayDirection = (self.position - collision.other.body.position):normalized()
    self.velocity = self.velocity + (awayDirection * 50)
  elseif collision.other.name == "Goal" then
      -- self:heal(200)
  end
end

function Enemy:avoidEnemies()
end

function Enemy:draw()
  self:drawBox(self.body:getX(), self.body:getY(), self.body.w, self.body.h, 255, 0, 0)

  -- Attack range debug setting
  if shouldDrawDebug then
    love.graphics.circle("line", self.body:getX() + self.body:getW()/2, self.body:getY() + self.body:getH()/2, 300, 70)
  end
end

return Enemy
