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
      self.text = self.parent.parent:currentTurn():skillPrimaryInfo().name
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
      self.text = self.parent.parent:currentTurn():skillSecondaryInfo().name
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
        return self:selectedItem():clicked()
      end
    end,
    moveItemCursor = function(self, dir)
      local newindex = self.selectedIndex + dir
      if newindex < 1 then
        return 
      end
      if newindex > 2 then
        return 
      end
      self.selectedIndex = newindex
      self.cursor.pos = {
        x = self:selectedItem().pos.x - 15,
        y = self:selectedItem().pos.y - 4
      }
    end,
    draw = function(self)
      lg.setColor(1, 1, 1, 1)
      lg.rectangle("fill", 116, 4, 116, 50)
      lg.setColor(0, 0, 0, 1)
      lg.rectangle("line", 116, 4, 116, 50)
      lg.setColor(1, 1, 1, 1)
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
        PrimaryMenuItem(self, {
          x = 130,
          y = 11
        }),
        SecondaryMenuItem(self, {
          x = 130,
          y = 30
        })
      }
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
