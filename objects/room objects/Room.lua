do
  local _class_0
  local _base_0 = {
    update = function(self)
      return self.map:update(dt)
    end,
    draw = function(self, pos)
      if pos == nil then
        pos = {
          x = 0,
          y = 0
        }
      end
      lg.setColor(WHITE)
      self.map:draw(-pos.x, -pos.y)
      if SHOW_COLLIDERS then
        lg.setColor(RED)
        return self.map:bump_draw(self.world, -pos.x, -pos.y)
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, room_path)
      self.world = Bump.newWorld()
      self.map = STI("rooms/" .. tostring(room_path) .. ".lua", {
        "bump"
      })
      return self.map:bump_init(self.world)
    end,
    __base = _base_0,
    __name = "Room"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Room = _class_0
end
