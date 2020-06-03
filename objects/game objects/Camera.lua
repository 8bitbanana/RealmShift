do
  local _class_0
  local _base_0 = {
    move = function(self)
      if input:down("left") then
        self.pos.x = self.pos.x - 1
      end
      if input:down("right") then
        self.pos.x = self.pos.x + 1
      end
      if input:down("up") then
        self.pos.y = self.pos.y - 1
      end
      if input:down("down") then
        self.pos.y = self.pos.y + 1
      end
    end,
    setPos = function(self, p)
      self.pos.x = p.x - GAME_WIDTH / 2
      self.pos.y = p.y - GAME_HEIGHT / 2
    end,
    followObject = function(self, obj)
      if obj then
        self.pos.x = obj.pos.x - GAME_WIDTH / 2
        self.pos.y = obj.pos.y - GAME_HEIGHT / 2
      end
    end,
    followObjectLerp = function(self, obj, p)
      if p == nil then
        p = 0.005
      end
      if obj then
        local tx = obj.pos.x - GAME_WIDTH / 2
        local ty = obj.pos.y - GAME_HEIGHT / 2
        self.pos.x = lerp(self.pos.x, tx, p)
        self.pos.y = lerp(self.pos.y, ty, p)
      end
    end,
    limitPos = function(self, room)
      local width = (room.map.width * room.map.tilewidth) - GAME_WIDTH
      local height = (room.map.height * room.map.tileheight) - GAME_HEIGHT
      self.pos.x = clamp(0, self.pos.x, width)
      self.pos.y = clamp(0, self.pos.y, height)
    end,
    update = function(self)
      if game.state.player then
        self:followObjectLerp(game.state.player)
      end
      if game.state.current_room then
        return self:limitPos(game.state.current_room)
      end
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
    __name = "Camera"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Camera = _class_0
end
