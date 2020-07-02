require("states/state")
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
      if self.params.selectedIndex then
        self.selectedIndex = self.params.selectedIndex
        assert(self:isValidTarget(self.selectedIndex))
      else
        for i, entity in pairs(self.entities) do
          if self:isValidTarget(i) then
            self.selectedIndex = i
            break
          end
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
        self:confirm()
      end
      if input:pressed("back") then
        return self.parent:turnStart()
      end
    end,
    draw = function(self)
      if self.params.prompt then
        lg.setFont(dialog_font)
        lg.setColor(1, 1, 1)
        lg.rectangle("fill", 3, 3, GAME_WIDTH - 6, 50)
        lg.setColor(0, 0, 0)
        lg.rectangle("line", 3, 3, GAME_WIDTH - 6, 50)
        lg.printf(self.params.prompt, 6, 6, GAME_WIDTH - 12)
        lg.setFont(default_font)
      end
      return self.cursor:draw()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent, params)
      self.parent, self.params = parent, params
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
      self.startindex = nil
      if self.params.selectedspace ~= nil then
        self.startindex = self.params.selectedspace
        self.startpos = {
          x = 104 + 28 * self.params.selectedspace,
          y = 94
        }
      end
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
      if index == self.startindex then
        return false
      end
      return true
    end,
    drawarc = function(self)
      local startpos = self.startpos
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
      _class_0.__parent.__base.draw(self)
      if self.startindex ~= nil then
        return self:drawarc()
      end
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
      self.targetType = "always"
      if self.params.targetType then
        self.targetType = self.params.targetType
      end
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
