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

	update: =>
		@moveItemCursor(-1) if input\pressed("up")
		@moveItemCursor(1)  if input\pressed("down")
		@select! if input\pressed("confirm")
		@cursor\update!

	draw: =>
		lg.setColor(1,1,1)
		lg.rectangle("fill",116,4,116,50) -- menubox fill
		lg.setColor(0,0,0,1)
		lg.rectangle("line",116,4,116,50) -- menubox line
		currentIndex = 0
		for i=@scrollWindow.top, @scrollWindow.bottom
			item = @items[i]
			if item
				lg.print(item.name, 21, 11+(currentIndex*16))
				currentIndex+=1
		@cursor\draw!

