

export class InventoryItem
	name: "Missingno"
	desc: "The base item class"
	consumable: true

	new: (@root) => -- @root expects the game class

	is_usable: => return false

	use: (@target) =>

	draw_sprite: (pos) =>

class Potion extends InventoryItem
	name: "Potion"
	desc: "Restores some health for an ally"
	consumable: true
	use_prompt: "Who would you like to\nuse the potion on?"
	use_target: "player"
	is_usable: =>
		for player in *game.party
			return true if @is_usable_on_target(player)
		return false

	is_usable_on_target: (target) =>
		return false if target == nil
		return target.hp < target.stats.hp

	use: (target) =>
		oldhp = target.hp
		target.hp += 50
		target.hp = target.stats.hp if target.hp > target.stats.hp
		return "#{target.name} restored #{target.hp - oldhp} HP."


export class Inventory
	new: (@parent) => -- @parent expects the game class
		@items = {
			InventoryItem(@parent)
			InventoryItem(@parent)
			Potion(@parent)
			InventoryItem(@parent)
		}
		@gold = 0

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

	addGold: (amt=0) =>
		@gold += amt
