do
  local _class_0
  local _base_0 = {
    draw = function(self)
      lg.setFont(dialog_font)
      lg.setColor(0, 0, 0)
      return lg.print(self.text, self.pos.x, self.pos.y)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, text, cancel)
      if cancel == nil then
        cancel = false
      end
      self.text, self.cancel = text, cancel
      self.pos = {
        x = 0,
        y = 0
      }
      self.size = {
        w = dialog_font:getWidth(self.text),
        h = dialog_font:getHeight(self.text)
      }
    end,
    __base = _base_0,
    __name = "ModalOption"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  ModalOption = _class_0
end
do
  local _class_0
  local _base_0 = {
    reset = function(self)
      self.result = nil
      self.done = false
      self.selected = 1
      for i, option in pairs(self.options) do
        if option.cancel then
          self.selected = i
        end
      end
      local optionCount = #self.options
      assert(optionCount > 0)
      local maxW = 0
      self.size = {
        w = 17,
        h = 10
      }
      local currentPos = {
        x = 14,
        y = 3
      }
      for i, option in pairs(self.options) do
        option.pos = table.shallow_copy(currentPos)
        if option.size.w > maxW then
          maxW = option.size.w
        end
        self.size.h = self.size.h + option.size.h
        if i == optionCount then
          break
        end
        self.size.h = self.size.h + 3
        currentPos.y = currentPos.y + (option.size.h + 5)
      end
      self.size.w = self.size.w + maxW
      self.pos = {
        x = GAME_WIDTH - 5 - self.size.w,
        y = GAME_HEIGHT - 5 - self.size.h
      }
      local _list_0 = self.options
      for _index_0 = 1, #_list_0 do
        local option = _list_0[_index_0]
        option.pos.x = option.pos.x + self.pos.x
        option.pos.y = option.pos.y + self.pos.y
      end
      self.cursor = Cursor({
        x = 0,
        y = 0
      }, "right")
      return self:updateCursorPos()
    end,
    advanceInput = function(self)
      return self:select()
    end,
    cancelInput = function(self)
      for i, option in pairs(self.options) do
        if option.cancel then
          self.selected = i
          self:select()
          return 
        end
      end
    end,
    updateCursorPos = function(self)
      local option = self:selectedOption()
      local mid = math.floor(option.size.h / 2)
      self.cursor.pos = table.shallow_copy(option.pos)
      self.cursor.pos.x = self.cursor.pos.x - 15
      self.cursor.pos.y = self.cursor.pos.y + (mid - 10)
    end,
    selectedOption = function(self)
      return self.options[self.selected]
    end,
    update = function(self)
      if input:pressed("up") then
        self:moveOptionCursor(-1)
      end
      if input:pressed("down") then
        self:moveOptionCursor(1)
      end
      return self.cursor:update()
    end,
    moveOptionCursor = function(self, dir)
      self.selected = self.selected + dir
      if self.selected < 1 then
        self.selected = 1
      end
      if self.selected > #self.options then
        self.selected = #self.options
      end
      return self:updateCursorPos()
    end,
    select = function(self)
      self.result = self.selected
      self.done = true
    end,
    draw = function(self)
      lg.setColor(1, 1, 1)
      lg.rectangle("fill", self.pos.x, self.pos.y, self.size.w, self.size.h)
      lg.setColor(0, 0, 0)
      lg.rectangle("line", self.pos.x, self.pos.y, self.size.w, self.size.h)
      local _list_0 = self.options
      for _index_0 = 1, #_list_0 do
        local option = _list_0[_index_0]
        option:draw()
      end
      return self.cursor:draw()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, options)
      self.options = options
      if self.options == nil then
        self.options = {
          ModalOption("Sure!"),
          ModalOption("Wait a second...", true)
        }
      else
        for i, option in pairs(self.options) do
          if type(option) == "string" then
            if string.sub(option, 1, 8) == "[CANCEL]" then
              self.options[i] = ModalOption(string.sub(option, 9), true)
            else
              self.options[i] = ModalOption(option)
            end
          end
        end
      end
      return self:reset()
    end,
    __base = _base_0,
    __name = "DialogModal"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  DialogModal = _class_0
end
