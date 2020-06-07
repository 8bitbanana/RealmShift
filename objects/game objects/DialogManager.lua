do
  local _class_0
  local _base_0 = {
    reset = function(self)
      self.tree = nil
      self.running = false
      self.awaitinginput = false
    end,
    setTree = function(self, tree)
      self.tree = tree
      self.running = true
      self.awaitinginput = false
    end,
    advanceInput = function(self)
      if self.tree ~= nil then
        return self.tree:advanceInput()
      end
    end,
    update = function(self)
      if self.tree ~= nil then
        self.tree:update()
        self.awaitinginput = self.tree.awaitinginput
        if self.tree.done then
          Push:setCanvas("dialogbox")
          lg.clear()
          Push:setCanvas("main")
          self.tree = nil
          self.running = false
        end
      end
    end,
    draw = function(self)
      if self.tree ~= nil then
        return self.tree:draw()
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
