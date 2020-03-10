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
      for i, player in pairs(self.players) do
        player.pos.x = 92 + 28 * i
        player.pos.y = 95
      end
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
      if input:pressed("left") then
        self:movePlayerCursor(-1)
      end
      if input:pressed("right") then
        return self:movePlayerCursor(1)
      end
    end,
    drawMenu = function(self, x, y)
      return lg.print
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
      local selectedX = self:selectedPlayer().pos.x
      lg.polygon("fill", selectedX + 2, 53, selectedX + 12, 91, selectedX + 22, 53)
      lg.setColor(0, 0, 0, 1)
      lg.line(selectedX + 2, 53, selectedX + 12, 91, selectedX + 22, 53)
      self:drawMenu()
      local _list_0 = self.players
      for _index_0 = 1, #_list_0 do
        local player = _list_0[_index_0]
        if player then
          player:draw()
        end
      end
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
      self.selectedSpace = 1
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
