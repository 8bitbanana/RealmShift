DAMAGE_FORMULA = {
    aw: 1 -- attack weight
    dw: 1.2 -- defence weight
    bd: 5, -- base damage
    vm: 0.25 -- variance multiply
    va: 2 -- variance addition
}

Inspect = require("lib/inspect")

export class BattlePlayer
    new: (@parent, @pos)=>
        @basestats = {
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
        @stats = table.shallow_copy(@basestats)
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
        return damage

    attack: (target, damageOverride) =>
        damage = nil
        if damageOverride
            damage = damageOverride
        else
            damage = @stats.attack
        damage *= 1.1 if @buffs.rally
        
        target\takeDamage(damage)
        
    skillPrimaryInfo: () => return {
        name: "SKILLPRIMARY"
        valid: () => return false
    }

    skillSecondaryInfo: () => return {
        name: "SKILLSECONDARY"
        valid: () => return false
    }

    skillPrimary: () =>

    skillSecondary: () =>

    isValidTarget: (targetType) =>
        switch targetType
            when "attack"
                return @hp > 0
            when "move"
                return @hp > 0
                -- return @parent\currentTurn! != @
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
        @basestats.hp = 50
        @basestats.attack = 3
        @basestats.defence = 2
        @basestats.speed = 5
        @basestats.magic = 10
        @init!

    draw_alive: () =>
        lg.setColor(MAGE_COL)
        super false

export class Fighter extends BattlePlayer
    new: (...) =>
        super ...
        @basestats.hp = 50
        @basestats.attack = 8
        @basestats.defence = 4
        @basestats.speed = 7
        @basestats.magic = 2
        @init!
    
    -- Lunge - shoves forwards as far as you can, 
    -- dealing more damage with a bigger lunge
    skillPrimaryInfo: => return {
        name:"LUNGE",
        desc:"Lunge forward as far as you can, dealing more damage with a bigger lunge."
    }
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

    -- Reposition - swap two allies places
    skillSecondaryInfo: () => return {
        name:"REPOSITION",
        desc:"Swap the position of two allies, or move an ally to an empty space."
    }
    skillSecondary: () =>
        myindex = nil
        for i, player in pairs @parent.players
            myindex = i if player == @
        assert myindex != nil
        @parent.selectionCallback = (firstindex) =>
            @selectionCallback = (secondindex) =>
                currentSpace = firstindex
                assert currentSpace != nil
                assert secondindex <= 4
                swapscene = CutsceneSwap({tts:2, firstindex:firstindex, secondindex:secondindex})
                @cutscenes\addCutscene(swapscene)
                @state\changeState(BattleTurnState, {ttl:30})
            @state\changeState(BattleSpaceSelectState, {selectedspace:firstindex})
        @parent.state\changeState(BattlePlayerSelectState, {selectedIndex:myindex})

    draw_alive: () =>
        lg.setColor(FIGHTER_COL)
        super false

export class Paladin extends BattlePlayer
    new: (...) =>
        super ...
        @basestats.hp = 50
        @basestats.attack = 5
        @basestats.defence = 8
        @basestats.speed = 3
        @basestats.magic = 6
        @init!

    -- Rally - apply a small damage and speed buff
    -- to all allies
    skillPrimaryInfo: () => return {name:"RALLY"}
    skillPrimary: () =>


    draw_alive: () =>
        lg.setColor(PALADIN_COL)
        super false

export class Rogue extends BattlePlayer
    new: (...) =>
        super ...
        @basestats.hp = 50
        @basestats.attack = 9
        @basestats.defence = 2
        @basestats.speed = 8
        @basestats.magic = 2
        @init!

    draw_alive: () =>
        lg.setColor(ROGUE_COL)
        super false