local DAMAGE_FORMULA = {
  aw = 1,
  dw = 1.2,
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
      print("I took " .. damage .. " damage (" .. incomingattack .. "ATK " .. self.stats.defence .. "DEF)")
      if self.hp < 0 then
        self.hp = 0
      end
    end,
    attack = function(self, target, damageOverride)
      if damageOverride then
        return target:takeDamage(damageOverride)
      else
        return target:takeDamage(self.stats.attack)
      end
    end,
    skillPrimaryInfo = function(self)
      return {
        name = "SKILLPRIMARY"
      }
    end,
    skillSecondaryInfo = function(self)
      return {
        name = "SKILLSECONDARY"
      }
    end,
    skillPrimary = function(self) end,
    skillSecondary = function(self) end,
    isValidTarget = function(self, targetType)
      local _exp_0 = targetType
      if "attack" == _exp_0 then
        return self.hp > 0
      elseif "move" == _exp_0 then
        return self.parent.currentTurn ~= self
      elseif "always" == _exp_0 then
        return true
      else
        return error("isValidTarget - Invalid target type - " .. targetType)
      end
    end,
    getCursorPos = function(self)
      return {
        x = self.pos.x + 0,
        y = self.pos.y - 49
      }
    end,
    draw = function(self)
      if self.hp == 0 then
        return self:draw_dead()
      else
        self:draw_alive()
        return self:draw_health()
      end
    end,
    draw_health = function(self)
      lg.printf(self.hp, self.pos.x + 2, self.pos.y, 20, "left")
      return lg.printf(self.stats.hp, self.pos.x + 2, self.pos.y + 12, 20, "right")
    end,
    draw_alive = function(self, overwrite)
      if overwrite == nil then
        overwrite = false
      end
      if overwrite then
        lg.setColor(ORANGE)
      end
      lg.rectangle("fill", self.pos.x, self.pos.y - 32, 24, 32)
      lg.setColor(BLACK)
      return lg.rectangle("line", self.pos.x, self.pos.y - 32, 24, 32)
    end,
    draw_dead = function(self)
      lg.setColor(GRAY)
      lg.rectangle("fill", self.pos.x, self.pos.y - 32, 24, 32)
      lg.setColor(BLACK)
      return lg.rectangle("line", self.pos.x, self.pos.y - 32, 24, 32)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, parent, pos)
      self.parent, self.pos = parent, pos
      self.stats = {
        hp = 0,
        attack = 0,
        defence = 0,
        speed = 0,
        magic = 0
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
    draw_alive = function(self)
      lg.setColor(MAGE_COL)
      return _class_0.__parent.__base.draw_alive(self, false)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
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
    skillPrimaryInfo = function(self)
      return {
        name = "LUNGE"
      }
    end,
    skillPrimary = function(self)
      local myindex = nil
      for i, player in pairs(self.parent.players) do
        if player == self then
          myindex = i
        end
      end
      assert(myindex ~= nil)
      local damage = self.stats.attack * myindex / 2
      self.parent.selectionCallback = function(self, index)
        local shovescene = CutsceneShove({
          tts = 0,
          dir = -4
        })
        local attackscene = CutsceneAttack({
          tts = 6,
          index = index,
          damage = damage
        })
        self.cutscenes:addCutscene(shovescene)
        self.cutscenes:addCutscene(attackscene)
        return self.state:changeState(BattleTurnState, {
          ttl = 30
        })
      end
      return self.parent.state:changeState(BattleEnemySelectState)
    end,
    draw_alive = function(self)
      lg.setColor(FIGHTER_COL)
      return _class_0.__parent.__base.draw_alive(self, false)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
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
    draw_alive = function(self)
      lg.setColor(PALADIN_COL)
      return _class_0.__parent.__base.draw_alive(self, false)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
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
    draw_alive = function(self)
      lg.setColor(ROGUE_COL)
      return _class_0.__parent.__base.draw_alive(self, false)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
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
