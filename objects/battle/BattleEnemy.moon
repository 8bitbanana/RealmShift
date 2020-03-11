require "objects/battle/BattlePlayer"

-- @pos is the bottom left to accomadate different sizes

export class BattleEnemy extends BattlePlayer
    new: () =>
        super!
        @stats.hp = 20
        @stats.attack = 1
        @stats.defence = 1
        @stats.speed = 1
        @init!

    draw_alive: () =>
        lg.setColor(RED)
        lg.rectangle("fill", @pos.x, @pos.y-48, 30, 48)
        lg.setColor(BLACK)
        lg.rectangle("line", @pos.x, @pos.y-48, 30, 48)
        lg.print("EN", @pos.x, @pos.y)

    draw_dead: () =>
        lg.setColor(GRAY)
        lg.rectangle("fill", @pos.x, @pos.y-48, 30, 48)
        lg.setColor(BLACK)
        lg.rectangle("line", @pos.x, @pos.y-48, 30, 48)