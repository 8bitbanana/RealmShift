-- export class BattlePlayer
--     new= (@battleposition=0) =>
--         @pos = {
--             x=92+28*@battleposition,
--             y=95
--         }
        
--     draw= =>
--         lg.setColor(ORANGE)
--         lg.rectangle("fill", @pos.x, @pos.y, 24, 32)
--         lg.setColor(BLACK)
--         lg.rectangle("line", @pos.x, @pos.y, 24, 32)


class BattlePlayer
    new: ()=>
        @stats = {
            hp: 0,
            attack: 0,
            defence: 0,
            speed: 0,
            magic: 0
        }
        @pos = {
            x: 0,
            y: 0
        }

    draw: =>
        lg.setColor(ORANGE)
        lg.rectangle("fill", @pos.x, @pos.y, 24, 32)
        lg.setColor(BLACK)
        lg.rectangle("line", @pos.x, @pos.y, 24, 32)

export class Mage extends BattlePlayer
    new: () =>
        super!
        @stats.hp = 50
        @stats.attack = 3
        @stats.defence = 2
        @stats.speed = 5
        @stats.magic = 10

    draw: () =>
        super!
        lg.setColor(BLACK)
        lg.print("M", @pos.x+2, @pos.y+2)

export class Fighter extends BattlePlayer
    new: () =>
        super!
        @stats.hp = 50
        @stats.attack = 8
        @stats.defence = 4
        @stats.speed = 7
        @stats.magic = 2

    draw: () =>
        super!
        lg.setColor(BLACK)
        lg.print("F", @pos.x+2, @pos.y+2)

export class Paladin extends BattlePlayer
    new: () =>
        super!
        @stats.hp = 50
        @stats.attack = 5
        @stats.defence = 8
        @stats.speed = 3
        @stats.magic = 6

    draw: () =>
        super!
        lg.setColor(BLACK)
        lg.print("P", @pos.x+2, @pos.y+2)


export class Rogue extends BattlePlayer
    new: () =>
        super!
        @stats.hp = 50
        @stats.attack = 9
        @stats.defence = 2
        @stats.speed = 8
        @stats.magic = 2

    draw: () =>
        super!
        lg.setColor(BLACK)
        lg.print("R", @pos.x+2, @pos.y+2)