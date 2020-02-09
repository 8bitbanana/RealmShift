do
  local _class_0
  local _base_0 = {
    move = function(self, dx, dy)
      if dx == nil then
        dx = 0
      end
      if dy == nil then
        dy = 0
      end
      self.pos.x = self.pos.x + dx
      self.pos.y = self.pos.y + dy
    end,
    update = function(self)
      local interval = 0.5
      if input:down("left", interval) then
        self:move(-1, 0)
      end
      if input:down("right", interval) then
        self:move(1, 0)
      end
      if input:down("up", interval) then
        self:move(0, -1)
      end
      if input:down("down", interval) then
        return self:move(0, 1)
      end
    end,
    draw = function(self)
      lg.setColor(ORANGE)
      lg.circle("fill", self.pos.x * 8 + 3, self.pos.y * 8 + 8, 8)
      lg.setColor(WHITE)
      lg.circle("line", self.pos.x * 8 + 3, self.pos.y * 8 + 8, 8)
      lg.print({
        BLACK,
        "P"
      }, self.pos.x * 8 + 1, self.pos.y * 8 + 1)
      return lg.print({
        WHITE,
        "P"
      }, self.pos.x * 8, self.pos.y * 8)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, pos)
      if pos == nil then
        pos = {
          x = 12,
          y = 7
        }
      end
      self.pos = pos
    end,
    __base = _base_0,
    __name = "OverworldPlayer"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  OverworldPlayer = _class_0
end
