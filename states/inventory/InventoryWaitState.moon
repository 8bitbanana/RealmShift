export class InventoryWaitState extends State
	new: (@parent) =>

	update: =>
		@parent.dialog\advanceInput! if input\pressed "confirm"
		if not @parent.dialog.running
			@parent.state\changeState(InventoryItemState)

	draw: =>