do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    init = function(self)
      return self:updateCursorPos()
    end,
    selectedItem = function(self)
      return self.items[self.selected]
    end,
    update = function(self)
      if input:pressed("up") then
        self:moveItemCursor(-1)
      end
      if input:pressed("down") then
        self:moveItemCursor(1)
      end
      if input:pressed("confirm") then
        self:select()
      end
      return self.cursor:update()
    end,
    moveItemCursor = function(self, dir)
      self.selected = self.selected + dir
      if self.selected < 1 then
        self.selected = 1
      end
      if self.selected > #self.items then
        self.selected = #self.items
      end
      return self:updateCursorPos()
    end,
    select = function(self)
      if self.items[self.selected] ~= nil then
        return self.parent.state:changeState(InventoryActionState)
      end
    end,
    updateCursorPos = function(self)
      self.cursor.pos = {
        x = 6,
        y = (self.selected * 16) - 9
      }
      self.parent.selectedIndex = self.selected
    end,
    draw = function(self)
      if self.items[self.selected] ~= nil then
        return self.cursor:draw()
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent)
      self.parent = parent
      self.selected = self.parent.selectedIndex
      self.cursor = Cursor({
        x = 0,
        y = 0
      }, "right")
      self.items = game.inventory.items
    end,
    __base = _base_0,
    __name = "InventoryItemState",
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
  InventoryItemState = _class_0
end
