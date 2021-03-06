do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    resetVel = function(self)
      self.parent.vel.x = 0
      self.parent.vel.y = 0
    end,
    update = function(self)
      if dirPressed() then
        return self:changeState(PlayerMoveState)
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
      return self:resetVel()
    end,
    __base = _base_0,
    __name = "PlayerIdleState",
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
  PlayerIdleState = _class_0
end
