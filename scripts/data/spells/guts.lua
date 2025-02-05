local Guts, super = Class(Spell)
function Guts:init()
    super.init(self)
    self. name = "GUTS"
     self.cast_name = "[style:dark][color:red]GUTS UP[style:none][color:reset]"
	self.effect = "ATK up"
    self.description = "Increases ally AT in battle."
    self.cost = 50
    self.tags = {"buff"}
    self.target = "ally"
end

function Guts:onCast(user, target)
    target.chara:addStatBuff("attack", 2, 3)
    Assets.playSound("boost")
    
        Game.battle:addChild(DamageNumber("msg", "guts", target.x + 4, target.y - 80 - 0, {self.getColor}))
    return "guts"
end

return Guts