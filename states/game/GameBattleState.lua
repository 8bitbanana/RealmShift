require("states/state")
local Inspect = require("lib/inspect")
local WRAP_PLAYER_CURSOR = false
do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    activeEntities = function(self)
      local _exp_0 = self.turndata.type
      if "player" == _exp_0 then
        return self.players
      elseif "enemy" == _exp_0 then
        return self.enemies
      else
        return nil
      end
    end,
    inactiveEntities = function(self)
      local _exp_0 = self.turndata.type
      if "enemy" == _exp_0 then
        return self.players
      elseif "player" == _exp_0 then
        return self.enemies
      else
        return nil
      end
    end,
    currentTurn = function(self)
      local entities = self:activeEntities()
      if entities == nil then
        return nil
      end
      return self:activeEntities()[self.turndata.index]
    end,
    init = function(self)
      self.state = State(self)
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
      self:calculatePlayerPos()
      self.enemies = {
        BattleEnemy(self, {
          x = 10,
          y = 127
        }),
        BattleEnemy(self, {
          x = 50,
          y = 127
        })
      }
      self:getNextInitiative(true)
      return self.state:changeState(TurnIntroState)
    end,
    calculatePlayerPos = function(self)
      for i, player in pairs(self.players) do
        player.pos = self:getPlayerIndexPos(i)
      end
    end,
    getPlayerIndexPos = function(self, i)
      return {
        x = 92 + 28 * i,
        y = 127
      }
    end,
    turnEnd = function(self)
      self:getNextInitiative(true)
      return self.state:changeState(TurnIntroState)
    end,
    turnStart = function(self)
      local _exp_0 = self.turndata.type
      if "player" == _exp_0 then
        return self.state:changeState(BattleMenuState)
      elseif "enemy" == _exp_0 then
        return self:enemyTurn()
      end
    end,
    getNextInitiative = function(self, apply)
      if apply == nil then
        apply = false
      end
      local nextup = nil
      local nextupSpeed = -999
      local nextupData = {
        type = nil,
        index = 0
      }
      local nextup_all = nil
      local nextup_allSpeed = -999
      local nextup_allData = {
        type = nil,
        index = 0
      }
      local currentTurnSpeed = 999
      if self:currentTurn() ~= nil then
        currentTurnSpeed = self:currentTurn().stats.speed
      end
      for index, player in pairs(self.players) do
        local _continue_0 = false
        repeat
          if player == nil then
            _continue_0 = true
            break
          end
          if player.stats.speed > nextupSpeed and player.stats.speed < currentTurnSpeed then
            nextup = player
            nextupSpeed = player.stats.speed
            nextupData = {
              type = "player",
              index = index
            }
          end
          if player.stats.speed > nextup_allSpeed then
            nextup_all = player
            nextup_allSpeed = player.stats.speed
            nextup_allData = {
              type = "player",
              index = index
            }
          end
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
      for index, enemy in pairs(self.enemies) do
        local _continue_0 = false
        repeat
          if enemy == nil then
            _continue_0 = true
            break
          end
          if enemy.stats.speed > nextupSpeed and enemy.stats.speed < currentTurnSpeed then
            nextup = enemy
            nextupSpeed = enemy.stats.speed
            nextupData = {
              type = "enemy",
              index = index
            }
          end
          if enemy.stats.speed > nextup_allSpeed then
            nextup_all = enemy
            nextup_allSpeed = enemy.stats.speed
            nextup_allData = {
              type = "enemy",
              index = index
            }
          end
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
      if nextup == nil then
        if apply then
          self.turndata = nextup_allData
        end
        return nextup_all
      else
        if apply then
          self.turndata = nextupData
        end
        return nextup
      end
    end,
    attackAction = function(self)
      self.selectionCallback = function(self, index)
        local attackscene = CutsceneAttack({
          tts = 6,
          index = index
        })
        self.cutscenes:addCutscene(attackscene)
        return self.state:changeState(BattleTurnState, {
          ttl = 20
        })
      end
      return self.state:changeState(BattleEnemySelectState)
    end,
    enemyTurn = function(self)
      return self:currentTurn():enemyTurn()
    end,
    skillAction = function(self)
      return self.state:changeState(BattleSkillSelectState)
    end,
    waitAction = function(self)
      return self.state:changeState(BattleTurnState, {
        ttl = 30
      })
    end,
    swapAction = function(self)
      self.selectionCallback = function(index)
        local currentSpace = self.currentTurnIndex.index
        assert(currentSpace ~= nil)
        assert(index <= 4)
        local swapscene = CutsceneSwap({
          tts = 2,
          firstindex = self.currentTurnIndex.index,
          secondindex = index
        })
        self.cutscenes:addCutscene(swapscene)
        return self.state:changeState(BattleTurnState, {
          ttl = 30
        })
      end
      return self.state:changeState(BattleSpaceSelectState, {
        selectedspace = self.currentTurnIndex.index
      })
    end,
    selectedPlayer = function(self)
      return self.players[self.selectedSpace]
    end,
    checkDead = function(self, tbl)
      for _index_0 = 1, #tbl do
        local o = tbl[_index_0]
        if o.dead == false then
          return false
        end
      end
      return true
    end,
    checkWon = function(self)
      return self:checkDead(self.enemies)
    end,
    checkLost = function(self)
      return self:checkDead(self.players)
    end,
    update = function(self)
      self.state:update()
      self.cutscenes:update()
      self.aniObjs:updateObjects()
      self.aniObjs:checkDestroyed()
      if self:checkWon() then
        game.next_state = {
          state = GameOverworldState,
          params = {
            self.rx,
            self.ry
          }
        }
      elseif self:checkLost() then
        return print("You died chump")
      end
    end,
    draw = function(self)
      lg.setColor(0.28, 0.81, 0.81, 1)
      lg.rectangle("fill", 0, 0, GAME_WIDTH, GAME_HEIGHT)
      lg.setColor(0.25, 0.63, 0.22, 1)
      lg.rectangle("fill", 0, 127, GAME_WIDTH, 53)
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
      self.state:draw()
      return self.aniObjs:drawObjects()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent, rx, ry)
      if rx == nil then
        rx = 0
      end
      if ry == nil then
        ry = 0
      end
      self.parent, self.rx, self.ry = parent, rx, ry
      print(self.rx, self.ry)
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
      self.cutscenes = BattleCutsceneManager(self)
      self.turndata = {
        type = nil,
        index = 0
      }
      self.selectionCallback = function() end
      self.cutsceneCallback = function() end
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
