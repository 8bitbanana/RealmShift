do
  local _class_0
  local _parent_0 = Menu
  local _base_0 = {
    resumeGame = function(self)
      game.paused = false
    end,
    saveAndQuit = function(self)
      game.paused = false
      serialise(game)
      game.next_state = {
        state = GameTitleState,
        params = { }
      }
    end,
    draw = function(self, col)
      lg.setColor({
        0,
        0,
        0,
        0.75
      })
      lg.rectangle("fill", 0, 0, GAME_WIDTH, GAME_HEIGHT)
      lg.setColor(WHITE)
      lg.setFont(big_font)
      shadowPrint("Paused", 92, 32)
      lg.setFont(default_font)
      return _class_0.__parent.draw(self, col)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      _class_0.__parent.__init(self, 64)
      self.options = {
        "Resume",
        "Save & Quit"
      }
      self.current_menu = self.options
      self.callbacks = {
        ["Resume"] = (function()
          local _base_1 = self
          local _fn_0 = _base_1.resumeGame
          return function(...)
            return _fn_0(_base_1, ...)
          end
        end)(),
        ["Save & Quit"] = (function()
          local _base_1 = self
          local _fn_0 = _base_1.saveAndQuit
          return function(...)
            return _fn_0(_base_1, ...)
          end
        end)()
      }
    end,
    __base = _base_0,
    __name = "PauseMenu",
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
  PauseMenu = _class_0
end
