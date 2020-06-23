-- Use targets

-- player
-- enemy
-- nil

export class InventoryItem
	name: "Missingno"
	desc: "The base item class"
	consumable: true

	new: () =>

	is_usable: => return false

	use: (target) =>

	draw_sprite: (pos) =>

export class PartyHeal extends InventoryItem
	name: "F. Heal"
	desc: "Fully heals your party"
	consumable: true
	use_target: nil
	sprite: sprites.items.potion

	is_usable: =>
		for player in *game.party
			continue if not player
			return true if player.hp < player.stats.hp and player.hp > 0
		return false, "Everyone is already at full health!"

	use: =>
		for player in *game.party
			continue if not player
			player.hp = player.stats.hp
		return "The whole party was healed!"

export class Potion extends InventoryItem
	name: "M. Potion"
	desc: "Heals an ally for 50 HP"
	consumable: true
	use_target: "player"
	heal: 50
	sprite: sprites.items.potion

	-- is_usable: =>
	-- 	for player in *game.party
	-- 		return true if @is_usable_on_target(player)
	-- 	return false, "There isn't anyone to use this on."

	is_usable_on_target: (target) =>
		if target == nil
			return false, "No target"
		if target.hp >= target.stats.hp
			return false, "#{target.name} is already at full health."
		if target.hp == 0
			return false, "#{target.name} is knocked out!"
		return true

	use: (target) =>
		oldhp = target.hp
		target.hp += @heal
		target.hp = target.stats.hp if target.hp > target.stats.hp
		return "#{target.name} restored #{target.hp - oldhp} HP."

export class LesserPotion extends Potion
	heal: 30
	name: "S. Potion"
	desc: "Heals an ally for 30 HP"

export class Inventory
	new: =>
		@items = {
			LesserPotion!
			Potion!
			PartyHeal!
			PartyHeal!
		}
		@gold = 0

	addItem: (item, index) =>
		item.root = @parent if item.root == nil
		if index == nil
			table.insert(@items, item)
		else
			table.insert(@items, index, item)

	addItems: (item_list) =>
		for i in *item_list
			@\addItem(i)

	swapItems: (index1, index2) =>
		item1 = @items[index1]
		@items[index1] = @items[index2]
		@items[index2] = item1

	useItem: (index, target) =>
		item = @items[index]
		table.remove(@items, index) if item.consumable
		return item\use(target)

	removeItem: (index) =>
		table.remove(@items, index)

	addGold: (amt=0) =>
		@gold += amt
