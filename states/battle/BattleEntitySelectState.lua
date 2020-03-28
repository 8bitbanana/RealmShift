require("states/state")
require("utils_vector")
local Inspect = require("lib/inspect")
do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    init = function(self)
      assert(self.entities ~= nil)
      assert(#self.entities > 0)
      self.cursor = Cursor({
        x = 0,
        y = 0
      }, "down")
      for i, entity in pairs(self.entities) do
        if self:isValidTarget(i) then
          self.selectedIndex = i
          break
        end
      end
      return self:moveCursor(0)
    end,
    isValidTarget = function(self, index)
      local entity = self.entities[index]
      if entity == nil then
        return false
      else
        return entity:isValidTarget(self.targetType)
      end
    end,
    moveCursor = function(self, dir)
      local newindex = self.selectedIndex
      while true do
        newindex = newindex + dir
        if newindex < 1 then
          break
        end
        if newindex > #self.entities then
          break
        end
        if self:isValidTarget(newindex) then
          break
        end
      end
      if self:isValidTarget(newindex) then
        self.selectedIndex = newindex
        return self:setCursor(newindex)
      end
    end,
    setCursor = function(self, index)
      local entity = self.entities[index]
      self.cursor.pos = entity:getCursorPos()
    end,
    confirm = function(self)
      return self.parent:selectionCallback(self.selectedIndex)
    end,
    update = function(self)
      self.cursor:update()
      if input:pressed("left") then
        self:moveCursor(-1)
      end
      if input:pressed("right") then
        self:moveCursor(1)
      end
      if input:pressed("confirm") then
        return self:confirm()
      end
    end,
    draw = function(self)
      return self.cursor:draw()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent)
      self.parent = parent
      self.selectedIndex = 1
      self.cursor = nil
      self.entities = nil
      self.targetType = nil
    end,
    __base = _base_0,
    __name = "BattleEntitySelectState",
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
  BattleEntitySelectState = _class_0
end
do
  local _class_0
  local _parent_0 = BattleEntitySelectState
  local _base_0 = {
    init = function(self)
      self.entities = self.parent.enemies
      self.targetType = "attack"
      return _class_0.__parent.__base.init(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "BattleEnemySelectState",
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
  BattleEnemySelectState = _class_0
end
do
  local _class_0
  local _parent_0 = BattleEntitySelectState
  local _base_0 = {
    init = function(self)
      self.entities = self.parent.players
      return _class_0.__parent.__base.init(self)
    end,
    setCursor = function(self, index)
      self.cursor.pos = {
        x = 92 + 28 * index,
        y = 78
      }
    end,
    isValidTarget = function(self, index)
      if index < 1 then
        return false
      end
      if index > 4 then
        return false
      end
      if self.entities[index] == self.parent.currentTurn then
        return false
      end
      return true
    end,
    drawarc = function(self)
      local startpos = vector.add(self.parent.currentTurn:getCursorPos(), {
        x = 12,
        y = 16
      })
      local endpos = vector.add(self.cursor.pos, {
        x = 12,
        y = 6
      })
      endpos.y = endpos.y + math.floor(self.cursor.posoffset.y)
      local control1 = startpos
      local control2 = endpos
      if startpos.x > endpos.x then
        control1 = vector.add(control1, {
          x = -5,
          y = -20
        })
        control2 = vector.add(control2, {
          x = 5,
          y = -20
        })
      else
        control1 = vector.add(control1, {
          x = 5,
          y = -20
        })
        control2 = vector.add(control2, {
          x = -5,
          y = -20
        })
      end
      local points = { }
      local STEPS = 8
      for i = 0, STEPS do
        local progress = i / STEPS
        local point = vector.bezier3(startpos, control1, control2, endpos, progress)
        table.insert(points, point.x)
        table.insert(points, point.y)
      end
      lg.setColor(BLACK)
      return lg.line(points)
    end,
    draw = function(self)
      self:drawarc()
      return self.cursor:draw()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "BattleSpaceSelectState",
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
  BattleSpaceSelectState = _class_0
end
do
  local _class_0
  local _parent_0 = BattleEntitySelectState
  local _base_0 = {
    init = function(self)
      self.entities = self.parent.players
      self.targetType = "move"
      return _class_0.__parent.__base.init(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "BattlePlayerSelectState",
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
  BattlePlayerSelectState = _class_0
end
