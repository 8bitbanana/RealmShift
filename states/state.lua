do
  local _class_0
  local _base_0 = {
    destroy = function(self)
      if self.objects then
        return self.objects:destroyAll()
      end
    end,
    changeState = function(self, new_state, params)
      if params == nil then
        params = { }
      end
      self:destroy()
      self.parent.state = new_state(self.parent, params)
      if self.parent.state.init then
        return self.parent.state:init()
      end
    end,
    update = function(self) end,
    draw = function(self) end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, parent)
      self.parent = parent
    end,
    __base = _base_0,
    __name = "State"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  State = _class_0
end
