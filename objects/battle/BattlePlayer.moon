export class BattlePlayer
    new: (@pos = {x:0,y:0}) =>
        
    draw: =>
        lg.setColor(ORANGE)
        lg.rectangle("fill", @pos.x, @pos.y, 24, 32)
        lg.setColor(BLACK)
        lg.rectangle("line", @pos.x, @pos.y, 24, 32)
