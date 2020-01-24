do
  local _class_0
  local _base_0 = {
    update = function(self)
      self.state:update()
      return self.dialogbox:update(0)
    end,
    draw = function(self)
      self.state:draw()
      return self.dialogbox:draw()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.state = GameExploreState(self)
      self.dialogbox = DialogBox("This is a test")
      return self.dialogbox:begin()
    end,
    __base = _base_0,
    __name = "Game"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Game = _class_0
end
