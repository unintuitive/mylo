local Object = require 'lib.classic.classic'
local Utils = Object:extend()

-- Draw a semi-transparent rectangle with a solid outline
function Utils:drawBox(x, y, w, h, r, g, b)
  love.graphics.setColor(r,g,b,70) -- 70 percent opaque
  love.graphics.rectangle("fill", x, y, w, h)
  love.graphics.setColor(r,g,b)
  love.graphics.rectangle("line", x, y, w, h)
end

function Utils:drawTrail(oldX, oldY, x, y)
  love.graphics.setColor(255,255,255) -- 70 percent opaque
  love.graphics.line(oldX, oldY, x, y)
end

function Utils:drawSlug(x, y, radius, r, g, b)
  love.graphics.setColor(r, g, b, 70)
  love.graphics.circle('fill', x, y, radius, 100)
  love.graphics.setColor(r, g, b)
  love.graphics.circle('line', x, y, radius, 100)
end

function Utils:createGameObject(type, options)
  local game_object = _G[type](type, options)
  table.insert(game_objects, game_object)
  return game_object
end

function Utils:debug(class, inputVariable)
  print("[Debug] " .. tostring(class) .. ": " .. tostring(inputVariable))
end

function Utils:normalize(x, y)
  local length = math.sqrt((x * x) + (y * y))
  local xComponent = x / length
  local yComponent = y / length
  return x, y
end

function Utils:targetDistance(quarryX, quarryY, quarryW, quarryH, hunterX, hunterY, hunterW, hunterH)
  local dx = (quarryX + quarryW * 0.5) - (hunterX + hunterW * 0.5)
  local dy = (quarryY + quarryH * 0.5) - (hunterY + hunterH * 0.5)
  return math.sqrt(dx * dx + dy * dy)
end

function Utils:getCenter(x, y, w, h)
  return x + w / 2, y + h / 2
end

return Utils
