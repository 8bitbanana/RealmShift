require "states/state"

WRAP_ITEM_CURSOR = false

export class BattleMenuState extends State
    new: (@parent) =>
        @items = {
            {
                x: 130,
                y: 11,
                text: "ATTACK",
                valid: ()->true
            },
            {
                x: 130,
                y: 30,
                text: "MOVE",                
                valid: ()->true
            },
            {
                x: 195,
                y: 11,
                text: "SKILL",
                valid: ()->true
            },
            {
                x: 195,
                y: 30,
                text: "ITEM",
                valid: ()->true
            }
        }
        @selectedIndex = 1

    drawMenu: () =>
        for index, item in pairs @items
            if index == @selectedIndex
                sprites.battle.cursor\draw(item.x-15, item.y-4)
            lg.setColor(BLACK) -- apparently sprite resets this
            lg.print(item.text, item.x, item.y)
            

    selectedItem: () =>
        return @items[@selectedIndex]

    update: () =>
        @moveItemCursor(-1) if input\pressed("up")
        @moveItemCursor(1)  if input\pressed("down")
        @moveItemCursor(-2) if input\pressed("left")
        @moveItemCursor(2)  if input\pressed("right")

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

    