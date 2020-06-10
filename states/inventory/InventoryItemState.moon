export class InventoryItemState extends State
	new: (@parent) =>
		@selected = 1
		@cursor = Cursor({x:0,y:0}, "right")
		@items = @parent.parent.inventory.items

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
		@updateCursorPos!
		
	select: =>
		@parent.state\changeState(InventoryActionState)

	updateCursorPos: =>
		@cursor.pos = {
			x: 6
			y: (@selected*16)-9
		}
		@parent.selectedIndex = @selected

	draw: =>
		@cursor\draw!