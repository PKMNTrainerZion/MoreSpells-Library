local AngelPrayer, super = Class(Spell)

function AngelPrayer:init()
    super.init(self)

    -- Display name
    self.name = "AngelPrayer"
    -- Name displayed when cast (optional)
    self.cast_name = "ANGEL'S PRAYER"

    -- Battle description
    self.effect = "Damage\nand heal"
    -- Menu description
    self.description = nil

    -- TP cost
    self.cost = 85

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    -- Tags that apply to this spell
    self.tags = {"damage", "healing"}
end

function AngelPrayer:onCast(user, target)

    local function createParticle(x, y)
        local sprite = Sprite("effects/firespell/fireball", x, y)
        sprite:setOrigin(0.5, 0.5)
        sprite:setScale(0.5)
        sprite.layer = BATTLE_LAYERS["above_battlers"]
        Game.battle:addChild(sprite)
        return sprite
    end

    local x, y = target:getRelativePos(target.width/2, target.height/2, Game.battle)

    local particles = {}
    Game.battle.timer:script(function(wait)
        wait(1/30)
        Assets.playSound("firespell")
        particles[1] = createParticle(x, y-10)
        wait(3/30)
 particles[2] = createParticle(x-10, y)
        wait(3/30)
 particles[3] = createParticle(x+10, y)
        wait(3/30)
        wait(3/30)
        Game.battle:addChild(FireSpellBurst(x, y))
        for _,particle in ipairs(particles) do
            for i = 0, 8 do
                local effect = FireSpellEffect(particle.x, particle.y)
                effect:setScale(0.35)
                effect.physics.direction = math.rad(72 * i)
                effect.physics.speed = 7.8
                effect.physics.friction = 0.8
                effect.layer = BATTLE_LAYERS["above_battlers"] - 1
                Game.battle:addChild(effect)
            end
        end
        wait(1/30)
        for _,particle in ipairs(particles) do
            particle:remove()
        end
        wait(4/30)

        local damage = self:getDamage(user, target)
        target:hurt(damage, user)
user:heal(user.chara:getStat("magic") * 4)
 end)

return true

end

function AngelPrayer:getDamage(user, target)
    local damage = math.ceil((user.chara:getStat("attack") * 7))
    return damage
end



return AngelPrayer