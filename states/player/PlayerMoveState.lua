do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    updateVel = function(self)
      local p = self.parent
      local spd = self.acc * dt
      if input:down("left") then
        p.vel.x = p.vel.x - spd
      end
      if input:down("right") then
        p.vel.x = p.vel.x + spd
      end
      if input:down("up") then
        p.vel.y = p.vel.y - spd
      end
      if input:down("down") then
        p.vel.y = p.vel.y + spd
      end
    end,
    applyFric = function(self)
      local p = self.parent
      local v = p.vel
      local fric = self.fric * dt
      if v.x > fric then
        v.x = v.x - fric
      elseif v.x < -fric then
        v.x = v.x + fric
      else
        v.x = 0
      end
      if v.y > fric then
        v.y = v.y - fric
      elseif v.y < -fric then
        v.y = v.y + fric
      else
        v.y = 0
      end
    end,
    limitVel = function(self)
      local p = self.parent
      local mv = self.max_vel * dt
      p.vel.x = clamp(-mv, p.vel.x, mv)
      p.vel.y = clamp(-mv, p.vel.y, mv)
    end,
    applyVel = function(self)
      local world = game.state.current_room.world
      local p = self.parent
      p.pos.x, p.pos.y = world:move(p, p.pos.x + p.vel.x, p.pos.y + (p.height / 2) + p.vel.y)
      p.pos.y = p.pos.y - (p.height / 2)
    end,
    update = function(self)
      self:updateVel()
      self:applyFric()
      self:limitVel()
      self:applyVel()
      if not dirPressed() and (abs(self.parent.vel.x) + abs(self.parent.vel.y)) < 0.1 then
        return self:changeState(PlayerIdleState)
      end
    end,
    draw = function(self)
      if self.parent.sprite then
        return self.parent.sprite:draw(self.parent.pos.x, self.parent.pos.y)
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent)
      self.parent = parent
      self.acc = 24
      self.fric = 12
      self.max_vel = 60
    end,
    __base = _base_0,
    __name = "PlayerMoveState",
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
  PlayerMoveState = _class_0
end
