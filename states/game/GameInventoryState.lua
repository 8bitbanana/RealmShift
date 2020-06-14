local Inspect = require("lib/inspect")
do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
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
      return self.parent.inventory.items[self.selectedIndex]
    end,
    init = function(self)
      return self.state:changeState(InventoryItemState)
    end,
    useCurrentItem = function(self)
      game.inventory:useItem(self.selectedIndex)
      if self.selectedIndex > #self.parent.inventory.items then
        self.selectedIndex = #self.parent.inventory.items
      end
      return self:scrollTo()
    end,
    swapCurrentItem = function(self, index)
      local temp = game.inventory.items[self.selectedIndex]
      game.inventory.items[self.selectedIndex] = game.inventory.items[index]
      game.inventory.items[index] = temp
    end,
    tossCurrentItem = function(self)
      game.inventory:removeItem(self.selectedIndex)
      if self.selectedIndex > #self.parent.inventory.items then
        self.selectedIndex = #self.parent.inventory.items
      end
      return self:scrollTo()
    end,
    update = function(self)
      self.state:update()
      return self.dialog:update()
    end,
    draw = function(self)
      lg.clear(0, 0, 0)
      lg.setColor(1, 1, 1)
      lg.rectangle("fill", 8, 8, GAME_WIDTH / 2 - 12, GAME_HEIGHT - 16)
      lg.setColor(0, 0, 0)
      lg.rectangle("line", 8, 8, GAME_WIDTH / 2 - 12, GAME_HEIGHT - 16)
      local currentIndex = 0
      for i = self.scrollWindow.top, self.scrollWindow.bottom do
        local item = self.parent.inventory.items[i]
        if item then
          lg.print(item.name, 21, 11 + (currentIndex * 16))
          currentIndex = currentIndex + 1
        end
      end
      lg.setColor(1, 1, 1)
      lg.rectangle("fill", GAME_WIDTH / 2 + 4, 8, GAME_WIDTH / 2 - 12, GAME_HEIGHT / 2 - 12)
      lg.setColor(0, 0, 0)
      lg.rectangle("line", GAME_WIDTH / 2 + 4, 8, GAME_WIDTH / 2 - 12, GAME_HEIGHT / 2 - 12)
      if self:selectedItem() ~= nil then
        lg.printf(self:selectedItem().desc, GAME_WIDTH / 2 + 7, 8, GAME_WIDTH / 2 - 18)
      end
      self.state:draw()
      return self.dialog:draw()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent)
      self.parent = parent
      self.dialog = DialogManager()
      self.state = State(self)
      self.selectedIndex = 1
      self.scrollWindow = {
        top = 1,
        bottom = 8
      }
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
