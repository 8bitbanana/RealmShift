require("objects/game objects/Menu")
do
  local _class_0
  local _parent_0 = Menu
  local _base_0 = {
    continueGame = function(self)
      deserialise(game)
      game.next_state = {
        state = GameExploreState,
        params = { }
      }
    end,
    quitToMenu = function(self)
      game.next_state = {
        state = GameTitleState,
        params = { }
      }
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      _class_0.__parent.__init(self, GAME_HEIGHT - 72)
      self.options = {
        "Continue",
        "Quit To Menu"
      }
      self.current_menu = self.options
      self.callbacks = {
        ["Continue"] = (function()
          local _base_1 = self
          local _fn_0 = _base_1.continueGame
          return function(...)
            return _fn_0(_base_1, ...)
          end
        end)(),
        ["Quit To Menu"] = (function()
          local _base_1 = self
          local _fn_0 = _base_1.quitToMenu
          return function(...)
            return _fn_0(_base_1, ...)
          end
        end)()
      }
    end,
    __base = _base_0,
    __name = "GameOverMenu",
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
  GameOverMenu = _class_0
end
