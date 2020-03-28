require "states/state"
Inspect = require "lib/inspect"

WRAP_ITEM_CURSOR = false

class MenuItem
    new: (@parent, @text, @pos)=>
        @cursor = Cursor({x:@pos.x-15,y:@pos.y-4}, "right")
    clicked: ()=>
        @activate! if @valid!
            
    activate: ()=>
    valid: ()=>false
    draw: ()=>
        --if @parent\selectedItem! == @
            --@cursor\draw!
        if @valid!                
            lg.setColor(BLACK)
        else
            lg.setColor(GRAY)
        lg.print(@text, @pos.x, @pos.y)

class AttackMenuItem extends MenuItem
    activate: () => @parent.parent\attackAction!
    valid: () =>
        validtargets = 0
        for enemy in *@parent.parent.enemies
            if enemy\isValidTarget "attack"
                validtargets += 1
        return validtargets > 0


class MoveMenuItem extends MenuItem
    activate: () => @parent.parent\moveAction!
    valid: () =>
        validtargets = 0
        for enemy in *@parent.parent.enemies
            if enemy\isValidTarget "move"
                validtargets += 1
        return validtargets > 0

class SkillMenuItem extends MenuItem
    valid: () => false

class ItemMenuItem extends MenuItem
    valid: () => false


export class BattleMenuState extends State
    new: (@parent) =>
        @items = {
            AttackMenuItem(@, "ATTACK", {x:130,y:11}),
            MoveMenuItem(@, "MOVE",   {x:130,y:30}),
            SkillMenuItem(@, "SKILL",  {x:195,y:11}),
            ItemMenuItem(@, "ITEM",   {x:195,y:30})
        }
        @selectedIndex = 1
        @cursor = Cursor({x:@selectedItem!.pos.x-15,y:@selectedItem!.pos.y-4}, "right")
        

    drawMenu: () =>
        for index, item in pairs @items
            item\draw!
            
    selectedItem: () =>
        return @items[@selectedIndex]

    update: () =>
        @cursor\update!
        @moveItemCursor(-1) if input\pressed("up")
        @moveItemCursor(1)  if input\pressed("down")
        @moveItemCursor(-2) if input\pressed("left")
        @moveItemCursor(2)  if input\pressed("right")
        @selectedItem!\clicked! if input\pressed("confirm")

    moveItemCursor: (dir) =>
        newindex = @selectedIndex + dir
        return if newindex < 1 -- menu boundary checking
        return if newindex > 4
        return if @selectedIndex == 2 and dir == 1
        return if @selectedIndex == 3 and dir == -1
        @selectedIndex = newindex
        @cursor.pos = {x:@selectedItem!.pos.x-15,y:@selectedItem!.pos.y-4}

    draw: () =>
        lg.setColor(1,1,1,1)
        lg.rectangle("fill",116,4,116,50) -- menubox fill
        lg.setColor(0,0,0,1)
        lg.rectangle("line",116,4,116,50) -- menubox line
        lg.setColor(1,1,1,1)
        selectedX = @parent.currentTurn.pos.x
        lg.polygon("fill",
            selectedX + 2,  53,
            selectedX + 12, 91,
            selectedX + 22, 53
        ) -- player cursor fill
        lg.setColor(0,0,0,1)
        lg.line(
            selectedX + 2, 53,
            selectedX + 12, 91,
            selectedX + 22, 53
        ) -- player cursor line
        @drawMenu!
        @cursor\draw!

    