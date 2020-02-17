require("states/state")
do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    startTransitionOut = function(self)
      return self.timer:tween(self.length / 2, self, {
        swipe_x = GAME_WIDTH + (self.swipe_padding * 2)
      }, 'out-cubic', (function()
        local _base_1 = self
        local _fn_0 = _base_1.startTransitionIn
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)())
    end,
    startTransitionIn = function(self)
      return self.timer:tween(self.length / 2, self, {
        swipe_x = -self.swipe_padding
      }, 'out-cubic')
    end,
    startNextState = function(self)
      print()
      print("startNextState:")
      print("params: " .. tostring(self.params))
      print("#params: " .. tostring(#self.params))
      print(unpack(self.params))
      print("parent: " .. tostring(self.parent))
      print("@next_state: " .. tostring(self.next_state.__name))
      print()
      local a
      a = function()
        return GameExploreState("test_room")
      end
    end,
    completeTransition = function(self)
      self.parent.state = self.temp_state_buffer
      return self:destroy()
    end,
    destroy = function(self)
      return self.timer:destroy()
    end,
    update = function(self)
      return self.timer:update(dt)
    end,
    drawTransition = function(self)
      lg.setColor(BLACK)
      lg.rectangle("fill", -self.swipe_padding, 0, self.swipe_x, GAME_HEIGHT)
      return lg.setColor(WHITE)
    end,
    draw = function(self)
      Push:setCanvas("main")
      if self.temp_state_buffer then
        self.temp_state_buffer:draw()
      end
      return self:drawTransition()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent, params)
      if params == nil then
        params = { }
      end
      self.parent, self.params = parent, params
      print("params: " .. tostring(self.params))
      print("#params: " .. tostring(#self.params))
      if self.params[2] then
        print(self.params[2])
        print("room name is successfully sent to transition state")
      end
      print()
      self.next_state = table.remove(self.params, 1)
      print("next state popped off @params")
      print("#params: " .. tostring(#self.params))
      print("next_state: " .. tostring(self.next_state))
      self.length = 2
      self.swipe_padding = 32
      self.swipe_x = -self.swipe_padding
      self.timer = Timer()
      self.temp_state_buffer = nil
      self:startTransitionOut()
      self.timer:after(self.length / 2, (function()
        local _base_1 = self
        local _fn_0 = _base_1.startNextState
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)())
      return self.timer:after(self.length, (function()
        local _base_1 = self
        local _fn_0 = _base_1.completeTransition
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)())
    end,
    __base = _base_0,
    __name = "GameTransitionState",
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
  GameTransitionState = _class_0
end
