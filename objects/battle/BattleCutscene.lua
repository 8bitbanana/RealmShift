local Inspect = require("lib/Inspect")
do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    init = function(self)
      self.ttl = self.args.ttl
      self.done = false
    end,
    update = function(self)
      if not self.done then
        self.ttl = self.ttl - 1
      end
      if self.ttl <= 0 and not self.done then
        self.done = true
        return self.parent:turnEnd()
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent, args)
      self.parent, self.args = parent, args
    end,
    __base = _base_0,
    __name = "BattleTurnState",
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
  BattleTurnState = _class_0
end
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
    update = function(self)
      if self.started then
        self.ttl = self.ttl - 1
        if self.ttl == 0 then
          self:sceneFinish()
          self.done = true
        end
        if not self.done then
          return self:sceneUpdate()
        end
      else
        self.tts = self.tts - 1
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
      self.args = args
      self.root = nil
      self.started = false
      self.done = false
      self.tts_max = 0
      self.ttl_max = 10
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
    sceneUpdate = function(self)
      if self.ttl == 8 then
        local damage = self.root.currentTurn:attack(self.root.enemies[self.args.index], self.args.damage)
        local pos = self.root.enemies[self.args.index]:getCursorPos()
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
      self.ttl_max = 10
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
    sceneStart = function(self)
      local oldindex = self.root.currentTurnIndex.index
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
      print(Inspect(self.moves))
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
      self.root:calculatePlayerPos()
      for i, p in pairs(self.root.players) do
        print(tostring(i) .. "-" .. tostring(p.__class.__name))
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
      self.ttl = 25
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
      self.playerA = self.root.players[self.args.firstindex]
      self.playerB = self.root.players[self.args.secondindex]
      assert(self.args.firstindex ~= self.args.secondindex)
      if self.playerA then
        self.posA = self.playerA.pos
      else
        self.posA = self.root:getPlayerIndexPos(self.args.firstindex)
      end
      if self.playerB then
        self.posB = self.playerB.pos
      else
        self.posB = self.root:getPlayerIndexPos(self.args.secondindex)
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
      self.root.players[self.args.firstindex], self.root.players[self.args.secondindex] = self.root.players[self.args.secondindex], self.root.players[self.args.firstindex]
      self.root.currentTurnIndex.index = index
      return self.root:calculatePlayerPos()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
      self.ttl = 25
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
