---@class EnemyBattler
local EnemyBattler, super = Class("EnemyBattler", true)

function EnemyBattler:init(...)
    super.init(self, ...)
    self.burned = false
    self.burners = {}
    self.burners_turns = {}
end

function EnemyBattler:onTurnStart(...)
    super.onTurnStart(self, ...)
    self.burned = #self.burners > 0
    if self.burned then
        for i,v in pairs(self.burners or {}) do
            self:burnFlash()
            self:hurt(v.chara:getStat("attack")+15, v)
            self.burners_turns[i] = self.burners_turns[i] - 1
            if (self.burners_turns[i] or 0) <= 0 then table.remove(self.burners, i) table.remove(self.burners_turns, i) end
            if #Game.battle:getActiveEnemies() <= 0 then Game.battle:setState("VICTORY") end
        end
    end
end

function EnemyBattler:addBurn(battler, turns)
    local already = false
    for i,v in pairs(self.burners) do
        if v.chara.id == battler.chara.id then
            already = true
        end
    end
    if not already then
        table.insert(self.burners, battler)
        table.insert(self.burners_turns, turns or 5)
    end
end

function EnemyBattler:burnFlash()
    local spare_flash = self:addFX(ColorMaskFX())
    spare_flash.color = {1,0.5,0}
    spare_flash.amount = 0.50

    Game.battle.timer:during(2, function()
        spare_flash.amount = spare_flash.amount - 0.02
    end, function() self:removeFX(spare_flash) end)
end

return EnemyBattler