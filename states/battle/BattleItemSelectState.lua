do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    init = function(self)
      return self:updateCursorPos()
    end,
    scrollTo = function(self, index)
      if index == nil then
        index = self.selectedIndex
      end
      if index < self.scrollWindow.top then
        local difference = self.scrollWindow.top - index
        self.scrollWindow.top = self.scrollWindow.top - difference
        self.scrollWindow.bottom = self.scrollWindow.bottom - difference
      else
        if index > self.scrollWindow.bottom then
          local difference = index - self.scrollWindow.bottom
          self.scrollWindow.top = self.scrollWindow.top + difference
          self.scrollWindow.bottom = self.scrollWindow.bottom + difference
        end
      end
    end,
    getScrolledIndex = function(self, index)
      if index == nil then
        index = self.selectedIndex
      end
      return index - self.scrollWindow.top + 1
    end,
    selectedItem = function(self)
      return self.items[self.selectedIndex]
    end,
    updateCursorPos = function(self)
      self.cursor.pos = {
        x = 6,
        y = (self:getScrolledIndex() * 16) - 9
      }
    end,
    moveItemCursor = function(self, dir)
      self.selectedIndex = self.selectedIndex + dir
      if self.selectedIndex < 1 then
        self.selectedIndex = 1
      end
      if self.selectedIndex > #self.items then
        self.selectedIndex = #self.items
      end
      self:scrollTo()
      return self:updateCursorPos()
    end,
    select = function(self)
      return self.parent:selectionCallback(self.selectedIndex)
    end,
    back = function(self)
      return self.parent:turnStart()
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
      return self.cursor:update()
    end,
    draw = function(self)
      lg.setColor(1, 1, 1)
      lg.rectangle("fill", 116, 4, 116, 50)
      lg.setColor(0, 0, 0, 1)
      lg.rectangle("line", 116, 4, 116, 50)
      local currentIndex = 0
      for i = self.scrollWindow.top, self.scrollWindow.bottom do
        local item = self.items[i]
        if item then
          lg.print(item.name, 21, 11 + (currentIndex * 16))
          currentIndex = currentIndex + 1
        end
      end
      return self.cursor:draw()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent)
      self.parent = parent
      self.items = game.inventory.items
      self.selectedIndex = 1
      self.cursor = Cursor({
        x = 0,
        y = 0
      }, "right")
      self.scrollWindow = {
        top = 1,
        bottom = 5
      }
    end,
    __base = _base_0,
    __name = "BattleItemSelectState",
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
  BattleItemSelectState = _class_0
end
