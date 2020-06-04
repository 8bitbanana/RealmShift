do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    init = function(self)
      self.ttl = self.args.ttl
      self.done = false
    end,
    update = function(self)
      if not self.done then
        self.ttl = self.ttl - 1
      end
      if self.ttl <= 0 and not self.done then
        self.done = true
        return self.parent:turnEnd()
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent, args)
      self.parent, self.args = parent, args
    end,
    __base = _base_0,
    __name = "BattleTurnState",
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
  BattleTurnState = _class_0
end
do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    init = function(self)
      self.ttl = 60
      if self.args.ttl then
        self.ttl = self.args.ttl
      end
    end,
    update = function(self)
      if not self.done then
        self.ttl = self.ttl - 1
      end
      if self.ttl <= 0 and not self.done then
        self.done = true
        return self.parent:turnStart()
      end
    end,
    draw = function(self)
      return lg.print("TurnIntro", 10, 10)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent, args)
      if args == nil then
        args = { }
      end
      self.parent, self.args = parent, args
    end,
    __base = _base_0,
    __name = "TurnIntroState",
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
  TurnIntroState = _class_0
end
