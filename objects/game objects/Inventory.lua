do
  local _class_0
  local _base_0 = {
    name = "Missingno",
    desc = "The base item class",
    consumable = true,
    is_usable = function(self)
      return false
    end,
    use = function(self)
      if self.root.state.__class == GameBattleState then
        return self:use_battle()
      else
        return self:use_world()
      end
    end,
    use_world = function(self) end,
    use_battle = function(self) end,
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
local Potion
do
  local _class_0
  local _parent_0 = InventoryItem
  local _base_0 = {
    name = "Potion",
    desc = "Restores some health for an ally",
    is_usable = function(self)
      return true
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
    swapItems = function(self, index1, index2)
      local item1 = self.items[index1]
      self.items[index1] = self.items[index2]
      self.items[index2] = item1
    end,
    useItem = function(self, index)
      local item = self.items[index]
      if item.consumable then
        table.remove(index)
      end
      return item:use()
    end,
    removeItem = function(self, index)
      return table.remove(index)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, parent)
      self.parent = parent
      self.items = {
        InventoryItem(self.parent),
        InventoryItem(self.parent),
        Potion(self.parent),
        InventoryItem(self.parent)
      }
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
