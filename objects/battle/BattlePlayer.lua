local BattlePlayer
do
  local _class_0
  local _base_0 = {
    draw = function(self)
      lg.setColor(ORANGE)
      lg.rectangle("fill", self.pos.x, self.pos.y, 24, 32)
      lg.setColor(BLACK)
      return lg.rectangle("line", self.pos.x, self.pos.y, 24, 32)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.stats = {
        hp = 0,
        attack = 0,
        defence = 0,
        speed = 0,
        magic = 0
      }
      self.pos = {
        x = 0,
        y = 0
      }
    end,
    __base = _base_0,
    __name = "BattlePlayer"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  BattlePlayer = _class_0
end
do
  local _class_0
  local _parent_0 = BattlePlayer
  local _base_0 = {
    draw = function(self)
      _class_0.__parent.__base.draw(self)
      lg.setColor(BLACK)
      return lg.print("M", self.pos.x + 2, self.pos.y + 2)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      _class_0.__parent.__init(self)
      self.stats.hp = 50
      self.stats.attack = 3
      self.stats.defence = 2
      self.stats.speed = 5
      self.stats.magic = 10
    end,
    __base = _base_0,
    __name = "Mage",
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
  Mage = _class_0
end
do
  local _class_0
  local _parent_0 = BattlePlayer
  local _base_0 = {
    draw = function(self)
      _class_0.__parent.__base.draw(self)
      lg.setColor(BLACK)
      return lg.print("F", self.pos.x + 2, self.pos.y + 2)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      _class_0.__parent.__init(self)
      self.stats.hp = 50
      self.stats.attack = 8
      self.stats.defence = 4
      self.stats.speed = 7
      self.stats.magic = 2
    end,
    __base = _base_0,
    __name = "Fighter",
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
  Fighter = _class_0
end
do
  local _class_0
  local _parent_0 = BattlePlayer
  local _base_0 = {
    draw = function(self)
      _class_0.__parent.__base.draw(self)
      lg.setColor(BLACK)
      return lg.print("P", self.pos.x + 2, self.pos.y + 2)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      _class_0.__parent.__init(self)
      self.stats.hp = 50
      self.stats.attack = 5
      self.stats.defence = 8
      self.stats.speed = 3
      self.stats.magic = 6
    end,
    __base = _base_0,
    __name = "Paladin",
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
  Paladin = _class_0
end
do
  local _class_0
  local _parent_0 = BattlePlayer
  local _base_0 = {
    draw = function(self)
      _class_0.__parent.__base.draw(self)
      lg.setColor(BLACK)
      return lg.print("R", self.pos.x + 2, self.pos.y + 2)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      _class_0.__parent.__init(self)
      self.stats.hp = 50
      self.stats.attack = 9
      self.stats.defence = 2
      self.stats.speed = 8
      self.stats.magic = 2
    end,
    __base = _base_0,
    __name = "Rogue",
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
  Rogue = _class_0
end
