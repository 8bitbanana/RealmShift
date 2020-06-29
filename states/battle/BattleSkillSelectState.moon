require "states/state"
Inspect = require "lib/inspect"

class PrimaryMenuItem extends MenuItem
	new: (...) =>
		super ...
		@text = @parent.parent\currentTurn!.skillPrimaryInfo.name
		@desc = @parent.parent\currentTurn!.skillPrimaryInfo.desc
		
	activate: () => @parent.parent\currentTurn!\skillPrimary!
	valid: () => return true

class SecondaryMenuItem extends MenuItem
	new: (...) =>
		super ...
		@text = @parent.parent\currentTurn!.skillSecondaryInfo.name
		@desc = @parent.parent\currentTurn!.skillSecondaryInfo.desc

	activate: () => @parent.parent\currentTurn!\skillSecondary!
	valid: () => return true

export class BattleSkillSelectState extends State
	new: (@parent) =>
		@items = {}
		if not @parent\currentTurn!.skillPrimaryInfo.unset
			table.insert(@items, PrimaryMenuItem(@, {x:21, y:11}))
		if not @parent\currentTurn!.skillSecondaryInfo.unset
			table.insert(@items, SecondaryMenuItem(@, {x:21, y:27}))
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
		@parent\turnStart! if input\pressed("back")

	moveItemCursor: (dir) =>
		newindex = @selectedIndex + dir
		return if newindex < 1
		return if newindex > #@items
		@selectedIndex = newindex
		@cursor.pos = {x:@selectedItem!.pos.x-15,y:@selectedItem!.pos.y-4}
	
	draw: () =>
		-- lg.setColor(1,1,1,1)
		-- lg.rectangle("fill",116,4,116,50) -- menubox fill
		-- lg.setColor(0,0,0,1)
		-- lg.rectangle("line",116,4,116,50) -- menubox line
		-- lg.setColor(1,1,1,1)

		lg.setColor(1,1,1)
		lg.rectangle("fill",8,8,GAME_WIDTH/2-12, 16*2+4)
		lg.setColor(0,0,0)
		lg.rectangle("line",8,8,GAME_WIDTH/2-12, 16*2+4)

		@drawMenu!
		@cursor\draw!

		lg.setColor(1,1,1)
		lg.rectangle("fill",GAME_WIDTH/2+4, 8, GAME_WIDTH/2-12, 16*5)
		lg.setColor(0,0,0)
		lg.rectangle("line",GAME_WIDTH/2+4, 8, GAME_WIDTH/2-12, 16*5)
		if @selectedItem! and @selectedItem!.desc
			lg.setFont(dialog_font)
			lg.printf(@selectedItem!.desc, GAME_WIDTH/2+7, 8, GAME_WIDTH/2-18)
			lg.setFont(default_font)