class BattleItemSelectState extends State
	new: (@parent) =>
		@items = {

		}
		@selectedIndex = 1
		@cursor = Cursor({x:@selectedItem!.pos.x-15,y:@selectedItem!.pos.y-4}, "right")

	selectedItem: =>


	update: =>


	draw: =>

