export class InventoryMoveState extends State
	new: (@parent) =>
		@cursorStart = Cursor({x:0,y:0}, "right")
		@cursorEnd = Cursor({x:0,y:0}, "right")
		@items = game.inventory.items
		if @parent.selectedIndex >= #@items
			@selected = @parent.selectedIndex - 1
		else
			@selected = @parent.selectedIndex + 1
		@parent\scrollTo(@selected)

	init: =>
		@updateCursorPos!

	update: =>
		@moveItemCursor(-1) if input\pressed("up")
		@moveItemCursor(1)  if input\pressed("down")
		@select! if input\pressed("confirm")
		@back! if input\pressed("back")
		@cursorEnd\update!

	moveItemCursor: (dir) =>
		newindex = @selected
		while true
			newindex += dir
			break if newindex < 1
			break if newindex > #@items
			break if newindex != @parent.selectedIndex
		if @items[newindex] != nil
			@selected = newindex
			@parent\scrollTo(@selected)
			@updateCursorPos!

	updateCursorPos: =>
		@cursorStart.pos = {
			x:6,
			y:(@parent\getScrolledIndex!*16)-9
		}
		@cursorEnd.pos = {
			x: 6
			y: (@parent\getScrolledIndex(@selected)*16)-9
		}

	select: =>
		@parent\swapCurrentItem(@selected)
		@parent.selectedIndex = @selected
		@parent\scrollTo!
		@changeState(InventoryItemState)

	back: =>
		@parent\scrollTo!
		@changeState(InventoryActionState)

	draw: =>
		@cursorStart\draw!
		@cursorEnd\draw!