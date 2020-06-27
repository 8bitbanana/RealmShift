export class BattleItemSelectState extends State
	new: (@parent) =>
		@items = game.inventory.items
		@selectedIndex = 1
		@cursor = Cursor({x:0,y:0}, "right")
		@scrollWindow = {top:1, bottom: 5}

	init: =>
		@updateCursorPos!

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
		@items[@selectedIndex]

	updateCursorPos: =>
		@cursor.pos = {
			x:6,
			y:(@getScrolledIndex!*16)-9
		}

	moveItemCursor: (dir) =>
		@selectedIndex += dir
		@selectedIndex = 1 if @selectedIndex < 1
		@selectedIndex = #@items if @selectedIndex > #@items
		@scrollTo!
		@updateCursorPos!

	select: =>
		@parent\selectionCallback(@selectedIndex)

	back: =>
		@parent\turnStart!

	update: =>
		@moveItemCursor(-1) if input\pressed("up")
		@moveItemCursor(1)  if input\pressed("down")
		@select! if input\pressed("confirm")
		@back! if input\pressed("back")
		@cursor\update!

	draw: =>
		lg.setColor(1,1,1)
		lg.rectangle("fill",8,8,GAME_WIDTH/2-12, 16*5+4)
		lg.setColor(0,0,0)
		lg.rectangle("line",8,8,GAME_WIDTH/2-12, 16*5+4)
		currentIndex = 0
		for i=@scrollWindow.top, @scrollWindow.bottom
			item = @items[i]
			if item
				lg.setColor(0,0,0)
				lg.print(item.name, 21, 11+(currentIndex*16))
				item.sprite\draw(100,14+(currentIndex*16))
				currentIndex+=1

		lg.setColor(1,1,1)
		lg.rectangle("fill",GAME_WIDTH/2+4, 8, GAME_WIDTH/2-12, 16*3+6)
		lg.setColor(0,0,0)
		lg.rectangle("line",GAME_WIDTH/2+4, 8, GAME_WIDTH/2-12, 16*3+6)
		if @selectedItem! != nil
			lg.printf(@selectedItem!.desc, GAME_WIDTH/2+7, 8, GAME_WIDTH/2-18)	
		
		@cursor\draw!

