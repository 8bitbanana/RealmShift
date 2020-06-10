export class GameInventoryState extends State
	new: (@parent) =>
		@state = State(@)
		@selectedIndex = nil

	selectedItem: =>
		@parent.inventory.items[@selectedIndex]

	init: =>
		@state\changeState(InventoryItemState)

	update: =>
		@state\update!

	draw: =>
		lg.clear(0,0,0)
		lg.setColor(1,1,1)
		lg.rectangle("fill",8,8,GAME_WIDTH/2-12,GAME_HEIGHT-16)
		lg.setColor(0,0,0)
		lg.rectangle("line",8,8,GAME_WIDTH/2-12,GAME_HEIGHT-16)
		for i, item in pairs @parent.inventory.items
			lg.print(item.name, 21, 11+((i-1)*16))

		lg.setColor(1,1,1)
		lg.rectangle("fill",GAME_WIDTH/2+4,8, GAME_WIDTH/2-12, GAME_HEIGHT/2-12)
		lg.setColor(0,0,0)
		lg.rectangle("line",GAME_WIDTH/2+4,8, GAME_WIDTH/2-12, GAME_HEIGHT/2-12)
		lg.printf(@selectedItem!.desc,GAME_WIDTH/2+7,8, GAME_WIDTH/2-18)

		@state\draw!
