require("states/state")
local Inspect = require("lib/inspect")
local WRAP_PLAYER_CURSOR = false
do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    init = function(self)
      self.state = BattleMenuState(self)
      self.players = {
        Paladin(self, {
          x = 120,
          y = 127
        }),
        Fighter(self, {
          x = 148,
          y = 127
        }),
        nil,
        Mage(self, {
          x = 204,
          y = 127
        })
      }
      self.enemies = {
        BattleEnemy(self, {
          x = 10,
          y = 127
        })
      }
      return self:getNextInitiative(true)
    end,
    getNextInitiative = function(self, apply)
      if apply == nil then
        apply = false
      end
      local nextup = nil
      local nextupSpeed = -999
      local nextup_all = nil
      local nextup_allSpeed = -999
      local currentTurnSpeed = 999
      if self.currentTurn ~= nil then
        currentTurnSpeed = self.currentTurn.stats.speed
      end
      local _list_0 = self.players
      for _index_0 = 1, #_list_0 do
        local _continue_0 = false
        repeat
          local player = _list_0[_index_0]
          if player == nil then
            _continue_0 = true
            break
          end
          if player.stats.speed > nextupSpeed and player.stats.speed < currentTurnSpeed then
            nextup = player
            nextupSpeed = player.stats.speed
          end
          if player.stats.speed > nextup_allSpeed then
            nextup_all = player
            nextup_allSpeed = player.stats.speed
          end
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
      local _list_1 = self.enemies
      for _index_0 = 1, #_list_1 do
        local _continue_0 = false
        repeat
          local enemy = _list_1[_index_0]
          if enemy == nil then
            _continue_0 = true
            break
          end
          if enemy.stats.speed > nextupSpeed and enemy.stats.speed < currentTurnSpeed then
            nextup = enemy
            nextupSpeed = enemy.stats.speed
          end
          if enemy.stats.speed > nextup_allSpeed then
            nextup_all = enemy
            nextup_allSpeed = enemy.stats.speed
          end
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
      if nextup == nil then
        if apply then
          self.currentTurn = nextup_all
        end
        return nextup_all
      else
        if apply then
          self.currentTurn = nextup
        end
        return nextup
      end
    end,
    attackAction = function(self)
      return self.currentTurn:attack(self.enemies[1])
    end,
    selectedPlayer = function(self)
      return self.players[self.selectedSpace]
    end,
    update = function(self)
      self.state:update()
      self.aniObjs:updateObjects()
      return self.aniObjs:checkDestroyed()
    end,
    draw = function(self)
      lg.setColor(0.28, 0.81, 0.81, 1)
      lg.rectangle("fill", 0, 0, GAME_WIDTH, GAME_HEIGHT)
      lg.setColor(0.25, 0.63, 0.22, 1)
      lg.rectangle("fill", 0, 127, GAME_WIDTH, 53)
      self.state:draw()
      local _list_0 = self.players
      for _index_0 = 1, #_list_0 do
        local player = _list_0[_index_0]
        if player then
          player:draw()
        end
      end
      local _list_1 = self.enemies
      for _index_0 = 1, #_list_1 do
        local enemy = _list_1[_index_0]
        if enemy then
          enemy:draw()
        end
      end
      return self.aniObjs:drawObjects()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent)
      self.parent = parent
      self.players = {
        nil,
        nil,
        nil,
        nil
      }
      self.enemies = {
        nil
      }
      self.selectedSpace = 1
      self.state = nil
      self.aniObjs = ObjectManager()
      self.currentTurn = nil
    end,
    __base = _base_0,
    __name = "GameBattleState",
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
  GameBattleState = _class_0
end
