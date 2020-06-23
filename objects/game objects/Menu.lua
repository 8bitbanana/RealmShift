do
  local _class_0
  local _base_0 = {
    moveCursor = function(self)
      if input:pressed('up') then
        if self.cursor == 1 then
          self.cursor = #self.current_menu
        else
          self.cursor = self.cursor - 1
        end
      end
      if input:pressed('down') then
        if self.cursor == #self.current_menu then
          self.cursor = 1
        else
          self.cursor = self.cursor + 1
        end
      end
    end,
    chooseOption = function(self)
      if input:pressed("confirm") then
        local current = self.current_menu[self.cursor]
        if self.callbacks[current] then
          return self.callbacks[current]()
        end
      end
    end,
    drawPill = function(self, x, y, w, h, col)
      lg.setColor(col)
      lg.ellipse("fill", round(x - 2), round(y + 8), 6, 6)
      lg.ellipse("fill", round(x + w + 2), round(y + 8), 6, 6)
      lg.rectangle("fill", x - 2, y + 2, w + 4, 12)
      return lg.setColor(WHITE)
    end,
    drawOptionBackground = function(self, i, x, y, width, col)
      if i == self.cursor then
        self:drawPill(x, y + 2, width, 12, BLACK)
        if (self.count % self.blink) < self.blink / 2 then
          return self:drawPill(x, y, width, 12, {
            col[1] + 0.1,
            col[2] + 0.1,
            col[3] + 0.1
          })
        else
          return self:drawPill(x, y, width, 12, col)
        end
      else
        return self:drawPill(x, y, width, 12, {
          col[1] - 0.1,
          col[2] - 0.1,
          col[3] - 0.1
        })
      end
    end,
    drawMenuOption = function(self, i, item, x, y, col)
      local font = lg.getFont()
      local width = font:getWidth(item)
      local cx = x - (width / 2)
      self:drawOptionBackground(i, cx, y, width, col)
      if i == self.cursor then
        return shadowPrint(item, cx, y)
      else
        return shadowPrint(item, cx, y, {
          0.8,
          0.8,
          0.8
        })
      end
    end,
    drawMenuOptions = function(self, x, y, col)
      if x == nil then
        x = 0
      end
      if y == nil then
        y = 0
      end
      for i = 1, #self.current_menu do
        local ty = y + i * 16
        self:drawMenuOption(i, self.current_menu[i], x, ty, col)
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
    update = function(self)
      self.timer:update(dt)
      self.count = self.count + dt
      self:moveCursor()
      return self:chooseOption()
    end,
    draw = function(self, col)
      if col == nil then
        col = {
          0.1,
          0.75,
          0.85
        }
      end
      self:drawMenuOptions(GAME_WIDTH / 2, self.menu_y, col)
      return self:drawControls(42, self.menu_y)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, menu_y)
      if menu_y == nil then
        menu_y = 80
      end
      self.menu_y = menu_y
      self.timer = Timer()
      self.count = 0
      self.blink = 0.4
      self.cursor = 1
      self.current_menu = nil
      self.callbacks = nil
    end,
    __base = _base_0,
    __name = "Menu"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Menu = _class_0
end
