require("states/state")
do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    update = function(self)
      self.objects:updateObjects()
      return self.objects:checkDestroyed()
    end,
    draw = function(self)
      self.current_room:draw(self.camera.pos)
      lg.push()
      lg.translate(-self.camera.pos.x, -self.camera.pos.y)
      self.objects:drawObjects()
      return lg.pop()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent, room_path)
      if room_path == nil then
        room_path = "towns/test_town"
      end
      self.parent = parent
      self.current_room = Room(room_path)
      self.objects = ObjectManager()
      self.player = Player({
        x = 64,
        y = 64
      })
      self.camera = Camera()
      self.objects:addObject(self.player)
      self.objects:addObject(self.camera)
      return self.current_room.world:add(self.player, self.player.pos.x, self.player.pos.y, self.player.width, self.player.height)
    end,
    __base = _base_0,
    __name = "GameExploreState",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  GameExploreState = _class_0
end
