local frostburn, super = Class(Spell)

function frostburn:init()
    super.init(self)

    -- Display name
    self.name = "FrostBurn"
    -- Name displayed when cast (optional)
    self.cast_name = nil

    -- Battle description
    self.effect = "DMG and\nBURN foe"
    -- Menu description
    self.description = "Deals magical ICE damage and\nBURNS one enemy."

    -- TP cost
    self.cost = 40

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    -- Tags that apply to this spell
    self.tags = {"ice", "burn", "damage"}
end

function frostburn:getTPCost(chara)
    local cost = super.getTPCost(self, chara)
    if chara and chara:checkWeapon("thornring") then
        cost = Utils.round(cost / 2)
    end
    return cost
end

function frostburn:onCast(user, target)
    user.chara:addFlag("iceshocks_used", 1)

    local function createParticle(x, y)
        local sprite = Sprite("effects/icespell/snowflake", x, y)
        sprite:setOrigin(0.5, 0.5)
        sprite:setScale(0.75)
        sprite.layer = BATTLE_LAYERS["above_battlers"]
        Game.battle:addChild(sprite)
        return sprite
    end

    local x, y = target:getRelativePos(target.width/2, target.height/2, Game.battle)

    local particles = {}
    Game.battle.timer:script(function(wait)
        wait(1/30)
        Assets.playSound("icespell")
        particles[1] = createParticle(x-35, y-30)
        wait(1/30)
        particles[2] = createParticle(x-25, y-20)
        wait(1/30)
        particles[3] = createParticle(x-15, y-10)
        wait(1/30)
        particles[4] = createParticle(x-5, y)
        wait(1/30)
        particles[5] = createParticle(x+5, y)
        wait(1/30)
        particles[6] = createParticle(x+15, y+10)
        wait(1/30)
        particles[7] = createParticle(x+25, y+20)
        wait(1/30)
        particles[8] = createParticle(x+35, y+30)
        wait(1/30)
        Game.battle:addChild(IceSpellBurst(x, y))
        for _,particle in ipairs(particles) do
            for i = 0, 8 do
                local effect = IceSpellEffect(particle.x, particle.y)
                effect:setScale(0.4)
                effect.physics.direction = math.rad(30 * i)
                effect.physics.speed = 8
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
        target:addBurn(user)
        target:burnFlash()

                Game.battle:addChild(DamageNumber("msg", "burn", target.x + 4, target.y - 80 - 0, {self.getColor}))

        Game.battle:finishActionBy(user)

        return "burn"
    end)

    return false
end


function frostburn:getDamage(user, target)
    local min_magic = Utils.clamp(user.chara:getStat("magic") - 10, 1, 999)

    return math.ceil((min_magic * 12) + 15 + Utils.random(12))
end

return frostburn