do
  local _class_0
  local _base_0 = {
    reset = function(self)
      self.queue = { }
      self.running = false
      self.awaitinginput = false
    end,
    push = function(self, dialog)
      table.insert(self.queue, dialog)
      if not self.running then
        self.queue[1]:begin()
        self.running = true
      end
    end,
    advanceInput = function(self)
      if self.queue[1] ~= nil then
        return self.queue[1]:advanceInput()
      end
    end,
    update = function(self)
      if self.queue[1] ~= nil then
        self.queue[1]:update()
        self.awaitinginput = self.queue[1].awaitinginput
        if self.queue[1].done then
          table.remove(self.queue, 1)
          Push:setCanvas("dialogbox")
          lg.clear()
          Push:setCanvas("main")
          if self.queue[1] == nil then
            self.running = false
          else
            return self.queue[1]:begin()
          end
        end
      end
    end,
    draw = function(self)
      if self.queue[1] ~= nil then
        return self.queue[1]:draw()
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      return self:reset()
    end,
    __base = _base_0,
    __name = "DialogManager"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  DialogManager = _class_0
end
