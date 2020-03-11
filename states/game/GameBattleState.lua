require("states/state")
local WRAP_PLAYER_CURSOR = false
do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    init = function(self)
      self.players = {
        Paladin(),
        Fighter(),
        nil,
        Mage()
      }
      self.enemy = BattleEnemy()
      for i, player in pairs(self.players) do
        player.pos.x = 92 + 28 * i
        player.pos.y = 127
      end
      self.enemy.pos.x = 10
      self.enemy.pos.y = 127
    end,
    attackAction = function(self)
      return self:selectedPlayer():attack(self.enemy)
    end,
    movePlayerCursor = function(self, dir)
      for i = 0, 8 do
        self.selectedSpace = self.selectedSpace + dir
        if WRAP_PLAYER_CURSOR then
          if self.selectedSpace < 1 then
            self.selectedSpace = 4
          end
          if self.selectedSpace > 4 then
            self.selectedSpace = 1
          end
        else
          if self.selectedSpace < 1 then
            self.selectedSpace = 1
          end
          if self.selectedSpace > 4 then
            self.selectedSpace = 4
          end
        end
        if self:selectedPlayer() ~= nil then
          return 
        end
      end
      return error("MovePlayerCursor is spinning in circles")
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
      self.enemy:draw()
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
      self.enemy = nil
      self.selectedSpace = 1
      self.state = BattleMenuState(self)
      self.aniObjs = ObjectManager()
      self.currentInitiative = 99
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
