local YellowBuster, super = Class(Spell)

function YellowBuster:init()
    super.init(self)

    -- Display name
    self.name = "Yellowburst"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    self.effect = "Hits ALL\nenemies"
    -- Menu description
    self.description = "Uses advanced RUDE damage to hit\nall enemies in battle."

    -- TP cost
    self.cost = 100

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemies"

    -- Tags that apply to this spell
    self.tags = {"yellow", "damage"}
end

function YellowBuster:getCastMessage(user, target)
    return "* "..user.chara:getName().." used "..self:getCastName().."!"
end

function YellowBuster:getTPCost(chara)
    local cost = super.getTPCost(self, chara)
    if chara and chara:checkWeapon("devilsknife") then
        cost = cost - 10
    end
    return cost
end

function YellowBuster:onCast(user, target)
        local count = 0
        for _,enemy in ipairs(target) do
            if enemy.done_state == nil then
                local success = enemy.tired
    
                if success then
                    enemy.done_state = "PACIFIED"
                end

    local buster_finished = false
    local anim_finished = false
    local function finishAnim()
        anim_finished = true
        if buster_finished then
            Game.battle:finishAction()
        end
    end
    if not user:setAnimation("battle/attack", finishAnim) then
        anim_finished = false
        user:setAnimation("battle/rude_buster", finishAnim)
    end
    Game.battle.timer:after(0.01, function()
        Assets.playSound("rudebuster_swing")
        local ux, uy = user:getRelativePos(user.width, user.height/2 - 10, Game.battle)
        local x, y = enemy:getRelativePos(enemy.width/2, enemy.height/2)
        local blast = YellowBusterBeam(false, ux, uy, x, y, function(pressed)
            local damage = self:getDamage(user, target, pressed)
            if pressed then
                Assets.playSound("scytheburst")
            end
            enemy:flash()
            enemy:hurt(damage, user)
            buster_finished = true
            if anim_finished then
                Game.battle:finishAction()
            end
        end)
        blast.layer = BATTLE_LAYERS["above_ui"]
        Game.battle:addChild(blast)
    end)
end
end
    return false
end

function YellowBuster:getDamage(user, enemy, pressed)
    local damage = math.ceil((user.chara:getStat("magic") * 5) + (user.chara:getStat("attack") * 11 + 2))
    if pressed then
        damage = damage + 40
    end
    return damage
end

return YellowBuster