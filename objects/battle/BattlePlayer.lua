local DAMAGE_FORMULA = {
  aw = 1,
  dw = 1.2,
  bd = 5,
  vm = 0.25,
  va = 2
}
do
  local _class_0
  local _base_0 = {
    name = "BattlePlayer",
    init = function(self)
      self.stats = table.shallow_copy(self.basestats)
      if not self.initialised then
        self.hp = self.stats.hp
      end
      if self.hp < 0 then
        self.hp = 0
      end
      self.buffs = {
        rally = false,
        poison = false,
        defence = false
      }
      self.dead = self.hp == 0
      self.initialised = true
    end,
    turnStart = function(self)
      self.buffs.defence = false
    end,
    takeDamage = function(self, incomingattack)
      local damage = math.floor((DAMAGE_FORMULA.va + (DAMAGE_FORMULA.vm * ((incomingattack * DAMAGE_FORMULA.aw) - (self.stats.defence * DAMAGE_FORMULA.dw)))) * DAMAGE_FORMULA.bd)
      if self.buffs.defence then
        damage = math.floor(damage * 0.5)
      end
      if damage < 1 then
        damage = 1
      end
      self.hp = self.hp - damage
      print("I took " .. damage .. " damage (" .. incomingattack .. "ATK " .. self.stats.defence .. "DEF)")
      if self.hp <= 0 then
        self:die()
      end
      return damage
    end,
    die = function(self)
      self.hp = 0
      self.dead = true
      return self.timer:tween(1, self, {
        color = {
          1,
          0,
          0,
          0
        }
      }, 'out-sine')
    end,
    attack = function(self, target, damageOverride)
      local damage = nil
      if damageOverride then
        damage = damageOverride
      else
        damage = self.stats.attack
      end
      if self.buffs.rally then
        damage = damage * 1.2
        self.buffs.rally = false
      end
      return target:takeDamage(damage)
    end,
    skillPrimaryInfo = {
      name = "SKILLPRIMARY",
      desc = "Base primary skill",
      unset = true
    },
    skillSecondaryInfo = {
      name = "SKILLSECONDARY",
      desc = "Base secondary skill",
      unset = true
    },
    skillPrimary = function(self) end,
    skillSecondary = function(self) end,
    isValidTarget = function(self, targetType)
      local _exp_0 = targetType
      if "attack" == _exp_0 then
        return self.hp > 0
      elseif "move" == _exp_0 then
        return self.hp > 0
      elseif "heal" == _exp_0 then
        return self.hp > 0 and self.hp < self.stats.hp
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
      if self.dead then
        return self:draw_dead()
      else
        self:draw_alive()
        self:draw_health()
        return self:draw_buffs()
      end
    end,
    draw_health = function(self)
      local hp = self.hp
      local max_hp = self.basestats.hp
      local max_len = self.size.w
      local len = (hp / max_hp) * max_len
      local x = self.pos.x
      local y = self.pos.y
      lg.setColor(BLACK)
      lg.rectangle("fill", x, y + 5, max_len, 2)
      lg.setColor(RED)
      lg.rectangle("fill", x - 1, y + 4, len, 2)
      lg.setColor(WHITE)
      shadowPrint(max_hp, x + 12, y + 16)
      return shadowPrint(hp, x, y + 8)
    end,
    draw_buffs = function(self)
      local icon_size = {
        w = 10,
        h = 10
      }
      local start_offset = {
        x = -5,
        y = -8
      }
      local position = vector.add(self.pos, start_offset)
      for buff, active in pairs(self.buffs) do
        if active then
          local sprite = sprites.battle.buffs[buff]
          if sprite == nil then
            lg.setColor(RED)
            lg.rectangle("fill", position.x, position.y, icon_size.w, icon_size.h)
          else
            sprite:draw(position.x, position.y)
          end
          position.x = position.x + (icon_size.w + 1)
        end
      end
    end,
    draw_alive = function(self)
      if self.sprite then
        self.sprite.color = self.color
        return self.sprite:draw(self.pos.x, self.pos.y)
      else
        lg.setColor(RED)
        lg.rectangle("fill", self.pos.x, self.pos.y - self.size.h, self.size.w, self.size.h)
        lg.setColor(BLACK)
        return lg.rectangle("line", self.pos.x, self.pos.y - self.size.h, self.size.w, self.size.h)
      end
    end,
    draw_dead = function(self)
      if self.sprite then
        lg.setBlendMode("add")
        self.sprite.color = self.color
        self.sprite:draw(self.pos.x, self.pos.y)
        return lg.setBlendMode("alpha")
      else
        lg.setColor(GRAY)
        lg.rectangle("fill", self.pos.x, self.pos.y - self.size.h, self.size.w, self.size.h)
        lg.setColor(BLACK)
        return lg.rectangle("line", self.pos.x, self.pos.y - self.size.h, self.size.w, self.size.h)
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.initialised = false
      self.parent = nil
      self.timer = Timer()
      self.pos = {
        x = 0,
        y = 0
      }
      self.color = {
        1,
        1,
        1,
        1
      }
      self.basestats = {
        hp = 0,
        attack = 0,
        defence = 0,
        speed = 0,
        magic = 0
      }
      self.stats = table.shallow_copy(self.basestats)
      self.hp = self.stats.hp
      self.size = {
        w = 24,
        h = 32
      }
      self.sprite = sprites.battle.main_char
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
    name = "Mage",
    skillPrimaryInfo = {
      name = "SapphireHail",
      desc = "Cause the sky to rain down bolts of energy, dealing damage to all enemies"
    },
    skillPrimary = function(self)
      self.parent.cutscenes:addCutscene(CutsceneHail({
        ttl = 1.5
      }))
      local scenes = { }
      for index, enemy in pairs(self.parent.enemies) do
        local _continue_0 = false
        repeat
          if not enemy then
            _continue_0 = true
            break
          end
          if not enemy:isValidTarget("attack") then
            _continue_0 = true
            break
          end
          table.insert(scenes, CutsceneAttack({
            tts = 1.5,
            index = index,
            damage = 15
          }))
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
      for _index_0 = 1, #scenes do
        local scene = scenes[_index_0]
        self.parent.cutscenes:addCutscene(scene)
      end
      return self.parent.state:changeState(BattleTurnState, {
        ttl = 2
      })
    end,
    skillSecondaryInfo = {
      name = "Bubble",
      desc = "Quickly send an ally to the safety of the back lines."
    },
    skillSecondary = function(self)
      self.parent.selectionCallback = function(self, index)
        local shovescene = CutsceneShove({
          tts = 0.5,
          ttl = 1,
          dir = 4,
          index = index
        })
        local bubblescene = CutsceneBubbleRise({
          tts = 0.5,
          ttl = 1,
          target = self.players[index]
        })
        self.cutscenes:addCutscene(shovescene)
        self.cutscenes:addCutscene(bubblescene)
        return self.state:changeState(BattleTurnState, {
          ttl = 1.8
        })
      end
      return self.parent.state:changeState(BattlePlayerSelectState, {
        prompt = "Who should " .. tostring(self.name) .. " bubble back to safety?"
      })
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
      self.basestats.hp = 50
      self.basestats.attack = 100
      self.basestats.defence = 2
      self.basestats.speed = 99
      self.basestats.magic = 10
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
    name = "Fighter",
    skillPrimaryInfo = {
      name = "LUNGE",
      desc = "Lunge forward as far as you can, dealing more damage with a bigger lunge."
    },
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
          tts = 0.1,
          index = index,
          damage = damage
        })
        self.cutscenes:addCutscene(shovescene)
        self.cutscenes:addCutscene(attackscene)
        return self.state:changeState(BattleTurnState, {
          ttl = 0.5
        })
      end
      return self.parent.state:changeState(BattleEnemySelectState, {
        prompt = "Which enemy should " .. tostring(self.name) .. " lunge at?"
      })
    end,
    skillSecondaryInfo = {
      name = "REPOSITION",
      desc = "Swap the position of two allies, or move an ally to an empty space."
    },
    skillSecondary = function(self)
      local myindex = nil
      for i, player in pairs(self.parent.players) do
        if player == self then
          myindex = i
        end
      end
      assert(myindex ~= nil)
      self.parent.selectionCallback = function(self, firstindex)
        self.selectionCallback = function(self, secondindex)
          local currentSpace = firstindex
          assert(currentSpace ~= nil)
          assert(secondindex <= 4)
          local swapscene = CutsceneSwap({
            tts = 0.033,
            type = "player",
            firstindex = firstindex,
            secondindex = secondindex
          })
          self.cutscenes:addCutscene(swapscene)
          return self.state:changeState(BattleTurnState, {
            ttl = 0.5
          })
        end
        return self.state:changeState(BattleSpaceSelectState, {
          selectedspace = firstindex,
          prompt = "Which space should they swap with?"
        })
      end
      return self.parent.state:changeState(BattlePlayerSelectState, {
        selectedIndex = myindex,
        prompt = "Who should " .. tostring(self.name) .. " command to reposition?",
        targetType = "move"
      })
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
      self.sprite = sprites.battle.artificer_char
      self.basestats.hp = 50
      self.basestats.attack = 100
      self.basestats.defence = 4
      self.basestats.speed = 7
      self.basestats.magic = 2
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
    name = "Paladin",
    skillPrimaryInfo = {
      name = "RALLY",
      desc = "Boost's each ally's morale, making their next attack deal more damage."
    },
    skillPrimary = function(self)
      local rallyScene = CutsceneBuff({
        buff = "rally",
        entities = self.parent.players
      })
      self.parent.cutscenes:addCutscene(rallyScene)
      return self.parent.state:changeState(BattleTurnState, {
        ttl = 1.2
      })
    end,
    skillSecondaryInfo = {
      name = "SHIELD'S UP",
      desc = "Moves to the front to protect others, boosting your defence until the next turn."
    },
    skillSecondary = function(self)
      local shoveScene = CutsceneShove({
        tts = 0.1,
        dir = -4
      })
      local buffScene = CutsceneBuff({
        tts = 1.0,
        buff = "defence",
        target = self
      })
      self.parent.cutscenes:addCutscene(shoveScene)
      self.parent.cutscenes:addCutscene(buffScene)
      return self.parent.state:changeState(BattleTurnState, {
        ttl = 1.5
      })
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
      self.sprite = sprites.battle.paladin_char
      self.basestats.hp = 50
      self.basestats.attack = 100
      self.basestats.defence = 8
      self.basestats.speed = 3
      self.basestats.magic = 6
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
    name = "Rogue"
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
      self.basestats.hp = 50
      self.basestats.attack = 9
      self.basestats.defence = 2
      self.basestats.speed = 8
      self.basestats.magic = 2
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
