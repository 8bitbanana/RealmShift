require("states/state")
do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    init = function(self)
      self.current_room:init()
      self.player = OverworldPlayer()
      self.camera = Camera()
      self.camera:setPos(self.player.pos)
      self.camera:limitPos(self.current_room)
      self.objects:addObject(self.camera)
      self.objects:addObject(self.player)
      return self.current_room.world:add(self.player, self.player.pos.x, self.player.pos.y, self.player.width, self.player.height)
    end,
    update = function(self)
      self.objects:updateObjects()
      return self.objects:checkDestroyed()
    end,
    draw = function(self)
      Push:setCanvas("main")
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
