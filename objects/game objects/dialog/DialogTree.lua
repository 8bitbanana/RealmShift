do
  local _class_0
  local _base_0 = {
    reset = function(self)
      self.currentIndex = 1
      self.lastOption = nil
      self.started = false
      self.done = false
      self.awaitinginput = false
    end,
    current = function(self)
      return self.dialogs[self.currentIndex]
    end,
    advanceInput = function(self)
      if self:current() then
        return self:current():advanceInput()
      end
    end,
    finish = function(self)
      self.done = true
    end,
    nextup = function(self)
      local previous = self:current()
      local next = self.map[self.currentIndex]
      local _exp_0 = type(next)
      if "number" == _exp_0 then
        self.currentIndex = next
      elseif "table" == _exp_0 then
        self.currentIndex = next[self.lastOption]
      elseif "nil" == _exp_0 then
        self.currentIndex = nil
      else
        error("Unexpected type in @map")
      end
      if self.currentIndex == nil then
        self:finish()
      end
      if self:current() == nil then
        return self:finish()
      else
        return self:current():reset()
      end
    end,
    update = function(self)
      if self:current() ~= nil then
        self:current():update()
        do
          local _base_1 = self:current()
          local _fn_0 = _base_1.awaitinginput
          self.awaitinginput = function(...)
            return _fn_0(_base_1, ...)
          end
        end
        if self:current().done then
          self.lastOption = self:current().modalresult
          return self:nextup()
        end
      end
    end,
    draw = function(self)
      if self:current() then
        return self:current():draw()
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, dialogs, map)
      self.dialogs, self.map = dialogs, map
      return self:reset()
    end,
    __base = _base_0,
    __name = "DialogTree"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  DialogTree = _class_0
end
