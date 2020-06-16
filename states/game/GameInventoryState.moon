Inspect = require("lib/inspect")
export class GameInventoryState extends State
	new: (@parent) =>
		@dialog = DialogManager!
		@state = State(@)
		@selectedIndex = 1

		@scrollWindow = {top:1, bottom:8}

	scrollTo: (index) =>
		index = @selectedIndex if index == nil
		if index < @scrollWindow.top
			difference = @scrollWindow.top - index
			@scrollWindow.top -= difference
			@scrollWindow.bottom -= difference
		else if index > @scrollWindow.bottom
			difference = index - @scrollWindow.bottom
			@scrollWindow.top += difference
			@scrollWindow.bottom += difference

	getScrolledIndex: (index) =>
		index = @selectedIndex if index == nil
		return index - @scrollWindow.top + 1

	selectedItem: =>
		@parent.inventory.items[@selectedIndex]

	init: =>
		@state\changeState(InventoryItemState)

	-- useCurrentItem: =>
	-- 	game.inventory\useItem(@selectedIndex)
	-- 	@selectedIndex = #@parent.inventory.items if @selectedIndex > #@parent.inventory.items
	-- 	@scrollTo!

	swapCurrentItem: (index) =>
		temp = game.inventory.items[@selectedIndex]
		game.inventory.items[@selectedIndex] = game.inventory.items[index]
		game.inventory.items[index] = temp

	tossCurrentItem: =>
		game.inventory\removeItem(@selectedIndex)
		@selectedIndex = #@parent.inventory.items if @selectedIndex > #@parent.inventory.items
		@scrollTo!

	update: =>
		@state\update!
		@dialog\update!

	draw: =>
		lg.clear(0,0,0)
		lg.setColor(1,1,1)
		lg.rectangle("fill",8,8,GAME_WIDTH/2-12,GAME_HEIGHT-16)
		lg.setColor(0,0,0)
		lg.rectangle("line",8,8,GAME_WIDTH/2-12,GAME_HEIGHT-16)
		-- for i, item in pairs @parent.inventory.items
		-- 	lg.print(item.name, 21, 11+((i-1)*16))
		currentIndex = 0
		for i=@scrollWindow.top, @scrollWindow.bottom
			item = @parent.inventory.items[i]
			if item
				lg.print(item.name, 21, 11+(currentIndex*16))
				currentIndex += 1

		lg.setColor(1,1,1)
		lg.rectangle("fill",GAME_WIDTH/2+4,8, GAME_WIDTH/2-12, GAME_HEIGHT/2-12)
		lg.setColor(0,0,0)
		lg.rectangle("line",GAME_WIDTH/2+4,8, GAME_WIDTH/2-12, GAME_HEIGHT/2-12)
		if @selectedItem! != nil
			lg.printf(@selectedItem!.desc,GAME_WIDTH/2+7,8, GAME_WIDTH/2-18)

		@state\draw!
		@dialog\draw!
