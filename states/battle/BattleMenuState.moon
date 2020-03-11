require "states/state"
Inspect = require "lib/inspect"

WRAP_ITEM_CURSOR = false

class MenuItem
    new: (@parent, @text, @pos)=>
    clicked: ()=>
    valid: ()=>true
    draw: ()=>
        if @parent\selectedItem! == @
            sprites.battle.cursor\draw(@pos.x-15, @pos.y-4)
        if @valid!                
            lg.setColor(BLACK)
        else
            lg.setColor(GRAY)
        lg.print(@text, @pos.x, @pos.y)

export class BattleMenuState extends State
    new: (@parent) =>
        @items = {
            MenuItem(@, "ATTACK", {x:130,y:11}),
            MenuItem(@, "MOVE",   {x:130,y:30}),
            MenuItem(@, "SKILL",  {x:195,y:11}),
            MenuItem(@, "ITEM",   {x:195,y:30})
        }
        -- man I sure do hate this
        @items[1].clicked = () => @parent.parent\attackAction!
        @selectedIndex = 1

    drawMenu: () =>
        for index, item in pairs @items
            item\draw!
            

    selectedItem: () =>
        return @items[@selectedIndex]

    update: () =>
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

    draw: () =>
        lg.setColor(1,1,1,1)
        lg.rectangle("fill",116,4,116,50) -- menubox fill
        lg.setColor(0,0,0,1)
        lg.rectangle("line",116,4,116,50) -- menubox line
        lg.setColor(1,1,1,1)
        selectedX = @parent\selectedPlayer!.pos.x
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

    