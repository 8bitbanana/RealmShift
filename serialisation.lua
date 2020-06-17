local Serpent = require("lib/serpent")
local Inspect = require("lib/inspect")
local classmap = {
  InventoryItem,
  Potion,
  PartyHeal,
  LesserPotion,
  BattlePlayer,
  Mage,
  Fighter,
  Paladin,
  Rogue
}
local getclassindex
getclassindex = function(cls)
  for index, value in pairs(classmap) do
    if value == cls then
      return index
    end
  end
  return nil
end
serialise = function(game, write)
  if write == nil then
    write = true
  end
  local data = {
    inventory = {
      gold = game.inventory.gold,
      items = { }
    },
    party = { }
  }
  for i, item in pairs(game.inventory.items) do
    local itemid = getclassindex(item.__class)
    if itemid == nil then
      error(tostring(item.__class.__name) .. " is not set to be serialisable")
    end
    table.insert(data.inventory.items, itemid)
  end
  for i, player in pairs(game.party) do
    if player == nil then
      data.party[i] = nil
    else
      local playerid = getclassindex(player.__class)
      if playerid == nil then
        error(tostring(player.__class.__name) .. " is not set to be serialisable")
      end
      local plsave = {
        id = playerid,
        hp = player.hp,
        stats = player.stats
      }
      data.party[i] = plsave
    end
  end
  local serial = Serpent.dump(data)
  if write then
    local file = io.open("save.dat", "wb")
    file:write(serial)
    file:close()
  end
  return serial
end
deserialise = function(game, serial)
  if serial == nil then
    local file = io.open("save.dat", "rb")
    serial = file:read("*all")
    print(serial)
    file:close()
  end
  local ok, data = Serpent.load(serial)
  return print(Inspect(data))
end
