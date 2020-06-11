export class InventoryWaitState extends State
	new: (@parent) =>

	update: =>
		if not game.dialog.running
			@parent.state\changeState(InventoryItemState)

	draw: =>