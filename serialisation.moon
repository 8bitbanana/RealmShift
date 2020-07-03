Serpent = require "lib.serpent"
Inspect = require "lib.inspect"

classmap = {
	InventoryItem,
	Potion,
	PartyHeal,
	LesserPotion,
	BridgeItem,
	BossKeyItem,
	BattlePlayer,
	Mage,
	Fighter,
	Paladin,
	Rogue
}

getclassindex = (cls) ->
	for index, value in pairs classmap
		if value == cls
			return index
	return nil

export serialise = (game, write=true) ->
	data = {
		inventory: {
			gold: game.inventory.gold
			items: {}
		},
		party: {}
	}
	for i, item in pairs game.inventory.items
		itemid = getclassindex(item.__class)
		if itemid == nil
			error "#{item.__class.__name} is not set to be serialisable"
		table.insert(data.inventory.items, itemid)
	for i, player in pairs game.party
		if player == nil
			data.party[i] = nil
		else
			playerid = getclassindex(player.__class)
			if playerid == nil
				error "#{player.__class.__name} is not set to be serialisable"
			plsave = {
				id: playerid,
				hp: player.hp
				stats: player.stats
			}
			data.party[i] = plsave
	serial = Serpent.dump(data)
	if write
		file = io.open("save.dat", "wb")
		file\write(serial)
		file\close!
	return serial

export deserialise = (game, serial) ->
	if serial == nil
		file = io.open("save.dat", "rb")
		serial = file\read("*all")
		file\close!
	ok, data = Serpent.load(serial)
	error("Error serialising") if not ok
	game.inventory.gold = data.inventory.gold
	game.inventory.items = {}
	for i, itemid in pairs data.inventory.items
		itemclass = classmap[itemid]
		error("Unknown item class id #{itemclass}") if itemclass == nil
		table.insert(game.inventory.items, itemclass!)
	for i, plsave in pairs data.party
		playerclass = classmap[plsave.id]
		error("Unknown player class id #{plsave.id}") if playerclass == nil
		player = playerclass!
		player.hp = plsave.hp
		player.stats = plsave.stats
		game.party[i] = player



