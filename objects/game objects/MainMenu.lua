do
  local _class_0
  local _base_0 = {
    animateMenu = function(self)
      return self.timer:tween(2, self, {
        menu_y = 64
      }, 'in-out-cubic')
    end,
    moveCursor = function(self)
      if input:pressed('up') then
        self.cursor = max(1, self.cursor - 1)
      end
      if input:pressed('down') then
        self.cursor = min(#self.current_menu, self.cursor + 1)
      end
    end,
    chooseOption = function(self)
      if input:pressed('confirm') then
        local current = self.current_menu[self.cursor]
        local _exp_0 = (current)
        if "Start Game" == _exp_0 then
          return self:startGame()
        elseif "Options" == _exp_0 then
          return self:enterOptions()
        elseif "Toggle Fullscreen" == _exp_0 then
          return self:toggleFullscreen()
        elseif "Credits" == _exp_0 then
          return self:enterCredits()
        elseif "Quit" == _exp_0 then
          return self:quitGame()
        end
      elseif input:pressed('back') then
        if self.current_menu ~= self.main_menu then
          self.current_menu = self.main_menu
          self.cursor = 1
        end
      end
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
    update = function(self)
      self.timer:update(dt)
      self.count = self.count + dt
      self:moveCursor()
      return self:chooseOption()
    end,
    drawPill = function(self, x, y, w, h, col)
      if col == nil then
        col = {
          0.1,
          0.75,
          0.85
        }
      end
      lg.setColor(col)
      lg.ellipse("fill", round(x - 2), round(y + 8), 6, 6)
      lg.ellipse("fill", round(x + w + 2), round(y + 8), 6, 6)
      lg.rectangle("fill", x - 2, y + 2, w + 4, 12)
      return lg.setColor(WHITE)
    end,
    drawOptionBackground = function(self, i, x, y, width)
      if i == self.cursor then
        self:drawPill(x, y + 2, width, 12, BLACK)
        if (self.count % self.blink) < self.blink / 2 then
          return self:drawPill(x, y, width, 12, {
            0.4,
            0.85,
            1.0
          })
        else
          return self:drawPill(x, y, width, 12)
        end
      else
        return self:drawPill(x, y, width, 12)
      end
    end,
    drawMenuOption = function(self, i, item, x, y)
      local font = lg.getFont()
      local width = font:getWidth(item)
      local cx = x - (width / 2)
      self:drawOptionBackground(i, cx, y, width)
      return shadowPrint(item, cx, y)
    end,
    drawMenuOptions = function(self, x, y)
      if x == nil then
        x = 0
      end
      if y == nil then
        y = 0
      end
      for i = 1, #self.current_menu do
        local ty = y + i * 16
        self:drawMenuOption(i, self.current_menu[i], x, ty)
      end
    end,
    drawControls = function(self, x, y)
      if x == nil then
        x = 0
      end
      if y == nil then
        y = 0
      end
      lg.setColor(WHITE)
      lg.print("z - accept", x, y + 82)
      return lg.print("x - back", x + 96, y + 82)
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
    draw = function(self)
      if self.current_menu == self.credits_menu then
        self:drawCreditsMenu(64, 64)
      else
        self:drawMenuOptions(GAME_WIDTH / 2, self.menu_y)
      end
      return self:drawControls(42, self.menu_y)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.timer = Timer()
      self.count = 0
      self.blink = 0.4
      self.menu_y = GAME_HEIGHT + 8
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
      self.cursor = 1
      return self.timer:after(0.5, (function()
        local _base_1 = self
        local _fn_0 = _base_1.animateMenu
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)())
    end,
    __base = _base_0,
    __name = "MainMenu"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  MainMenu = _class_0
end
