
require "objects/game objects/inventory"

export class BossKeyItem extends InventoryItem
	price: 150
	name: "Tower Key"
	desc: "A rusted key to a dark and monolithic tower..."
	consumable: false
	sprite: sprites.items.boss_key
