local UseItemMenuItem
do
  local _class_0
  local _parent_0 = MenuItem
  local _base_0 = {
    text = "Use",
    valid = function(self)
      return self.parent.parent:selectedItem():is_usable()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "UseItemMenuItem",
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
  UseItemMenuItem = _class_0
end
local MoveItemMenuItem
do
  local _class_0
  local _parent_0 = MenuItem
  local _base_0 = {
    text = "Move",
    valid = function(self)
      return #game.inventory.items > 1
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "MoveItemMenuItem",
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
  MoveItemMenuItem = _class_0
end
local TossItemMenuItem
do
  local _class_0
  local _parent_0 = MenuItem
  local _base_0 = {
    text = "Toss",
    valid = function(self)
      return true
    end,
    activate = function(self)
      local itemname = self.parent.parent:selectedItem().name
      game.dialog:setTree(DialogTree({
        DialogBox("Are you sure you want to toss\nthe " .. tostring(itemname) .. "?", {
          "Yes",
          "No"
        }),
        DialogBox("You tossed the " .. tostring(itemname) .. ".")
      }, {
        [1] = {
          2,
          nil
        }
      }, {
        [1] = function(option)
          if option == 1 then
            return game.state:tossCurrentItem()
          end
        end
      }))
      return self.parent.parent.state:changeState(InventoryWaitState)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "TossItemMenuItem",
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
  TossItemMenuItem = _class_0
end
do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    updateCursorPos = function(self)
      self.cursor.pos = {
        x = self:selectedItem().pos.x - 16,
        y = self:selectedItem().pos.y - 4
      }
    end,
    drawMenu = function(self)
      local _list_0 = self.items
      for _index_0 = 1, #_list_0 do
        local item = _list_0[_index_0]
        item:draw()
      end
    end,
    selectedItem = function(self)
      return self.items[self.selectedIndex]
    end,
    update = function(self)
      self.cursor:update()
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
      return self:updateCursorPos()
    end,
    select = function(self)
      return self:selectedItem():clicked()
    end,
    back = function(self)
      return self.parent.state:changeState(InventoryItemState)
    end,
    moveItemCursor = function(self, dir)
      self.selectedIndex = self.selectedIndex + dir
      if self.selectedIndex < 1 then
        self.selectedIndex = 1
      end
      if self.selectedIndex > #self.items then
        self.selectedIndex = #self.items
      end
    end,
    draw = function(self)
      lg.setColor(1, 1, 1)
      lg.rectangle("fill", GAME_WIDTH / 2 + 4, GAME_HEIGHT / 2 + 4, GAME_WIDTH / 2 - 12, GAME_HEIGHT / 2 - 12)
      lg.setColor(0, 0, 0)
      lg.rectangle("line", GAME_WIDTH / 2 + 4, GAME_HEIGHT / 2 + 4, GAME_WIDTH / 2 - 12, GAME_HEIGHT / 2 - 12)
      self:drawMenu()
      return self.cursor:draw()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent)
      self.parent = parent
      self.items = {
        UseItemMenuItem(self, {
          x = GAME_WIDTH / 2 + 21,
          y = GAME_HEIGHT / 2 + 7
        }),
        MoveItemMenuItem(self, {
          x = GAME_WIDTH / 2 + 21,
          y = GAME_HEIGHT / 2 + 22
        }),
        TossItemMenuItem(self, {
          x = GAME_WIDTH / 2 + 21,
          y = GAME_HEIGHT / 2 + 37
        })
      }
      self.selectedIndex = 1
      self.cursor = Cursor({
        x = 0,
        y = 0
      }, "right")
      return self:updateCursorPos()
    end,
    __base = _base_0,
    __name = "InventoryActionState",
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
  InventoryActionState = _class_0
end
