require("objects.battle.BattlePlayer")
do
  local _class_0
  local _parent_0 = BattlePlayer
  local _base_0 = {
    name = "BattleEnemy",
    chooseTarget = function(self)
      local indexes = { }
      for i, target in pairs(self.parent:inactiveEntities()) do
        local _continue_0 = false
        repeat
          if target == nil then
            _continue_0 = true
            break
          end
          if not target:isValidTarget("attack") then
            _continue_0 = true
            break
          end
          table.insert(indexes, i)
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
      local targetindex = indexes[love.math.random(#indexes)]
      return targetindex
    end,
    attack = function(self, target, damageOverride)
      local damage = nil
      if damageOverride then
        damage = damageOverride
      else
        damage = self.stats.attack
      end
      return target:takeDamage(damage)
    end,
    enemyTurn = function(self)
      local targetindex = self:chooseTarget()
      local damage = self.stats.attack
      if self.spaceDamage then
        print("Enemy damage multi " .. self.spaceDamage[targetindex])
        damage = damage * self.spaceDamage[targetindex]
      end
      local attackScene = CutsceneAttack({
        tts = 0.33,
        index = targetindex,
        damage = damage
      })
      self.parent.cutscenes:addCutscene(attackScene)
      return self.parent.state:changeState(BattleTurnState, {
        ttl = 0.66
      })
    end,
    getCursorPos = function(self)
      return {
        x = self.pos.x + 3,
        y = self.pos.y - 68
      }
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
      self.basestats.hp = 100
      self.basestats.attack = 3
      self.basestats.defence = 4
      self.basestats.speed = 2
      self.size = {
        w = 30,
        h = 48
      }
      return self:init()
    end,
    __base = _base_0,
    __name = "BattleEnemy",
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
  BattleEnemy = _class_0
end
do
  local _class_0
  local _parent_0 = BattleEnemy
  local _base_0 = {
    name = "Archer",
    chooseTarget = function(self)
      for i = 4, 1, -1 do
        local _continue_0 = false
        repeat
          do
            local target = self.parent:inactiveEntities()[i]
            if target == nil then
              _continue_0 = true
              break
            end
            if not target:isValidTarget("attack") then
              _continue_0 = true
              break
            end
            if random(0, 1) > 0.9 then
              print("skip")
              _continue_0 = true
              break
            end
            return i
          end
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
    end,
    spaceDamage = {
      0.5,
      0.7,
      0.9,
      1.0
    }
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
      self.sprite = sprites.battle.archer_enemy
    end,
    __base = _base_0,
    __name = "BattleEnemyArcher",
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
  BattleEnemyArcher = _class_0
end
do
  local _class_0
  local _parent_0 = BattleEnemy
  local _base_0 = {
    name = "Lancer",
    chooseTarget = function(self)
      for i = 1, 4, 1 do
        local _continue_0 = false
        repeat
          do
            local target = self.parent:inactiveEntities()[i]
            if target == nil then
              _continue_0 = true
              break
            end
            if not target:isValidTarget("attack") then
              _continue_0 = true
              break
            end
            if random(0, 1) > 0.9 then
              print("skip")
              _continue_0 = true
              break
            end
            return i
          end
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
    end,
    spaceDamage = {
      1.0,
      0.9,
      0.7,
      0.5
    }
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
      self.basestats.attack = 5
      self.sprite = sprites.battle.lancer_enemy
    end,
    __base = _base_0,
    __name = "BattleEnemyLancer",
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
  BattleEnemyLancer = _class_0
end
