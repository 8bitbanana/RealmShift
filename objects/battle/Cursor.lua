local Inspect = require("lib/inspect")
do
  local _class_0
  local _base_0 = {
    update = function(self)
      local offset = math.sin(self.t / 10)
      local _exp_0 = self.dir
      if "left" == _exp_0 then
        self.posoffset.x = offset
      elseif "right" == _exp_0 then
        self.posoffset.x = offset
      elseif "up" == _exp_0 then
        self.posoffset.y = offset
      elseif "down" == _exp_0 then
        self.posoffset.y = offset
      end
      self.t = self.t + 1
    end,
    draw = function(self)
      local postotal = {
        x = self.pos.x + self.posoffset.x,
        y = self.pos.y + self.posoffset.y
      }
      local _exp_0 = self.dir
      if "left" == _exp_0 then
        return sprites.battle.cursor_right:draw(postotal.x, postotal.y)
      elseif "right" == _exp_0 then
        return sprites.battle.cursor_right:draw(postotal.x, postotal.y)
      elseif "up" == _exp_0 then
        return sprites.battle.cursor_down:draw(postotal.x, postotal.y)
      elseif "down" == _exp_0 then
        return sprites.battle.cursor_down:draw(postotal.x, postotal.y)
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, pos, dir)
      self.pos, self.dir = pos, dir
      self.posoffset = {
        x = 0,
        y = 0
      }
      self.t = 0
    end,
    __base = _base_0,
    __name = "Cursor"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Cursor = _class_0
end
