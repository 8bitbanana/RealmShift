do
  local _class_0
  local _base_0 = {
    checkMove = function(self)
      local interval = 0.25
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
    move = function(self, dx, dy)
      if dx == nil then
        dx = 0
      end
      if dy == nil then
        dy = 0
      end
      local world = game.state.current_room.world
      local bridge_filter
      bridge_filter = function(item, other)
        if other.is_bridge then
          if game.inventory:hasItem(BridgeItem) then
            return "cross"
          else
            sounds.negative:play()
          end
        end
        return "slide"
      end
      local d = 8
      self.pos.x, self.pos.y = world:move(self, self.pos.x + (dx * d), self.pos.y + (dy * d), bridge_filter)
    end,
    update = function(self)
      self:checkMove()
      return limitPosToCurrentRoom(self)
    end,
    destroy = function(self)
      self.destroyed = true
      local world = game.state.current_room.world
      if world then
        return world:remove(self)
      end
    end,
    draw = function(self)
      local x = self.pos.x
      local y = self.pos.y
      lg.setColor(ORANGE)
      lg.circle("fill", x + 7, y + 8, 8)
      lg.setColor(WHITE)
      lg.circle("line", x + 7, y + 8, 8)
      lg.print({
        BLACK,
        "P"
      }, x + 5, y + 1)
      return lg.print({
        WHITE,
        "P"
      }, x + 4, y)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, pos)
      if pos == nil then
        pos = {
          x = 48,
          y = 48
        }
      end
      self.pos = pos
      self.width = 16
      self.height = 16
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
