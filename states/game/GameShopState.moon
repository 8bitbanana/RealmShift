
export class GameShopState extends State
	-- item_list: list of item classes to sell,
	-- rpath: path to return room,
	-- rx/ry: return xy position
	new: (@parent, @item_list={}, @rpath, @rx=0, @ry=0) =>
		@timer = 0
		@cursor = 1

	init: =>


	moveCursor: =>
		if input\pressed("up")
			if @cursor == 1
				@cursor = #@item_list
			else
				@cursor -= 1
		elseif input\pressed("down")
			if @cursor == #@item_list
				@cursor = 1
			else
				@cursor += 1

	checkBuy: =>
		if input\pressed("confirm")
			item = @item_list[@cursor]
			gold = game.inventory.gold
			if gold >= item.price
				return true
			else
				sounds.negative\stop!
				sounds.negative\play!
				return false

	purchaseItem: =>
		item = @item_list[@cursor]
		game.inventory.gold -= item.price -- Spend Player's Gold
-- 		table.insert(game.inventory.items, item!)
		game.inventory\addItem(item!) -- Add Item To Inventory
		-- Play Some Sounds
		sounds.coin_final\stop! -- Stops sound if it's currently playing to stop sound overlap / not playing at all
		sounds.item_pocket\stop!
		sounds.coin_final\play!
		sounds.item_pocket\play!

	checkLeave: =>
		if input\pressed("back")
			return true

	leaveShop: =>
		game.next_state = {state: GameExploreState, params: {@rpath, @rx, @ry}}

	update: =>
		@timer += dt
		@\moveCursor!
		if @\checkBuy!
			@\purchaseItem!
		elseif @\checkLeave!
			@\leaveShop!

	printShop: =>
		lg.setFont(big_font)
		shadowPrint("Shop", 32, 16)
		lg.setFont(default_font)

	printGold: =>
		shadowPrint("gold: #{game.inventory.gold}", 128, 16, GOLD)

	drawCursor: =>
		x=16 - (@timer % 0.35) * 8
		y=40 + ((@cursor-1) * 12) + 2
		lg.setColor(WHITE)
		sprites.gui.finger_cursor\draw(x, y)

	drawShopItems: =>
		x=16
		y=40
		for item in *@item_list
-- 			lg.rectangle("fill", x+2,y+4, 4, 4)
			shadowPrint(item.name, x+16, y)
			shadowPrint("#{item.price}G", x+128, y, GOLD)

			y += 12

		lg.setColor(WHITE)

	drawTooltips: =>
		shadowPrint("z - purchase", 32, GAME_HEIGHT-18)
		shadowPrint("x - leave", 128, GAME_HEIGHT-18)

	draw: =>
		lg.clear(BLACK)
		@\printShop!
		@\printGold!
		@\drawShopItems!
		@\drawCursor!
		@\drawTooltips!

