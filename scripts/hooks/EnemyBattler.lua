---@class EnemyBattler : EnemyBattler
local EnemyBattler, super = Class("EnemyBattler")

function EnemyBattler:onAct(battler, name)
    if Kristal.getLibConfig("morespells", "global_poweracts") then
        if name == "Symbiosis" then
            Game.battle:powerAct("symbiosis_dw", battler, battler.chara.id, self)
            return
        end
    end
    return super.onAct(self, battler, name)
end

return EnemyBattler