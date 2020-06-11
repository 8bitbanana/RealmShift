

export class InventoryItem
	name: "Missingno"
	desc: "The base item class"
	consumable: true

	new: (@root) => -- @root expects the game class

	is_usable: => return false

	use: =>
		if @root.state.__class == GameBattleState
			@use_battle!
		else
			@use_world!

	use_world: =>

	use_battle: =>

	draw_sprite: (pos) =>

class Potion extends InventoryItem
	name: "Potion"
	desc: "Restores some health for an ally"
	is_usable: => true

export class Inventory
	new: (@parent) => -- @parent expects the game class
		@items = {
			InventoryItem(@parent)
			InventoryItem(@parent)
			Potion(@parent)
			InventoryItem(@parent)
		}

	addItem: (item, index) =>
		item.root = @parent if item.root == nil
		if index == nil
			table.insert(@items, item)
		else
			table.insert(@items, index, item)

	swapItems: (index1, index2) =>
		item1 = @items[index1]
		@items[index1] = @items[index2]
		@items[index2] = item1

	useItem: (index) =>
		item = @items[index]
		table.remove(@items, index) if item.consumable
		item\use!

	removeItem: (index) =>
		table.remove(@items, index)