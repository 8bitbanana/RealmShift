do
  local _class_0
  local _base_0 = {
    update = function(self)
      self.state:update()
      return limitPosToCurrentRoom(self)
    end,
    draw = function(self)
      return self.state:draw()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, pos, width, height)
      if pos == nil then
        pos = {
          x = 0,
          0
        }
      end
      if width == nil then
        width = 16
      end
      if height == nil then
        height = 16
      end
      self.pos, self.width, self.height = pos, width, height
      self.vel = {
        x = 0,
        y = 0
      }
      self.sprite = sprites.player.idle
      self.state = PlayerIdleState(self)
    end,
    __base = _base_0,
    __name = "Player"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Player = _class_0
end
