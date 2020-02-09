require("states/state")
do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    init = function(self)
      self.current_room:init()
      self.player = OverworldPlayer()
      self.camera = Camera()
      self.objects:addObject(self.camera)
      return self.objects:addObject(self.player)
    end,
    update = function(self)
      self.objects:updateObjects()
      return self.objects:checkDestroyed()
    end,
    draw = function(self)
      self.current_room:draw(self.camera.pos)
      lg.push()
      lg.translate(-self.camera.pos.x, -self.camera.pos.y)
      self.objects:drawObjects()
      shadowPrint("This is the overworld!\nThis is where the player will explore the\nworld and enter new areas such as towns &\ndungeons etc.\n\n\n\n\n\nCurrently all you can do is move.")
      return lg.pop()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      self.objects = ObjectManager()
      self.current_room = Room("overworld/overworld_1")
    end,
    __base = _base_0,
    __name = "GameOverworldState",
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
  GameOverworldState = _class_0
end
