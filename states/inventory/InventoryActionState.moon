Inspect = require("lib/inspect")
class UseItemMenuItem extends MenuItem
	text: "Use"
	valid: => return @parent.parent\selectedItem!\is_usable!
	activate: =>
		item = @parent.parent\selectedItem!
		player_options = {}
		for player in *game.party
			if item\is_usable_on_target(player)
				table.insert(player_options, "#{player.name} (#{player.hp}/#{player.stats.hp})")
		table.insert(player_options, "[CANCEL]Cancel")

		callback = nil
		switch item.use_target
			when "player"
				callback = (option) =>
					players = {}
					for player in *game.party
						table.insert(players, player) if @selectedItem!\is_usable_on_target(player)
					player = players[option]
					if player == nil
						return
					response = @selectedItem!\use(player)
					@dialog\setTree(DialogTree(
						{DialogBox(response)}
					))
					if @selectedItem!.consumable
						@tossCurrentItem!
			when nil
				callback = () =>
					response = @selectedItem!\use!
					@dialog\setTree(DialogTree(
						{DialogBox(response)}
					))
					if @selectedItem!.consumable
						@tossCurrentItem!

		@parent.parent.dialog\setTree(DialogTree(
			{DialogBox(item.use_prompt, player_options)},
			{},
			{[1]: callback},
			@parent.parent
		))

		@parent.parent.state\changeState(InventoryWaitState)
	
class MoveItemMenuItem extends MenuItem
	text: "Swap"
	valid: => return #game.inventory.items > 1
	activate: =>
		@parent\changeState(InventoryMoveState)

class TossItemMenuItem extends MenuItem
	text: "Toss"
	valid: => true
	activate: =>
		itemname = @parent.parent\selectedItem!.name
		@parent.parent.dialog\setTree(DialogTree(
			{
				DialogBox("Are you sure you want to toss\nthe #{itemname}?", {"Yes", "[CANCEL]No"})
				DialogBox("You tossed the #{itemname}.")
			},
			{
				[1]:{2,nil}
			},
			{
				[1]: (option) =>
					if option == 1
						@tossCurrentItem!
			}, @parent.parent
		))
		@parent.parent.state\changeState(InventoryWaitState)

export class InventoryActionState extends State
	new: (@parent) =>
		@items = {
			UseItemMenuItem(@,  {x:GAME_WIDTH/2+21,y:GAME_HEIGHT/2+7})
			MoveItemMenuItem(@, {x:GAME_WIDTH/2+21,y:GAME_HEIGHT/2+22})
			TossItemMenuItem(@, {x:GAME_WIDTH/2+21,y:GAME_HEIGHT/2+37})
		}
		@selectedIndex = 1
		@cursor = Cursor({x:0,y:0}, "right")
		@updateCursorPos!
	
	updateCursorPos: =>
		@cursor.pos = {x:@selectedItem!.pos.x-16,y:@selectedItem!.pos.y-4}

	drawMenu: =>
		for item in *@items
			item\draw!
	
	selectedItem: =>
		return @items[@selectedIndex]

	update: =>
		@cursor\update!
		@moveItemCursor(-1) if input\pressed("up")
		@moveItemCursor(1)  if input\pressed("down")
		@select! if input\pressed("confirm")
		@back! if input\pressed("back")
		@updateCursorPos!
	
	select: =>
		@selectedItem!\clicked!

	back: =>
		@parent.state\changeState(InventoryItemState)

	moveItemCursor: (dir) =>
		@selectedIndex += dir
		@selectedIndex = 1 if @selectedIndex < 1
		@selectedIndex = #@items if @selectedIndex > #@items

	draw: =>
		lg.setColor(1,1,1)
		lg.rectangle("fill",GAME_WIDTH/2+4,GAME_HEIGHT/2+4, GAME_WIDTH/2-12, GAME_HEIGHT/2-12)
		lg.setColor(0,0,0)
		lg.rectangle("line",GAME_WIDTH/2+4,GAME_HEIGHT/2+4, GAME_WIDTH/2-12, GAME_HEIGHT/2-12)

		@drawMenu!
		@cursor\draw!

	