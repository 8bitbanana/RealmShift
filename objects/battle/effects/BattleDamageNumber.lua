local Inspect = require("lib/inspect")
do
  local _class_0
  local _base_0 = {
    update = function(self)
      if self.time < 7 then
        self.currentalpha = (self.time / 7)
      else
        if self.time < 30 then
          self.currentalpha = 1 - ((self.time - 7) / 23)
        else
          self.destroyed = true
          self.currentalpha = 0
        end
      end
      self.currentoffset = vector.mult(vector.up, self.time)
      self.time = self.time + 1
    end,
    draw = function(self)
      lg.setColor(0, 0, 0, self.currentalpha)
      local newpos = vector.add(self.pos, self.currentoffset)
      return lg.print(tostring(self.number), newpos.x, newpos.y)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, pos, number)
      self.pos, self.number = pos, number
      self.currentoffset = {
        x = 0,
        y = 0
      }
      self.currentalpha = 0
      self.time = 0
      self.destroyed = false
    end,
    __base = _base_0,
    __name = "BattleDamageNumber"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  BattleDamageNumber = _class_0
end
