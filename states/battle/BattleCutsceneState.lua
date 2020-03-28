require("states/state")
require("utils_vector")
local Inspect = require("lib/Inspect")
do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    init = function(self)
      self.totalTime = 60
    end,
    incTime = function(self)
      if self.currentTime >= self.totalTime then
        self.parent:cutsceneCallback(self.args.index)
        self.done = true
      end
      self.currentTime = self.currentTime + 1
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent, args)
      self.parent, self.args = parent, args
      self.callback = callback
      self.done = false
      self.currentTime = 0
    end,
    __base = _base_0,
    __name = "BattleCutsceneState",
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
  BattleCutsceneState = _class_0
end
do
  local _class_0
  local _parent_0 = BattleCutsceneState
  local _base_0 = {
    init = function(self)
      self.totalTime = 30
      self.attacked = false
    end,
    update = function(self)
      self:incTime()
      if self.done then
        return 
      end
      if self.currentTime > 15 and not self.attacked then
        self.attacked = true
        return self.parent:cutsceneAttackCallback()
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
    __name = "BCPlayerAttackState",
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
  BCPlayerAttackState = _class_0
end
do
  local _class_0
  local _parent_0 = BattleCutsceneState
  local _base_0 = {
    init = function(self)
      self.totalTime = 25
      self.playerA = self.parent.currentTurn
      self.playerB = self.parent.players[self.args.index]
      assert(self.playerA ~= self.playerB)
      self.posA = self.playerA.pos
      if self.playerB then
        self.posB = self.playerB.pos
      else
        self.posB = self.parent:getPlayerIndexPos(self.args.index)
      end
    end,
    update = function(self)
      self:incTime()
      if self.done then
        return 
      end
      local progress = self.currentTime / self.totalTime
      self.playerA.pos = vector.lerp(self.posA, self.posB, progress)
      if self.playerB ~= nil then
        self.playerB.pos = vector.lerp(self.posB, self.posA, progress)
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
    __name = "BCMoveState",
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
  BCMoveState = _class_0
end
