require "states/state"
Inspect = require "lib/inspect"

class PrimaryMenuItem extends MenuItem
	new: (...) =>
		super ...
		@text = @parent.parent\currentTurn!\skillPrimaryInfo!.name
		
	activate: () => @parent.parent\currentTurn!\skillPrimary!
	valid: () => return true

class SecondaryMenuItem extends MenuItem
	new: (...) =>
		super ...
		@text = @parent.parent\currentTurn!\skillSecondaryInfo!.name

	activate: () => @parent.parent\currentTurn!\skillSecondary!
	valid: () => return true

export class BattleSkillSelectState extends State
	new: (@parent) =>
		@items = {
			PrimaryMenuItem(@, {x:130, y:11}),
			SecondaryMenuItem(@, {x:130, y:30})
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
		@moveItemCursor(1) if input\pressed("down")
		--@moveItemCursor(-1) if input\pressed("left")
		--@moveItemCursor(1)  if input\pressed("right")
		@selectedItem!\clicked! if input\pressed("confirm")

	moveItemCursor: (dir) =>
		newindex = @selectedIndex + dir
		return if newindex < 1
		return if newindex > 2
		@selectedIndex = newindex
		@cursor.pos = {x:@selectedItem!.pos.x-15,y:@selectedItem!.pos.y-4}
	
	draw: () =>
		lg.setColor(1,1,1,1)
		lg.rectangle("fill",116,4,116,50) -- menubox fill
		lg.setColor(0,0,0,1)
		lg.rectangle("line",116,4,116,50) -- menubox line
		lg.setColor(1,1,1,1)
		@drawMenu!
		@cursor\draw!
