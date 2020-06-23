require("states/state")
local Inspect = require("lib/inspect")
local WRAP_PLAYER_CURSOR = false
do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    swapEntityIndexes = function(self, type, indexA, indexB)
      print("indexSwap")
      self:updateEntityIndexes(type, indexA, 99)
      self:updateEntityIndexes(type, indexB, indexA)
      return self:updateEntityIndexes(type, 99, indexB)
    end,
    updateEntityIndexes = function(self, type, oldindex, newindex)
      print("indexUpdate t:" .. tostring(type) .. " old:" .. tostring(oldindex) .. " new:" .. tostring(newindex))
      if self.turndata.type == type and oldindex == self.turndata.index then
        self.turndata.index = newindex
      end
      for i, initiative in pairs(self.initiative) do
        if initiative.type == type and initiative.index == oldindex then
          self.initiative[i].index = newindex
          break
        end
      end
    end,
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
      self.players = self.parent.party
      local _list_0 = self.players
      for _index_0 = 1, #_list_0 do
        local _continue_0 = false
        repeat
          local player = _list_0[_index_0]
          if not player then
            _continue_0 = true
            break
          end
          player.parent = self
          player:init()
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
      self:calculatePlayerPos()
      self.enemies = {
        BattleEnemyArcher(),
        BattleEnemyLancer()
      }
      local _list_1 = self.enemies
      for _index_0 = 1, #_list_1 do
        local _continue_0 = false
        repeat
          local enemy = _list_1[_index_0]
          if not enemy then
            _continue_0 = true
            break
          end
          enemy.parent = self
          enemy:init()
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
      self:calculateEnemyPos()
      self:calculateInitiative()
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
        x = 97 + 28 * i,
        y = 127
      }
    end,
    calculateEnemyPos = function(self)
      local totalEnemyWidth = 0
      local enemyCount = 0
      local _list_0 = self.enemies
      for _index_0 = 1, #_list_0 do
        local enemy = _list_0[_index_0]
        totalEnemyWidth = totalEnemyWidth + enemy.size.w
        enemyCount = enemyCount + 1
      end
      local leftPadding = 5
      if (totalEnemyWidth < 90) then
        leftPadding = 10
      end
      local extraSpace = 110 - leftPadding - totalEnemyWidth
      assert(extraSpace >= 0)
      local gap = math.floor(extraSpace / enemyCount)
      if gap > 10 then
        gap = 10
      end
      local currentX = leftPadding
      for i, enemy in pairs(self.enemies) do
        enemy.pos = {
          x = currentX,
          y = 127
        }
        self.enemyPosData[i] = enemy.pos
        currentX = currentX + enemy.size.w
        currentX = currentX + gap
      end
    end,
    getEnemyIndexPos = function(self, i)
      return self.enemyPosData[i]
    end,
    turnEnd = function(self)
      if self:checkWon() then
        local gold = math.random(0, 100)
        local drops = {
          Potion(),
          Potion()
        }
        return self.state:changeState(BattleWinState, {
          rx = self.rx,
          ry = self.ry,
          gold = gold,
          drops = drops
        })
      elseif self:checkLost() then
        game.next_state = {
          state = GameOverState,
          params = { }
        }
      else
        self:getNextInitiative(true)
        return self.state:changeState(TurnIntroState)
      end
    end,
    turnStart = function(self)
      local _exp_0 = self.turndata.type
      if "player" == _exp_0 then
        return self.state:changeState(BattleMenuState)
      elseif "enemy" == _exp_0 then
        return self:enemyTurn()
      end
    end,
    calculateInitiative = function(self)
      self.initiative = { }
      for i, player in pairs(self.players) do
        table.insert(self.initiative, {
          speed = player.stats.speed,
          index = i,
          type = "player",
          entity = player
        })
      end
      for i, enemy in pairs(self.enemies) do
        table.insert(self.initiative, {
          speed = enemy.stats.speed,
          index = i,
          type = "enemy",
          entity = enemy
        })
      end
      local sortfunc
      sortfunc = function(a, b)
        return a.speed > b.speed
      end
      table.sort(self.initiative, sortfunc)
      return self:printInitiative()
    end,
    printInitiative = function(self, highlight)
      print("==INITIATIVE==")
      for i, v in pairs(self.initiative) do
        local icon = "[" .. tostring(i) .. "]"
        if i == highlight then
          icon = "#" .. tostring(i) .. "#"
        end
        print(tostring(icon) .. " T:" .. tostring(v.type) .. " I:" .. tostring(v.index) .. " S:" .. tostring(v.speed))
      end
      return print()
    end,
    getNextInitiative = function(self, apply)
      if apply == nil then
        apply = false
      end
      local nextIndex = self.initiativeIndex + 1
      if nextIndex > #self.initiative then
        nextIndex = 1
      end
      while self.initiative[nextIndex].entity.dead do
        nextIndex = nextIndex + 1
        if nextIndex > #self.initiative then
          nextIndex = 1
        end
        if nextIndex == self.initiativeIndex then
          error("Everyone is dead - initiative has looped")
        end
      end
      local nextInitiative = self.initiative[nextIndex]
      if apply then
        self.initiativeIndex = nextIndex
        self.turndata = {
          type = nextInitiative.type,
          index = nextInitiative.index
        }
        self:printInitiative(self.initiativeIndex)
      end
      return nextInitiative.entity
    end,
    attackAction = function(self)
      self.selectionCallback = function(self, index)
        local attackscene = CutsceneAttack({
          tts = 0.1,
          index = index
        })
        self.cutscenes:addCutscene(attackscene)
        return self.state:changeState(BattleTurnState, {
          ttl = 0.33
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
        ttl = 0.5
      })
    end,
    swapAction = function(self)
      self.selectionCallback = function(index)
        local currentSpace = self.currentTurnIndex.index
        assert(currentSpace ~= nil)
        assert(index <= 4)
        local swapscene = CutsceneSwap({
          tts = 0.033,
          type = "player",
          firstindex = self.currentTurnIndex.index,
          secondindex = index
        })
        self.cutscenes:addCutscene(swapscene)
        return self.state:changeState(BattleTurnState, {
          ttl = 0.5
        })
      end
      return self.state:changeState(BattleSpaceSelectState, {
        selectedspace = self.currentTurnIndex.index
      })
    end,
    itemAction = function(self)
      self.selectionCallback = function(self, index)
        local item = game.inventory.items[index]
        self.indexItemToUse = index
        local _exp_0 = item.use_target
        if "player" == _exp_0 then
          self.selectionCallback = function(self, index)
            local target = self.players[index]
            item = game.inventory.items[self.indexItemToUse]
            local usable, message = item:is_usable_on_target(target)
            if usable then
              message = game.inventory:useItem(self.indexItemToUse, target)
              self.dialogCallback = function(self)
                return self:turnEnd()
              end
            else
              self.dialogCallback = function(self)
                return self.state:changeState(BattlePlayerSelectState)
              end
            end
            local tree = DialogTree({
              DialogBox(message)
            })
            return self.state:changeState(BattleDialogState, {
              tree = tree
            })
          end
          return self.state:changeState(BattlePlayerSelectState)
        elseif nil == _exp_0 then
          item = game.inventory.items[self.indexItemToUse]
          local usable, message = item:is_usable()
          print(usable)
          if usable then
            message = game.inventory:useItem(self.indexItemToUse)
            self.dialogCallback = function(self)
              return self:turnEnd()
            end
          else
            self.dialogCallback = function(self)
              return self.state:changeState(BattleItemSelectState)
            end
          end
          local tree = DialogTree({
            DialogBox(message)
          })
          return self.state:changeState(BattleDialogState, {
            tree = tree
          })
        end
      end
      return self.state:changeState(BattleItemSelectState)
    end,
    selectedPlayer = function(self)
      return self.players[self.selectedSpace]
    end,
    checkDead = function(self, tbl)
      for _index_0 = 1, #tbl do
        local o = tbl[_index_0]
        if o ~= nil then
          if o.dead == false then
            return false
          end
        end
      end
      return true
    end,
    checkWon = function(self)
      if self:checkDead(self.enemies) then
        return true
      end
      return false
    end,
    checkLost = function(self)
      return self:checkDead(self.players)
    end,
    updateTimers = function(self)
      local _list_0 = self.players
      for _index_0 = 1, #_list_0 do
        local p = _list_0[_index_0]
        if p then
          if p.timer then
            p.timer:update(dt)
          end
        end
      end
      local _list_1 = self.enemies
      for _index_0 = 1, #_list_1 do
        local e = _list_1[_index_0]
        if e then
          if e.timer then
            e.timer:update(dt)
          end
        end
      end
    end,
    update = function(self)
      self:updateTimers()
      self.state:update()
      self.cutscenes:update()
      self.aniObjs:updateObjects()
      return self.aniObjs:checkDestroyed()
    end,
    drawBackground = function(self)
      lg.draw(self.bg, 0, 0)
      lg.setColor({
        0,
        0,
        0,
        0.5
      })
      return lg.rectangle("fill", 0, GAME_HEIGHT - 24, GAME_WIDTH, 24)
    end,
    draw = function(self)
      self:drawBackground()
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
      self.aniObjs:drawObjects()
      return self.cutscenes:draw()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent, rx, ry, bg)
      if rx == nil then
        rx = 0
      end
      if ry == nil then
        ry = 0
      end
      if bg == nil then
        bg = backgrounds.desert
      end
      self.parent, self.rx, self.ry, self.bg = parent, rx, ry, bg
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
      self.enemyPosData = { }
      self.indexItemToUse = nil
      self.aniObjs = ObjectManager()
      self.cutscenes = BattleCutsceneManager(self)
      self.turndata = {
        type = nil,
        index = 0
      }
      self.initiative = { }
      self.initiativeIndex = 0
      self.selectionCallback = function() end
      self.dialogCallback = function() end
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
