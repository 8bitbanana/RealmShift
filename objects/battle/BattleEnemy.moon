require "objects/battle/BattlePlayer"

-- @pos is the bottom left - to accomadate different sizes

export class BattleEnemy extends BattlePlayer
    new: () =>
        super!
        @stats.hp = 20
        @stats.attack = 1
        @stats.defence = 1
        @stats.speed = 1
        @init!

    draw: () =>
        lg.setColor(RED)
        super false
        lg.print("EN", @pos.x, @pos.y)