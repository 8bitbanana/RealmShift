require("objects/battle/BattlePlayer")
do
  local _class_0
  local _parent_0 = BattlePlayer
  local _base_0 = {
    enemyTurn = function(self)
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
      print("Attacking target " .. targetindex)
      local attackScene = CutsceneAttack({
        tts = 0.33,
        index = targetindex
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
    end,
    draw_alive = function(self)
      lg.setColor(RED)
      lg.rectangle("fill", self.pos.x, self.pos.y - self.size.h, self.size.w, self.size.h)
      lg.setColor(BLACK)
      return lg.rectangle("line", self.pos.x, self.pos.y - self.size.h, self.size.w, self.size.h)
    end,
    draw_dead = function(self)
      lg.setColor(GRAY)
      lg.rectangle("fill", self.pos.x, self.pos.y - self.size.h, self.size.w, self.size.h)
      lg.setColor(BLACK)
      return lg.rectangle("line", self.pos.x, self.pos.y - self.size.h, self.size.w, self.size.h)
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
