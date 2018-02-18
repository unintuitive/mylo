local Player = Entity:extend()
local Utils = require 'mixins.utils'
local Controls = require 'mixins.controls'
local Physics = require 'mixins.physics'

-- Mixins
Player:implement(Utils)
Player:implement(Controls)
Player:implement(Physics)

function Player:new(type, options)
  local options = options or {}
  for key, value in pairs(options) do
    self[key] = value
  end
  Entity.new(self, options)

  -- Player settings
  self.name = type
  self.dead = false
  self.maxHealth = 100
  self.health = 100

  -- Weapon settings
  self.heat = 0
  self.rateOfFire = 0.525 -- lower is faster
  self.teleportTimer = 0
  self.teleportCharge = 2
  self.teleporting = false

  -- Jumping physics settings
  self.maxJumpHeight = 32*12 -- number of tiles high
  self.minJumpHeight = 32*1 -- number of tiles high
  self.timeToApex = 0.4
  self.jumpVelocity = math.sqrt(2*2400*self.maxJumpHeight)
  self.jumpTerm = 600

  -- General physics settings
  self.position = Vector(self.x, self.y)
  self.velocity = Vector(0, 0)
  self.acceleration = 1500
  self.damping = 10.5
  self.body = Physics(self, self.world, self.x, self.y, self.w, self.h, self.acceleration, self.friction)
end

function Player:filter(other)
  if other.name == 'Slug' or other.name == 'Goal' then
    return 'cross'
  elseif other.name == 'Block' then
    return 'slide'
  end
end

function Player:navigate(dt)
  if Controls:keyDown('a') then
    self.body:applyVelocityDirection(dt, 'left')
  elseif Controls:keyDown(('d')) then
    self.body:applyVelocityDirection(dt, 'right')
  end
end

-- Mouse aiming
function Player:target(dt)
  -- The player can only shoot until the cannon's heat gets too high, after which he must wait for it to "cool down"
  if self.heat > 0 then
    self.heat = self.heat - dt
  end

  if Controls:mouseDown(1) then
    if self.heat <= 0 then
      self:shootSlug()
    end
    self.heat = self.rateOfFire
  end
end

function Player:teleport(dt)
  -- As with cannon heat, the player can only teleport once the charge time is reached
  if self.teleportTimer > 0 then
    self.teleportTimer = self.teleportTimer - dt
  end

  if Controls:mouseDown(2) then
    if self.teleportTimer <= 0 then
      if self.firedSlug then
        if self.firedSlug.dead ~= true then
          print("Before teleport")
          self.teleporting = true
          local slugPosition = self.firedSlug.body.position
          print("Teleporting to " .. tostring(slugPosition))
          self.body:applyTeleportation(slugPosition, self.teleporting)
          print("After teleport")
          print("New location " .. tostring(self.body:getX()) .. " " .. tostring(self.body:getY()))
        end
      end
    end
    self.teleportTimer = self.teleportCharge
    self.teleporting = false
  end
end

function Player:shootSlug()
  self.firedSlug = false
  local mouseTarget = nil
  local mx, my = Controls:mousePosition()
  mouseTarget = Vector(mx, my)
  self.firedSlug = spawner:createGameObject('Slug', {world = self.world, origin = self.body.position, startingVelocity = self.velocity, target = mouseTarget, w = 12, h = 12 })
end

function Player:update(dt)
  self:navigate(dt)
  self.body:applyGravity(dt)
  self.body:applyVelocity(dt)
  self.body:applyDamping(dt)
  self.body:moveInWorld(dt, self.collisionResponse) -- Callback to collisionResponse
  self:teleport(dt)
  self:target(dt)
  print(tostring(self.body:getX()) .. " " .. tostring(self.body:getY()))
end

function Player:checkGrounded(normalY)
  if normalY < 0 then
    self.grounded = true
  end
end

function Player:collisionResponse(collision)
  if collision.other.name == "Block" then
    collision.item:checkGrounded(collision.normal.y)
  elseif collision.other.name == "Enemy" then
    -- if self.health <= 0 then
      -- self:die()
    -- else
    -- end
  elseif collision.other.name == "Goal" then
    -- self:heal(200)
    print('Player hit goal!!!')
    -- TODO: Unclear if this is the right place for this
    Game:changeLevel()
  end
end

function Player:draw()
  self:drawBox(self.body:getX(), self.body:getY(), self.body:getW(), self.body:getH(), 0, 255, 0)
end

return Player
