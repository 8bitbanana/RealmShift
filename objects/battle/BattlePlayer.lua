local DAMAGE_FORMULA = {
  aw = 1,
  dw = 1.05,
  bd = 15,
  vm = 0.25,
  va = 2
}
do
  local _class_0
  local _base_0 = {
    init = function(self)
      self.hp = self.stats.hp
    end,
    takeDamage = function(self, incomingattack)
      local damage = math.floor((DAMAGE_FORMULA.va + (DAMAGE_FORMULA.vm * ((incomingattack * DAMAGE_FORMULA.aw) - (self.stats.defence * DAMAGE_FORMULA.dw)))) * DAMAGE_FORMULA.bd)
      if damage < 1 then
        damage = 1
      end
      self.hp = self.hp - damage
      if self.hp < 0 then
        self.hp = 0
      end
    end,
    attack = function(self, target)
      return target:takeDamage(self.stats.attack)
    end,
    skillPrimary = function(self, target) end,
    skillSecondary = function(self, target) end,
    draw = function(self, overwrite)
      if overwrite == nil then
        overwrite = true
      end
      if overwrite then
        lg.setColor(ORANGE)
      end
      lg.rectangle("fill", self.pos.x, self.pos.y - 32, 24, 32)
      lg.setColor(BLACK)
      return lg.rectangle("line", self.pos.x, self.pos.y - 32, 24, 32)
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
      return lg.print("M", self.pos.x, self.pos.y)
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
      return self:init()
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
      return lg.print("F", self.pos.x, self.pos.y)
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
      return self:init()
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
      return lg.print("P", self.pos.x, self.pos.y)
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
      return self:init()
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
      return lg.print("R", self.pos.x, self.pos.y)
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
      return self:init()
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
