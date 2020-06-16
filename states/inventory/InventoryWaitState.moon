export class InventoryWaitState extends State
	new: (@parent) =>

	update: =>
		if input\pressed "confirm"
			@parent.dialog\advanceInput!
		if input\pressed "back"
			@parent.dialog\cancelInput!
		if not @parent.dialog.running
			@parent.state\changeState(InventoryItemState)

	draw: =>