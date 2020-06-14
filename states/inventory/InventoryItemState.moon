export class InventoryItemState extends State
	new: (@parent) =>
		@selected = @parent.selectedIndex
		@cursor = Cursor({x:0,y:0}, "right")
		@items = game.inventory.items

	init: =>
		@updateCursorPos!

	selectedItem: =>
		return @items[@selected]

	update: =>
		@moveItemCursor(-1) if input\pressed("up")
		@moveItemCursor(1)  if input\pressed("down")
		@select! if input\pressed("confirm")
		@cursor\update!

	moveItemCursor: (dir) =>
		@selected += dir
		@selected = 1 if @selected < 1
		@selected = #@items if @selected > #@items
		@parent.selectedIndex = @selected
		@parent\scrollTo!
		@updateCursorPos!
		
	select: =>
		if @items[@selected] != nil
			@parent.state\changeState(InventoryActionState)

	updateCursorPos: =>
		relIndex = @parent\getScrolledIndex(@selected)
		@cursor.pos = {
			x: 6
			y: (relIndex*16)-9
		}
		@parent.selectedIndex = @selected

	draw: =>
		if @items[@selected] != nil
			@cursor\draw!