require("states/state")
local WRAP_PLAYER_CURSOR = false
do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    init = function(self)
      self.players = {
        BattlePlayer({
          x = 120 + 28 * 0,
          y = 95
        }),
        BattlePlayer({
          x = 120 + 28 * 1,
          y = 95
        }),
        BattlePlayer({
          x = 120 + 28 * 2,
          y = 95
        }),
        BattlePlayer({
          x = 120 + 28 * 3,
          y = 95
        })
      }
      local _list_0 = self.players
      for _index_0 = 1, #_list_0 do
        local player = _list_0[_index_0]
        self.objects:addObject(player)
      end
    end,
    movePlayerCursor = function(self, dir)
      self.selectedPlayer = self.selectedPlayer + dir
      if WRAP_PLAYER_CURSOR then
        if self.selectedPlayer < 1 then
          self.selectedPlayer = 4
        end
        if self.selectedPlayer > 4 then
          self.selectedPlayer = 1
        end
      else
        if self.selectedPlayer < 1 then
          self.selectedPlayer = 1
        end
        if self.selectedPlayer > 4 then
          self.selectedPlayer = 4
        end
      end
    end,
    selectedPlayer = function(self)
      return self.players[self.selectedPlayer]
    end,
    update = function(self)
      self.objects:updateObjects()
      self.objects:checkDestroyed()
      return self:movePlayerCursor(1)
    end,
    draw = function(self)
      lg.setColor(0.28, 0.81, 0.81, 1)
      lg.rectangle("fill", 0, 0, GAME_WIDTH, GAME_HEIGHT)
      lg.setColor(0.25, 0.63, 0.22, 1)
      lg.rectangle("fill", 0, 127, GAME_WIDTH, 53)
      lg.setColor(1, 1, 1, 1)
      lg.rectangle("fill", 116, 4, 116, 50)
      lg.setColor(0, 0, 0, 1)
      lg.rectangle("line", 116, 4, 116, 50)
      lg.setColor(1, 1, 1, 1)
      local selectedX = self.players[self.selectedPlayer].pos.x
      lg.polygon("fill", selectedX + 2, 53, selectedX + 12, 91, selectedX + 22, 53)
      lg.setColor(0, 0, 0, 1)
      lg.line(selectedX + 2, 53, selectedX + 12, 91, selectedX + 22, 53)
      return self.objects:drawObjects()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent)
      self.parent = parent
      self.objects = ObjectManager()
      self.selectedPlayer = 1
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
