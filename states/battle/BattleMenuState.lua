require("states/state")
local Inspect = require("lib/inspect")
local WRAP_ITEM_CURSOR = false
do
  local _class_0
  local _base_0 = {
    text = "NULL",
    clicked = function(self)
      if self:valid() then
        return self:activate()
      end
    end,
    activate = function(self) end,
    valid = function(self)
      return false
    end,
    draw = function(self)
      if self:valid() then
        lg.setColor(BLACK)
      else
        lg.setColor(GRAY)
      end
      return lg.print(self.text, self.pos.x, self.pos.y)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, parent, pos)
      self.parent, self.pos = parent, pos
      self.cursor = Cursor({
        x = self.pos.x - 15,
        y = self.pos.y - 4
      }, "right")
    end,
    __base = _base_0,
    __name = "MenuItem"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  MenuItem = _class_0
end
local AttackMenuItem
do
  local _class_0
  local _parent_0 = MenuItem
  local _base_0 = {
    text = "ATTACK",
    activate = function(self)
      return self.parent.parent:attackAction()
    end,
    valid = function(self)
      local validtargets = 0
      local _list_0 = self.parent.parent.enemies
      for _index_0 = 1, #_list_0 do
        local enemy = _list_0[_index_0]
        if enemy:isValidTarget("attack") then
          validtargets = validtargets + 1
        end
      end
      return validtargets > 0
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "AttackMenuItem",
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
  AttackMenuItem = _class_0
end
local MoveMenuItem
do
  local _class_0
  local _parent_0 = MenuItem
  local _base_0 = {
    text = "dbgmove",
    activate = function(self)
      return self.parent.parent:swapAction()
    end,
    valid = function(self)
      local validtargets = 0
      local _list_0 = self.parent.parent.enemies
      for _index_0 = 1, #_list_0 do
        local enemy = _list_0[_index_0]
        if enemy:isValidTarget("move") then
          validtargets = validtargets + 1
        end
      end
      return validtargets > 0
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "MoveMenuItem",
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
  MoveMenuItem = _class_0
end
local WaitMenuItem
do
  local _class_0
  local _parent_0 = MenuItem
  local _base_0 = {
    text = "WAIT",
    activate = function(self)
      return self.parent.parent:waitAction()
    end,
    valid = function(self)
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
    __name = "WaitMenuItem",
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
  WaitMenuItem = _class_0
end
local SkillMenuItem
do
  local _class_0
  local _parent_0 = MenuItem
  local _base_0 = {
    text = "SKILL",
    activate = function(self)
      return self.parent.parent:skillAction()
    end,
    valid = function(self)
      return self.parent.parent.currentTurn.__class == Fighter
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "SkillMenuItem",
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
  SkillMenuItem = _class_0
end
local ItemMenuItem
do
  local _class_0
  local _parent_0 = MenuItem
  local _base_0 = {
    text = "ITEM",
    valid = function(self)
      return false
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "ItemMenuItem",
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
  ItemMenuItem = _class_0
end
local EmptyMenuItem
do
  local _class_0
  local _parent_0 = MenuItem
  local _base_0 = {
    text = "",
    valid = function(self)
      return false
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "EmptyMenuItem",
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
  EmptyMenuItem = _class_0
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
      if input:pressed("left") then
        self:moveItemCursor(-2)
      end
      if input:pressed("right") then
        self:moveItemCursor(2)
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
      if newindex > 4 then
        return 
      end
      if self.selectedIndex == 2 and dir == 1 then
        return 
      end
      if self.selectedIndex == 3 and dir == -1 then
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
      local selectedX = self.parent.currentTurn.pos.x
      lg.polygon("fill", selectedX + 2, 53, selectedX + 12, 91, selectedX + 22, 53)
      lg.setColor(0, 0, 0, 1)
      lg.line(selectedX + 2, 53, selectedX + 12, 91, selectedX + 22, 53)
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
        AttackMenuItem(self, {
          x = 130,
          y = 11
        }),
        WaitMenuItem(self, {
          x = 130,
          y = 30
        }),
        SkillMenuItem(self, {
          x = 195,
          y = 11
        }),
        MoveMenuItem(self, {
          x = 195,
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
    __name = "BattleMenuState",
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
  BattleMenuState = _class_0
end
