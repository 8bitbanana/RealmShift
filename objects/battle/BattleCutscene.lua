local Inspect = require("lib.inspect")
do
  local _class_0
  local _base_0 = {
    addCutscene = function(self, cutscene)
      cutscene.root = self.parent
      cutscene:init()
      return table.insert(self.cutscenes, cutscene)
    end,
    update = function(self)
      for i, cutscene in pairs(self.cutscenes) do
        if cutscene.done then
          table.remove(self.cutscenes, i)
        else
          cutscene:update()
        end
      end
    end,
    draw = function(self)
      local _list_0 = self.cutscenes
      for _index_0 = 1, #_list_0 do
        local cutscene = _list_0[_index_0]
        cutscene:draw()
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, parent)
      self.parent = parent
      self.cutscenes = { }
    end,
    __base = _base_0,
    __name = "BattleCutsceneManager"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  BattleCutsceneManager = _class_0
end
do
  local _class_0
  local _base_0 = {
    init = function(self)
      assert(self.root ~= nil)
      if self.args.tts then
        self.tts_max = self.args.tts
      end
      if self.args.ttl then
        self.ttl_max = self.args.ttl
      end
      self.tts = self.tts_max
      self.ttl = self.ttl_max
    end,
    progress = function(self)
      if not self.started then
        return 0
      end
      if self.done then
        return 1
      end
      return 1 - (self.ttl / self.ttl_max)
    end,
    sceneStart = function(self) end,
    sceneUpdate = function(self) end,
    sceneFinish = function(self) end,
    draw = function(self) end,
    update = function(self)
      if self.started then
        self.ttl = self.ttl - dt
        if self.ttl <= 0 then
          self:sceneFinish()
          self.done = true
        end
        if not self.done then
          return self:sceneUpdate()
        end
      else
        self.tts = self.tts - dt
        if self.tts <= 0 then
          self.started = true
          return self:sceneStart()
        end
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, args)
      if args == nil then
        args = { }
      end
      self.args = args
      self.root = nil
      self.started = false
      self.done = false
      self.tts_max = 0
      self.ttl_max = 0.16
    end,
    __base = _base_0,
    __name = "BattleCutscene"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  BattleCutscene = _class_0
