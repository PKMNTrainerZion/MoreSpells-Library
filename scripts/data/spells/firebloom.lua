local FireBloom, super = Class(Spell)

function FireBloom:init()
    super.init(self)

    -- Display name
    self.name = "FireBloom"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    self.effect = "Damage\nw/ FIRE"
    -- Menu description
    self.description = "Deals magical FIRE damage to\none enemy."

    -- TP cost
    self.cost = 50

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    -- Tags that apply to this spell
    self.tags = {"fire", "damage"}
end

function FireBloom:getTPCost(chara)
    local cost = super.getTPCost(self, chara)
    if chara and chara:checkWeapon("thornring") then
        cost = Utils.round(cost / 2)
    end
    return cost
end

function FireBloom:onCast(user, target)

    local function createParticle(x, y)
        local sprite = Sprite("effects/firespell/fireball", x, y)
        sprite:setOrigin(0.5, 0.5)
        sprite:setScale(0.6)
        sprite.layer = BATTLE_LAYERS["above_battlers"]
        Game.battle:addChild(sprite)
        return sprite
    end

    local x, y = target:getRelativePos(target.width/2, target.height/2, Game.battle)

    local particles = {}
    Game.battle.timer:script(function(wait)
        wait(1/30)
        Assets.playSound("icespell")
        particles[1] = createParticle(x+75, y)
        wait(1/30)
        particles[2] = createParticle(x+60, y)
        wait(1/30)
        particles[3] = createParticle(x+45, y)
        wait(1/30)
        particles[4] = createParticle(x+30, y)
        wait(1/30)
        particles[5] = createParticle(x+15, y)
        wait(1/30)
        particles[6] = createParticle(x, y)
        wait(1/30)
        particles[7] = createParticle(x-15, y)
        wait(1/30)
        particles[8] = createParticle(x-30, y)
        wait(1/30)
        particles[9] = createParticle(x-45, y)
        wait(1/30)
        particles[10] = createParticle(x-60, y)
        wait(1/30)
        particles[11] = createParticle(x-75, y)
        wait(1/30)
        Game.battle:addChild(FireSpellBurst(x, y))
        for _,particle in ipairs(particles) do
            for i = 0, 8 do
                local effect = FireSpellEffect(particle.x, particle.y)
                effect:setScale(0.1)
                effect.physics.direction = math.rad(20 * i)
                effect.physics.speed = 10
                effect.physics.friction = 0.2
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

        Game.battle:finishActionBy(user)
    end)

    return false
end

function FireBloom:getDamage(user, target)
    local damage = math.ceil((user.chara:getStat("magic") * 20))

    return damage
end

return FireBloom