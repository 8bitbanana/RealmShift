DAMAGE_FORMULA = {
    aw: 1 -- attack weight
    dw: 1.05 -- defence weight
    bd: 15, -- base damage
    vm: 0.25 -- variance multiply
    va: 2 -- variance addition
}

export class BattlePlayer
    new: ()=>
        @stats = {
            hp: 0,
            attack: 0,
            defence: 0,
            speed: 0,
            magic: 0
        }
        @pos = {  -- This position will be the bottom-left of the sprite
            x: 0, -- This is to accommadate for sprites of different sizes
            y: 0  -- e.g. enemies so that the position doesn't have to change
        }

    init: () =>
        @hp = @stats.hp

    takeDamage: (incomingattack) =>
        damage = math.floor(
            (DAMAGE_FORMULA.va+(DAMAGE_FORMULA.vm*((incomingattack*DAMAGE_FORMULA.aw)-(@stats.defence*DAMAGE_FORMULA.dw)))) * DAMAGE_FORMULA.bd
        )
        damage = 1 if damage < 1
        @hp -= damage
        if @hp < 0
            @hp = 0
            -- we dead
        -- could spawn a floating number object here

    attack: (target) =>
        target\takeDamage(@stats.attack)
        
    skillPrimary: (target) =>

    skillSecondary: (target) =>


    draw: (overwrite=true) =>
        lg.setColor(ORANGE) if overwrite
        lg.rectangle("fill", @pos.x, @pos.y-32, 24, 32)
        lg.setColor(BLACK)
        lg.rectangle("line", @pos.x, @pos.y-32, 24, 32)

export class Mage extends BattlePlayer
    new: () =>
        super!
        @stats.hp = 50
        @stats.attack = 3
        @stats.defence = 2
        @stats.speed = 5
        @stats.magic = 10
        @init!

    draw: () =>
        super!
        lg.setColor(BLACK)
        lg.print("M", @pos.x, @pos.y)

export class Fighter extends BattlePlayer
    new: () =>
        super!
        @stats.hp = 50
        @stats.attack = 8
        @stats.defence = 4
        @stats.speed = 7
        @stats.magic = 2
        @init!

    draw: () =>
        super!
        lg.setColor(BLACK)
        lg.print("F", @pos.x, @pos.y)

export class Paladin extends BattlePlayer
    new: () =>
        super!
        @stats.hp = 50
        @stats.attack = 5
        @stats.defence = 8
        @stats.speed = 3
        @stats.magic = 6
        @init!

    draw: () =>
        super!
        lg.setColor(BLACK)
        lg.print("P", @pos.x, @pos.y)

export class Rogue extends BattlePlayer
    new: () =>
        super!
        @stats.hp = 50
        @stats.attack = 9
        @stats.defence = 2
        @stats.speed = 8
        @stats.magic = 2
        @init!

    draw: () =>
        super!
        lg.setColor(BLACK)
        lg.print("R", @pos.x, @pos.y)