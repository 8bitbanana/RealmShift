do
  local _class_0
  local _base_0 = {
    name = "Missingno",
    desc = "The base item class",
    consumable = true,
    is_usable = function(self)
      return false
    end,
    use = function(self, target)
      self.target = target
    end,
    draw_sprite = function(self, pos) end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, root)
      self.root = root
    end,
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
    name = "M. Potion",
    desc = "Heals an ally for 50 HP",
    consumable = true,
    use_prompt = "Who would you like to\nuse the potion on?",
    use_target = "player",
    heal = 50,
    sprite = sprites.items.potion,
    is_usable = function(self)
      local _list_0 = game.party
      for _index_0 = 1, #_list_0 do
        local player = _list_0[_index_0]
        if self:is_usable_on_target(player) then
          return true
        end
      end
      return false
    end,
    is_usable_on_target = function(self, target)
      if target == nil then
        return false
      end
      return target.hp < target.stats.hp
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
    useItem = function(self, index)
      local item = self.items[index]
      if item.consumable then
        table.remove(self.items, index)
      end
      return item:use()
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
    __init = function(self, parent)
      self.parent = parent
      self.items = {
        LesserPotion(self.parent),
        Potion(self.parent),
        LesserPotion(self.parent),
        Potion(self.parent),
        LesserPotion(self.parent),
        Potion(self.parent),
        LesserPotion(self.parent),
        Potion(self.parent),
        LesserPotion(self.parent),
        Potion(self.parent),
        LesserPotion(self.parent),
        Potion(self.parent),
        LesserPotion(self.parent),
        Potion(self.parent)
      }
      self.gold = 0
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