end
do
  local _class_0
  local _parent_0 = BattleCutscene
  local _base_0 = {
    sceneStart = function(self)
      self.dialog = DialogBox(self.args.text)
    end,
    sceneUpdate = function(self)
      if self.dialog then
        return self.dialog:update()
      end
    end,
    sceneFinish = function(self)
      self.dialog:clearCanvas()
      self.dialog = nil
    end,
    draw = function(self)
      if self.dialog then
        return self.dialog:draw()
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
      self.ttl_max = 1
    end,
    __base = _base_0,
    __name = "CutsceneDialog",
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
  CutsceneDialog = _class_0
end
do
  local _class_0
  local _parent_0 = BattleCutscene
  local _base_0 = {
    sceneUpdate = function(self)
      if self.ttl <= 0.13 and not self.attacked then
        self.attacked = true
        local damage = self.root:currentTurn():attack(self.root:inactiveEntities()[self.args.index], self.args.damage, self.args.applySpaceDamage)
        local pos = self.root:inactiveEntities()[self.args.index]:getCursorPos()
        local particle = BattleDamageNumber(pos, damage)
        return self.root.aniObjs:addObject(particle)
      end
    end,
    sceneFinish = function(self) end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
      self.ttl_max = 0.16
      self.attacked = false
    end,
    __base = _base_0,
    __name = "CutsceneAttack",
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
  CutsceneAttack = _class_0
end
do
  local _class_0
  local _parent_0 = BattleCutscene
  local _base_0 = {
    sceneStart = function(self) end,
    sceneUpdate = function(self)
      if self.cooldown <= 0 then
        local pos = {
          x = math.floor(random(110, 247)),
          y = math.floor(random(-40, 0))
        }
        local particle = BattleHail(pos)
        self.root.aniObjs:addObject(particle)
        self.cooldown = 2
      else
        self.cooldown = self.cooldown - 1
      end
    end,
    sceneFinish = function(self) end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
      self.ttl_max = 2
      self.cooldown = 0
    end,
    __base = _base_0,
    __name = "CutsceneHail",
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
  CutsceneHail = _class_0
end
do
  local _class_0
  local _parent_0 = BattleCutscene
  local _base_0 = {
    sceneStart = function(self)
      self.edges = {
        top = {
          x = 0,
          y = -20
        },
        bottom = {
          x = 0,
          y = 0
        }
      }
      self.offset = {
        x = 0,
        y = 0
      }
    end,
    sceneUpdate = function(self)
      self.args.target.pos = vector.add(self.args.target.pos, self.offset)
      if self:progress() < 0.5 then
        local prog = self:progress()
        prog = math.sin(prog * PI)
        self.offset = vector.lerp(self.edges.bottom, self.edges.top, prog)
      else
        local prog = self:progress() - 0.5
        prog = math.sin(prog * PI)
        self.offset = vector.lerp(self.edges.top, self.edges.bottom, prog)
      end
    end,
    sceneFinish = function(self) end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
      self.ttl_max = 1
    end,
    __base = _base_0,
    __name = "CutsceneBubbleRise",
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
  CutsceneBubbleRise = _class_0
end
do
  local _class_0
  local _parent_0 = BattleCutscene
  local _base_0 = {
    sceneStart = function(self)
      if self.args.entities then
        self.entities = self.args.entities
        return assert(self.entities ~= nil)
      else
        if self.args.target then
          self.target = self.args.target
          return assert(self.target ~= nil)
        else
          return error("Neither entities/target specified")
        end
      end
    end,
    sceneUpdate = function(self) end,
    sceneFinish = function(self)
      if self.target then
        assert(self.target.buffs[self.args.buff] ~= nil)
        self.target.buffs[self.args.buff] = true
      else
        if self.entities then
          local _list_0 = self.entities
          for _index_0 = 1, #_list_0 do
            local _continue_0 = false
            repeat
              local entity = _list_0[_index_0]
              if not entity then
                _continue_0 = true
                break
              end
              assert(entity.buffs[self.args.buff] ~= nil)
              entity.buffs[self.args.buff] = true
              _continue_0 = true
            until true
            if not _continue_0 then
              break
            end
          end
        end
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
      self.ttl = 0.16
    end,
    __base = _base_0,
    __name = "CutsceneBuff",
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
  CutsceneBuff = _class_0
end
do
  local _class_0
  local _parent_0 = BattleCutscene
  local _base_0 = {
    sceneStart = function(self)
      assert(self.root.turndata.type == "player")
      local oldindex = self.args.index or self.root.turndata.index
      local newindex = oldindex + self.args.dir
      if newindex < 1 then
        newindex = 1
      end
      if newindex > 4 then
        newindex = 4
      end
      local shovestart = newindex
      local shoveend = nil
      local shovedir = nil
      if self.args.dir < 0 then
        for i = shovestart, 4 do
          if self.root.players[i] == nil or i == oldindex then
            shoveend = i
            break
          end
        end
        shovedir = 1
      else
        for i = shovestart, 1, -1 do
          if self.root.players[i] == nil or i == oldindex then
            shoveend = i
            break
          end
        end
        shovedir = -1
      end
      assert(shovestart ~= nil)
      assert(shoveend ~= nil)
      self.moves = {
        {
          oldindex,
          newindex
        }
      }
      for i = shovestart, shoveend - shovedir, shovedir do
        if self.root.players[i] ~= nil then
          table.insert(self.moves, {
            i,
            i + shovedir
          })
        end
      end
    end,
    sceneUpdate = function(self)
      local _list_0 = self.moves
      for _index_0 = 1, #_list_0 do
        local move = _list_0[_index_0]
        local oldindex, newindex = move[1], move[2]
        local oldpos = self.root:getPlayerIndexPos(oldindex)
        local newpos = self.root:getPlayerIndexPos(newindex)
        self.root.players[oldindex].pos = vector.lerp(oldpos, newpos, self:progress())
      end
    end,
    sceneFinish = function(self)
      local newPlayers = {
        nil,
        nil,
        nil,
        nil
      }
      for index = 1, 4 do
        local _continue_0 = false
        repeat
          if self.root.players[index] == nil then
            _continue_0 = true
            break
          end
          local newindex = index
          local _list_0 = self.moves
          for _index_0 = 1, #_list_0 do
            local move = _list_0[_index_0]
            if move[1] == index then
              newindex = move[2]
              self.root:updateEntityIndexes("player", move[1], move[2])
              break
            end
          end
          newPlayers[newindex] = self.root.players[index]
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
      self.root.players = newPlayers
      return self.root:calculatePlayerPos()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
      self.ttl = 0.40
      self.moves = { }
    end,
    __base = _base_0,
    __name = "CutsceneShove",
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
  CutsceneShove = _class_0
end
do
  local _class_0
  local _parent_0 = BattleCutscene
  local _base_0 = {
    sceneStart = function(self)
      self.entities = nil
      if self.args.type == "player" then
        self.entities = self.root.players
      end
      if self.args.type == "enemy" then
        self.entities = self.root.enemies
      end
      assert(self.entities ~= nil)
      self.playerA = self.entities[self.args.firstindex]
      self.playerB = self.entities[self.args.secondindex]
      assert(self.args.firstindex ~= self.args.secondindex)
      if self.playerA then
        self.posA = self.playerA.pos
      else
        if self.args.type == "player" then
          self.posA = self.root:getPlayerIndexPos(self.args.firstindex)
        end
        if self.args.type == "enemy" then
          self.posA = self.root:getEnemyIndexPos(self.args.firstindex)
        end
      end
      if self.playerB then
        self.posB = self.playerB.pos
      else
        if self.args.type == "player" then
          self.posB = self.root:getPlayerIndexPos(self.args.secondindex)
        end
        if self.args.type == "enemy" then
          self.posB = self.root:getEnemyIndexPos(self.args.secondindex)
        end
      end
    end,
    sceneUpdate = function(self)
      if self.playerA ~= nil then
        self.playerA.pos = vector.lerp(self.posA, self.posB, self:progress())
      end
      if self.playerB ~= nil then
        self.playerB.pos = vector.lerp(self.posB, self.posA, self:progress())
      end
    end,
    sceneFinish = function(self)
      self.entities[self.args.firstindex], self.entities[self.args.secondindex] = self.entities[self.args.secondindex], self.entities[self.args.firstindex]
      self.root:swapEntityIndexes(self.args.type, self.args.firstindex, self.args.secondindex)
      if self.args.type == "player" then
        self.root:calculatePlayerPos()
      end
      if self.args.type == "enemy" then
        return self.root:calculateEnemyPos()
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
      self.ttl = 0.40
    end,
    __base = _base_0,
    __name = "CutsceneSwap",
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
  CutsceneSwap = _class_0
end
