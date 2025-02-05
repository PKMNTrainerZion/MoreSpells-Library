---@class FireSpellBurst : Object
---@overload fun(...) : FireSpellBurst
local FireSpellBurst, super = Class(Object)

function FireSpellBurst:init(x, y)
    super.init(self, x, y)

    self.alpha = 1.2
    self:fadeOutSpeedAndRemove(0.1)

    self.layer = BATTLE_LAYERS["above_battlers"] + 1

    self.timer = 0
end

function FireSpellBurst:update()
    self.timer = self.timer + DTMULT

    super.update(self)
end

function FireSpellBurst:draw()
    love.graphics.setLineWidth(3)
    love.graphics.circle("line", 0, 0, 61 - ((self.timer + 10) * 6), 32)

    super.draw(self)
end

return FireSpellBurst