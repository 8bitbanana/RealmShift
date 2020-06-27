do
  local _class_0
  local _base_0 = {
    name = "Missingno",
    desc = "The base item class",
    consumable = true,
    is_usable = function(self)
      return false
    end,
    use = function(self, target) end,
    draw_sprite = function(self, pos) end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self) end,
    __base = _base_0,
    __name = "InventoryItem"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  InventoryItem = _class_0
end
do
  local _class_0
  local _parent_0 = InventoryItem
  local _base_0 = {
    price = 35,
    name = "F. Heal",
    desc = "Fully heals your party",
    consumable = true,
    use_target = nil,
    sprite = sprites.items.potion,
    is_usable = function(self)
      local _list_0 = game.party
      for _index_0 = 1, #_list_0 do
        local _continue_0 = false
        repeat
          local player = _list_0[_index_0]
          if not player then
            _continue_0 = true
            break
          end
          if player.hp < player.stats.hp and player.hp > 0 then
            return true
          end
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
      return false, "Everyone is already at full health!"
    end,
    use = function(self)
      local _list_0 = game.party
      for _index_0 = 1, #_list_0 do
        local _continue_0 = false
        repeat
          local player = _list_0[_index_0]
          if not player then
            _continue_0 = true
            break
          end
          player.hp = player.stats.hp
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
      return "The whole party was healed!"
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "PartyHeal",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  PartyHeal = _class_0
end
do
  local _class_0
  local _parent_0 = InventoryItem
  local _base_0 = {
    price = 10,
    name = "M. Potion",
    desc = "Heals an ally for 50 HP",
    consumable = true,
    use_target = "player",
    heal = 50,
    sprite = sprites.items.potion,
    is_usable_on_target = function(self, target)
      if target == nil then
        return false, "No target"
      end
      if target.hp >= target.stats.hp then
        return false, tostring(target.name) .. " is already at full health."
      end
      if target.hp == 0 then
        return false, tostring(target.name) .. " is knocked out!"
      end
      return true
    end,
    use = function(self, target)
      local oldhp = target.hp
      target.hp = target.hp + self.heal
      if target.hp > target.stats.hp then
        target.hp = target.stats.hp
      end
      return tostring(target.name) .. " restored " .. tostring(target.hp - oldhp) .. " HP."
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Potion",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Potion = _class_0
end
do
  local _class_0
  local _parent_0 = Potion
  local _base_0 = {
    price = 5,
    heal = 30,
    name = "S. Potion",
    desc = "Heals an ally for 30 HP"
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "LesserPotion",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  LesserPotion = _class_0
end
do
  local _class_0
  local _base_0 = {
    addItem = function(self, item, index)
      if item.root == nil then
        item.root = self.parent
      end
      if index == nil then
        return table.insert(self.items, item)
      else
        return table.insert(self.items, index, item)
      end
    end,
    addItems = function(self, item_list)
      for _index_0 = 1, #item_list do
        local i = item_list[_index_0]
        self:addItem(i)
      end
    end,
    swapItems = function(self, index1, index2)
      local item1 = self.items[index1]
      self.items[index1] = self.items[index2]
      self.items[index2] = item1
    end,
    useItem = function(self, index, target)
      local item = self.items[index]
      if item.consumable then
        table.remove(self.items, index)
      end
      return item:use(target)
    end,
    removeItem = function(self, index)
      return table.remove(self.items, index)
    end,
    addGold = function(self, amt)
      if amt == nil then
        amt = 0
      end
      self.gold = self.gold + amt
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.items = {
        LesserPotion(),
        LesserPotion()
      }
      self.gold = 25
    end,
    __base = _base_0,
    __name = "Inventory"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Inventory = _class_0
end
