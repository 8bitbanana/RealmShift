do
  local _class_0
  local _base_0 = {
    gotoOverworld = function(self)
      print("gotoOverworld")
      game.next_state = GameOverworldState
    end,
    gotoRoom = function(self) end,
    changeRoom = function(self)
      if self.dest == "overworld" then
        return self:gotoOverworld()
      else
        return self:gotoRoom()
      end
    end,
    checkPlayerEntered = function(self)
      local p = game.state.player
      if p then
        local hw = p.width / 2
        local hh = p.height / 2
        local point = {
          x = p.pos.x + hw,
          y = p.pos.y + hh
        }
        local box = {
          x = self.pos.x,
          y = self.pos.y,
          width = self.width,
          height = self.height
        }
        if pointBoxCollision(point, box) then
          return self:changeRoom()
        end
      end
    end,
    update = function(self)
      return self:checkPlayerEntered()
    end,
    draw = function(self)
      lg.setColor(ORANGE)
      lg.rectangle("line", self.pos.x, self.pos.y, self.width, self.height)
      lg.print({
        BLACK,
        "Dest: " .. tostring(self.dest)
      }, self.pos.x + 1, self.pos.y - 15)
      lg.setColor(WHITE)
      return lg.print("Dest: " .. tostring(self.dest), self.pos.x, self.pos.y - 16)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, pos, width, height, dest, tx, ty)
      if pos == nil then
        pos = {
          x = 0,
          y = 0
        }
      end
      if width == nil then
        width = 16
      end
      if height == nil then
        height = 16
      end
      if dest == nil then
        dest = "test_room_1"
      end
      if tx == nil then
        tx = 0
      end
      if ty == nil then
        ty = 0
      end
      self.pos, self.width, self.height, self.dest, self.tx, self.ty = pos, width, height, dest, tx, ty
    end,
    __base = _base_0,
    __name = "RoomExit"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  RoomExit = _class_0
end
