local TAIL_LENGTH = 6
local OFFSET_PER_FRAME = {
  x = -5,
  y = 5
}
do
  local _class_0
  local _base_0 = {
    update = function(self)
      self.startoffset = vector.add(self.startoffset, OFFSET_PER_FRAME)
      self.endoffset = vector.add(self.endoffset, OFFSET_PER_FRAME)
      if self.endoffset.y > 140 then
        self.destroyed = true
      else
        self.time = self.time + 1
      end
    end,
    draw = function(self)
      lg.setColor(0, 0, 1)
      return lg.line(self.startoffset.x, self.startoffset.y, self.endoffset.x, self.endoffset.y)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, pos)
      self.pos = pos
      self.startoffset = self.pos
      self.endoffset = vector.add(self.startoffset, vector.mult(OFFSET_PER_FRAME, TAIL_LENGTH))
      self.time = 0
      self.destroyed = false
    end,
    __base = _base_0,
    __name = "BattleHail"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  BattleHail = _class_0
end
