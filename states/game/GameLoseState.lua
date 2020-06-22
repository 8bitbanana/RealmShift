do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    init = function(self) end,
    restartGame = function(self)
      game.next_state = {
        state = GameTitleState,
        params = { }
      }
    end,
    update = function(self)
      return self.timer:update(dt)
    end,
    draw = function(self)
      lg.clear(BLACK)
      lg.setFont(big_font)
      lg.setColor(WHITE)
      lg.print("game over", 80, 64)
      return lg.setFont(default_font)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent)
      self.parent = parent
      self.timer = Timer()
      return self.timer:after(4, self.restartGame, 'restart')
    end,
    __base = _base_0,
    __name = "GameLoseState",
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
  GameLoseState = _class_0
end
