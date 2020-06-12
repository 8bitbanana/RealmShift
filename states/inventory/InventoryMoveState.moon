export class InventoryMoveState extends State
	new: (@parent) =>
		@cursorStart = Cursor({x:6, y:(@parent.selectedIndex*16)-9}, "right")
		@cursorEnd = Cursor({x:0,y:0}, "right")
		@items = game.inventory.items
		@selected = 0
		@moveItemCursor(1)

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
			@updateCursorPos!

	updateCursorPos: =>
		@cursorEnd.pos = {
			x: 6
			y: (@selected*16)-9
		}

	select: =>
		@parent\swapCurrentItem(@selected)
		@changeState(InventoryItemState)

	back: =>
		@changeState(InventoryActionState)

	draw: =>
		@cursorStart\draw!
		@cursorEnd\draw!