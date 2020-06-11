do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    selectedItem = function(self)
      return self.parent.inventory.items[self.selectedIndex]
    end,
    init = function(self)
      return self.state:changeState(InventoryItemState)
    end,
    update = function(self)
      return self.state:update()
    end,
    draw = function(self)
      lg.clear(0, 0, 0)
      lg.setColor(1, 1, 1)
      lg.rectangle("fill", 8, 8, GAME_WIDTH / 2 - 12, GAME_HEIGHT - 16)
      lg.setColor(0, 0, 0)
      lg.rectangle("line", 8, 8, GAME_WIDTH / 2 - 12, GAME_HEIGHT - 16)
      for i, item in pairs(self.parent.inventory.items) do
        lg.print(item.name, 21, 11 + ((i - 1) * 16))
      end
      lg.setColor(1, 1, 1)
      lg.rectangle("fill", GAME_WIDTH / 2 + 4, 8, GAME_WIDTH / 2 - 12, GAME_HEIGHT / 2 - 12)
      lg.setColor(0, 0, 0)
      lg.rectangle("line", GAME_WIDTH / 2 + 4, 8, GAME_WIDTH / 2 - 12, GAME_HEIGHT / 2 - 12)
      if self:selectedItem() ~= nil then
        lg.printf(self:selectedItem().desc, GAME_WIDTH / 2 + 7, 8, GAME_WIDTH / 2 - 18)
      end
      return self.state:draw()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent)
      self.parent = parent
      self.state = State(self)
      self.selectedIndex = nil
    end,
    __base = _base_0,
    __name = "GameInventoryState",
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
  GameInventoryState = _class_0
end
