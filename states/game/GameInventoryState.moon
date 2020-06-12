Inspect = require("lib/inspect")
export class GameInventoryState extends State
	new: (@parent) =>
		@dialog = DialogManager!
		@state = State(@)
		@selectedIndex = 1

	selectedItem: =>
		@parent.inventory.items[@selectedIndex]

	init: =>
		@state\changeState(InventoryItemState)

	useCurrentItem: =>
		game.inventory\useItem(@selectedIndex)
		@selectedIndex = #@parent.inventory.items if @selectedIndex > #@parent.inventory.items

	tossCurrentItem: =>
		game.inventory\removeItem(@selectedIndex)
		@selectedIndex = #@parent.inventory.items if @selectedIndex > #@parent.inventory.items

	update: =>
		@state\update!
		@dialog\update!

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
		if @selectedItem! != nil
			lg.printf(@selectedItem!.desc,GAME_WIDTH/2+7,8, GAME_WIDTH/2-18)

		@state\draw!
		@dialog\draw!
