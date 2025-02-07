local Symbiosis, super = Class(Spell)
function Symbiosis:init()
    super.init(self)

    self.name = "SYMBIOSIS"

    self.cast_name = "[style:dark][color:gray]SYMBIOSIS[style:none][color:reset]"

    self.description = "Using the power of your SOUL, increase ATK and DEF.\nAccessible in the ACT menu."
    
    self.cost = 75

    self.tags = {"buff"}

	self.effect = "ATK &\nDEF up"

end

function Symbiosis:getCastMessage(user, target)
    return "YOU used SYMBIOSIS!\nATK is now "..user.chara:getStat("attack").."!\nDEF is now "..user.chara:getStat("defense").."!"
end

function Symbiosis:onCast(user, target)
    
    Assets.playSound("him_quick", 0.7)
    user.chara:addStatBuff("attack", 3)
    user.chara:addStatBuff("defense", 1)
end

return Symbiosis