require("states/state")
local Inspect = require("lib/inspect")
local PrimaryMenuItem
do
  local _class_0
  local _parent_0 = MenuItem
  local _base_0 = {
    activate = function(self)
      return self.parent.parent:currentTurn():skillPrimary()
    end,
    valid = function(self)
      return true
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
      self.text = self.parent.parent:currentTurn().skillPrimaryInfo.name
      self.desc = self.parent.parent:currentTurn().skillPrimaryInfo.desc
    end,
    __base = _base_0,
    __name = "PrimaryMenuItem",
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
  PrimaryMenuItem = _class_0
end
local SecondaryMenuItem
do
  local _class_0
  local _parent_0 = MenuItem
  local _base_0 = {
    activate = function(self)
      return self.parent.parent:currentTurn():skillSecondary()
    end,
    valid = function(self)
      return true
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
      self.text = self.parent.parent:currentTurn().skillSecondaryInfo.name
      self.desc = self.parent.parent:currentTurn().skillSecondaryInfo.desc
    end,
    __base = _base_0,
    __name = "SecondaryMenuItem",
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
  SecondaryMenuItem = _class_0
end
do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    drawMenu = function(self)
      for index, item in pairs(self.items) do
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
        self:selectedItem():clicked()
      end
      if input:pressed("back") then
        return self.parent:turnStart()
      end
    end,
    moveItemCursor = function(self, dir)
      local newindex = self.selectedIndex + dir
      if newindex < 1 then
        return 
      end
      if newindex > #self.items then
        return 
      end
      self.selectedIndex = newindex
      self.cursor.pos = {
        x = self:selectedItem().pos.x - 15,
        y = self:selectedItem().pos.y - 4
      }
    end,
    draw = function(self)
      lg.setColor(1, 1, 1)
      lg.rectangle("fill", 8, 8, GAME_WIDTH / 2 - 12, 16 * 2 + 4)
      lg.setColor(0, 0, 0)
      lg.rectangle("line", 8, 8, GAME_WIDTH / 2 - 12, 16 * 2 + 4)
      self:drawMenu()
      self.cursor:draw()
      lg.setColor(1, 1, 1)
      lg.rectangle("fill", GAME_WIDTH / 2 + 4, 8, GAME_WIDTH / 2 - 12, 16 * 5)
      lg.setColor(0, 0, 0)
      lg.rectangle("line", GAME_WIDTH / 2 + 4, 8, GAME_WIDTH / 2 - 12, 16 * 5)
      if self:selectedItem() and self:selectedItem().desc then
        lg.setFont(dialog_font)
        lg.printf(self:selectedItem().desc, GAME_WIDTH / 2 + 7, 8, GAME_WIDTH / 2 - 18)
        return lg.setFont(default_font)
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent)
      self.parent = parent
      self.items = { }
      if not self.parent:currentTurn().skillPrimaryInfo.unset then
        table.insert(self.items, PrimaryMenuItem(self, {
          x = 21,
          y = 11
        }))
      end
      if not self.parent:currentTurn().skillSecondaryInfo.unset then
        table.insert(self.items, SecondaryMenuItem(self, {
          x = 21,
          y = 27
        }))
      end
      self.selectedIndex = 1
      self.cursor = Cursor({
        x = self:selectedItem().pos.x - 15,
        y = self:selectedItem().pos.y - 4
      }, "right")
    end,
    __base = _base_0,
    __name = "BattleSkillSelectState",
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
  BattleSkillSelectState = _class_0
end
