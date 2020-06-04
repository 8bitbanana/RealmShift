require("states/state")
do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    init = function(self)
      self.current_room:init()
      self.player = OverworldPlayer({
        x = self.tx,
        y = self.ty
      })
      self.camera = Camera()
      self.camera:setPos(self.player.pos)
      self.camera:limitPos(self.current_room)
      self.objects:addObject(self.camera)
      self.objects:addObject(self.player)
      self.current_room.world:add(self.player, self.player.pos.x, self.player.pos.y, self.player.width, self.player.height)
      return self.enemy_timer:every(self.enemy_spawn_rate, (function()
        local _base_1 = self
        local _fn_0 = _base_1.spawnEnemy
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)())
    end,
    spawnEnemy = function(self)
      local enemy_count = self.objects:countObjects("OverworldEnemy")
      if enemy_count < self.max_enemies then
        local range = 5
        local tx = self.player.pos.x + (math.random(range * 2) - range) * 8
        local ty = self.player.pos.y + (math.random(range * 2) - range) * 8
        print(tx, ty)
        local e = OverworldEnemy({
          x = tx,
          y = ty
        })
        return self.objects:addObject(e)
      end
    end,
    destroy = function(self)
      self.enemy_timer:destroy()
      return _class_0.__parent.destroy(self)
    end,
    update = function(self)
      self.enemy_timer:update(dt)
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
    __init = function(self, parent, tx, ty)
      if tx == nil then
        tx = 0
      end
      if ty == nil then
        ty = 0
      end
      self.parent, self.tx, self.ty = parent, tx, ty
      self.objects = ObjectManager()
      self.current_room = Room("overworld/overworld_1")
      self.enemy_spawn_rate = 3
      self.max_enemies = 3
      self.enemy_timer = Timer()
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
