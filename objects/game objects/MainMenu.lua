require("objects/game objects/Menu")
do
  local _class_0
  local _parent_0 = Menu
  local _base_0 = {
    animateMenu = function(self)
      return self.timer:tween(2, self, {
        menu_y = 64
      }, 'in-out-cubic')
    end,
    startGame = function(self)
      game.next_state = {
        state = GameExploreState,
        params = { }
      }
    end,
    quitGame = function(self)
      return le.quit()
    end,
    enterOptions = function(self)
      self.cursor = 1
      self.current_menu = self.option_menu
    end,
    enterCredits = function(self)
      self.cursor = 1
      self.current_menu = self.credits_menu
    end,
    toggleFullscreen = function(self)
      return Push:switchFullscreen()
    end,
    checkGoBack = function(self)
      if input:pressed('back') then
        if self.current_menu ~= self.main_menu then
          self.current_menu = self.main_menu
          self.cursor = 1
        end
      end
    end,
    update = function(self)
      _class_0.__parent.update(self)
      return self:checkGoBack()
    end,
    drawCreditsMenu = function(self, x, y)
      if x == nil then
        x = 0
      end
      if y == nil then
        y = 0
      end
      local font = lg.getFont()
      for i = 1, #self.current_menu do
        local tx = x + floor(i / 4) * 114
        local ty = y + (((i - 1) * 16) % 64)
        local item = self.current_menu[i]
        local width = font:getWidth(item)
        local cx = tx - (width / 2)
        self:drawPill(cx, ty, width, 12, GOLD)
        shadowPrint(item, cx, ty)
      end
    end,
    draw = function(self, col)
      if col == nil then
        col = {
          0.1,
          0.75,
          0.85
        }
      end
      if self.current_menu == self.credits_menu then
        self:drawCreditsMenu(64, 64)
      else
        self:drawMenuOptions(GAME_WIDTH / 2, self.menu_y, col)
      end
      return self:drawControls(42, self.menu_y)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      _class_0.__parent.__init(self, GAME_HEIGHT + 8)
      self.main_menu = {
        "Start Game",
        "Options",
        "Credits",
        "Quit"
      }
      self.option_menu = {
        "Toggle Fullscreen"
      }
      self.credits_menu = {
        "Ethan (924610)",
        "Cody (924610)",
        "Anthony (941967)",
        "Daniel (943856)",
        "Jack (902197)",
        "Naomi (899468)",
        "Faybia (945607)"
      }
      self.current_menu = self.main_menu
      self.callbacks = {
        ["Start Game"] = (function()
          local _base_1 = self
          local _fn_0 = _base_1.startGame
          return function(...)
            return _fn_0(_base_1, ...)
          end
        end)(),
        ["Options"] = (function()
          local _base_1 = self
          local _fn_0 = _base_1.enterOptions
          return function(...)
            return _fn_0(_base_1, ...)
          end
        end)(),
        ["Toggle Fullscreen"] = (function()
          local _base_1 = self
          local _fn_0 = _base_1.toggleFullscreen
          return function(...)
            return _fn_0(_base_1, ...)
          end
        end)(),
        ["Credits"] = (function()
          local _base_1 = self
          local _fn_0 = _base_1.enterCredits
          return function(...)
            return _fn_0(_base_1, ...)
          end
        end)(),
        ["Quit"] = (function()
          local _base_1 = self
          local _fn_0 = _base_1.quitGame
          return function(...)
            return _fn_0(_base_1, ...)
          end
        end)()
      }
      return self.timer:after(0.5, (function()
        local _base_1 = self
        local _fn_0 = _base_1.animateMenu
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)())
    end,
    __base = _base_0,
    __name = "MainMenu",
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
  MainMenu = _class_0
end
