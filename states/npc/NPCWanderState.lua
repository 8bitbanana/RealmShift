do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    startWandering = function(self)
      self.dir = math.random() * TWO_PI
      local rtime = math.random() * 2
      return self.timer:after(self.wait_time + rtime, (function()
        local _base_1 = self
        local _fn_0 = _base_1.wander
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)())
    end,
    wander = function(self)
      local rtime = math.random() * 2
      return self.timer:during(self.wander_time, (function()
        local _base_1 = self
        local _fn_0 = _base_1.moveAround
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)(), (function()
        local _base_1 = self
        local _fn_0 = _base_1.startWandering
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)())
    end,
    moveAround = function(self)
      local angle_delta = self.dd * dt
      self.dir = self.dir + random(-angle_delta, angle_delta)
      local p = self.parent
      local world = game.state.current_room.world
      local nx = p.pos.x + cos(self.dir) * (self.spd * dt)
      local ny = p.pos.y + sin(self.dir) * (self.spd * dt)
      p.pos.x, p.pos.y = world:move(p, nx, ny)
    end,
    update = function(self)
      self.timer:update(dt)
      if self.parent.dialog then
        return self.parent:checkTalk()
      end
    end,
    draw = function(self)
      local p = self.parent
      p.sprite:draw(p.pos.x, p.pos.y)
      if p.name then
        return shadowPrint(p.name, p.pos.x, p.pos.y - 16)
      end
    end,
    destroy = function(self)
      return self.timer:destroy()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent)
      self.parent = parent
      self.wait_time = 2
      self.wander_time = 2
      self.spd = 30
      self.dir = 0
      self.dd = 8
      self.timer = Timer()
      return self:startWandering()
    end,
    __base = _base_0,
    __name = "NPCWanderState",
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
  NPCWanderState = _class_0
end
