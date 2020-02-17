do
  local _class_0
  local _base_0 = {
    draw = function(self)
      lg.setColor(ORANGE)
      lg.rectangle("fill", self.pos.x, self.pos.y, 24, 32)
      lg.setColor(BLACK)
      return lg.rectangle("line", self.pos.x, self.pos.y, 24, 32)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, pos)
      if pos == nil then
        pos = {
          x = 0,
          y = 0
        }
      end
      self.pos = pos
    end,
    __base = _base_0,
    __name = "BattlePlayer"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  BattlePlayer = _class_0
end
