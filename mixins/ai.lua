local Object = require 'lib.classic.classic'
local Utils = require 'mixins.utils'
local AI = Object:extend()

function AI:new(parent)
  self.parent = parent
end

function AI:applyDirection(dt, goal)
  local goalDirection = (goal.body.position - self.parent.position):normalized()

  -- Tweak the magnitude (and thus overall velocity) of the quarryDirection here
  self.parent.body.velocity = self.parent.body.velocity + (goalDirection * 10)
end

-- Enemy shoots at the player when the player comes in range
function AI:rangedAttack(dt)
  local enemyCenter = Vector(Utils:getCenter(self.parent:getX(), self.parent.body:getY(), self.parent.body:getW(), self.parent.body:getH()))
  local playerCenter = Vector(Utils:getCenter(player.body:getX(), player.body:getY(), player.body:getW(), player.body:getH()))
  local distance = enemyCenter:dist(playerCenter)

  if self.parent.heat <= 0 then
    if distance <= self.parent.attackRange then
      -- self:shootBullet(self.position)
      print("Shoot!")
      self.parent.heat = self.parent.rateOfFire
    end
  end

  if self.parent.heat > 0 then
    self.parent.heat = self.parent.heat - dt
  end
end

return AI
