DAMAGE_FORMULA = {
    aw: 1 -- attack weight
    dw: 1.2 -- defence weight
    bd: 15, -- base damage
    vm: 0.25 -- variance multiply
    va: 2 -- variance addition
}

export class BattlePlayer
    new: (@parent, @pos)=>
        @stats = {
            hp: 0,
            attack: 0,
            defence: 0,
            speed: 0,
            magic: 0
        }
        @buffs = {
            rally: false,
            poison: false
        }

    init: () =>
        @hp = @stats.hp

    takeDamage: (incomingattack) =>
        damage = math.floor(
            (DAMAGE_FORMULA.va+(DAMAGE_FORMULA.vm*((incomingattack*DAMAGE_FORMULA.aw)-(@stats.defence*DAMAGE_FORMULA.dw)))) * DAMAGE_FORMULA.bd
        )
        damage = 1 if damage < 1
        @hp -= damage
        print("I took " .. damage .. " damage ("..incomingattack.."ATK "..@stats.defence.."DEF)")
        if @hp < 0
            @hp = 0
        -- could spawn a floating number object here

    attack: (target, damageOverride) =>
        if damageOverride
            damage = damageOverride
        else
            damage = @stats.attack
        damage *= 
        target\takeDamage(damage)
        
    skillPrimaryInfo: () => return {
        name: "SKILLPRIMARY"
    }

    skillSecondaryInfo: () => return {
        name: "SKILLSECONDARY"
    }

    skillPrimary: () =>

    skillSecondary: () =>

    isValidTarget: (targetType) =>
        switch targetType
            when "attack"
                return @hp > 0
            when "move"
                return @parent.currentTurn != @
            when "always"
                return true
            else
                error("isValidTarget - Invalid target type - " .. targetType)

    getCursorPos: () =>
        return {
            x:@pos.x+0
            y:@pos.y-49
        }

    draw: () =>
        if @hp == 0
            @draw_dead!
        else
            @draw_alive!
            @draw_health!

    draw_health: () =>
        lg.printf(@hp, @pos.x+2, @pos.y, 20, "left")
        lg.printf(@stats.hp, @pos.x+2, @pos.y+12, 20, "right")

    draw_alive: (overwrite=false) =>
        lg.setColor(ORANGE) if overwrite
        lg.rectangle("fill", @pos.x, @pos.y-32, 24, 32)
        lg.setColor(BLACK)
        lg.rectangle("line", @pos.x, @pos.y-32, 24, 32)

    draw_dead: () =>
        lg.setColor(GRAY)
        lg.rectangle("fill", @pos.x, @pos.y-32, 24, 32)
        lg.setColor(BLACK)
        lg.rectangle("line", @pos.x, @pos.y-32, 24, 32)


export class Mage extends BattlePlayer
    new: (...) =>
        super ...
        @stats.hp = 50
        @stats.attack = 3
        @stats.defence = 2
        @stats.speed = 5
        @stats.magic = 10
        @init!

    draw_alive: () =>
        lg.setColor(MAGE_COL)
        super false

export class Fighter extends BattlePlayer
    new: (...) =>
        super ...
        @stats.hp = 50
        @stats.attack = 8
        @stats.defence = 4
        @stats.speed = 7
        @stats.magic = 2
        @init!
    
    -- Lunge - shoves forwards as far as you can, 
    -- dealing more damage with a bigger lunge
    skillPrimaryInfo: () => return {name:"LUNGE"}
    skillPrimary: () =>
        myindex = nil
        for i, player in pairs @parent.players
            myindex = i if player == @
        assert myindex != nil
        damage = @stats.attack * myindex / 2

        @parent.selectionCallback = (index) =>
            shovescene = CutsceneShove({tts:0, dir:-4})
            attackscene = CutsceneAttack({tts:6, index:index, damage:damage})
            @cutscenes\addCutscene(shovescene)
            @cutscenes\addCutscene(attackscene)
            @state\changeState(BattleTurnState, {ttl:30})
        @parent.state\changeState(BattleEnemySelectState)

    -- Rally - Gives all allies a minor speed and damage buff
    skillSecondaryInfo: () => return {name:"RALLY"}
    skillSecondary: () =>


    draw_alive: () =>
        lg.setColor(FIGHTER_COL)
        super false

export class Paladin extends BattlePlayer
    new: (...) =>
        super ...
        @stats.hp = 50
        @stats.attack = 5
        @stats.defence = 8
        @stats.speed = 3
        @stats.magic = 6
        @init!

    draw_alive: () =>
        lg.setColor(PALADIN_COL)
        super false

export class Rogue extends BattlePlayer
    new: (...) =>
        super ...
        @stats.hp = 50
        @stats.attack = 9
        @stats.defence = 2
        @stats.speed = 8
        @stats.magic = 2
        @init!

    draw_alive: () =>
        lg.setColor(ROGUE_COL)
        super false