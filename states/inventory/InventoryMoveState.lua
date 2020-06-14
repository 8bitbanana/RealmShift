do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    init = function(self)
      return self:updateCursorPos()
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
      if input:pressed("back") then
        self:back()
      end
      return self.cursorEnd:update()
    end,
    moveItemCursor = function(self, dir)
      local newindex = self.selected
      while true do
        newindex = newindex + dir
        if newindex < 1 then
          break
        end
        if newindex > #self.items then
          break
        end
        if newindex ~= self.parent.selectedIndex then
          break
        end
      end
      if self.items[newindex] ~= nil then
        self.selected = newindex
        self.parent:scrollTo(self.selected)
        return self:updateCursorPos()
      end
    end,
    updateCursorPos = function(self)
      self.cursorStart.pos = {
        x = 6,
        y = (self.parent:getScrolledIndex() * 16) - 9
      }
      self.cursorEnd.pos = {
        x = 6,
        y = (self.parent:getScrolledIndex(self.selected) * 16) - 9
      }
    end,
    select = function(self)
      self.parent:swapCurrentItem(self.selected)
      self.parent.selectedIndex = self.selected
      self.parent:scrollTo()
      return self:changeState(InventoryItemState)
    end,
    back = function(self)
      self.parent:scrollTo()
      return self:changeState(InventoryActionState)
    end,
    draw = function(self)
      self.cursorStart:draw()
      return self.cursorEnd:draw()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent)
      self.parent = parent
      self.cursorStart = Cursor({
        x = 0,
        y = 0
      }, "right")
      self.cursorEnd = Cursor({
        x = 0,
        y = 0
      }, "right")
      self.items = game.inventory.items
      if self.parent.selectedIndex >= #self.items then
        self.selected = self.parent.selectedIndex - 1
      else
        self.selected = self.parent.selectedIndex + 1
      end
      return self.parent:scrollTo(self.selected)
    end,
    __base = _base_0,
    __name = "InventoryMoveState",
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
  InventoryMoveState = _class_0
end
