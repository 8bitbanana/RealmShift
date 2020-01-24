local Timer = require("lib/Timer")
local font = lg.newFont("fonts/iso8.ttf")
string.split = function(s, delim)
  local _accum_0 = { }
  local _len_0 = 1
  for w in s:gmatch("([^" .. delim .. "]+)") do
    _accum_0[_len_0] = w
    _len_0 = _len_0 + 1
  end
  return _accum_0
end
string.totable = function(s)
  local t = { }
  s:gsub(".", function(c)
    return table.insert(t, c)
  end)
  return t
end
table.shallow_copy = function(t)
  local _tbl_0 = { }
  for k, v in pairs(t) do
    _tbl_0[k] = v
  end
  return _tbl_0
end
local DialogText
do
  local _class_0
  local _base_0 = {
    reset = function(self)
      self.framecount = 0
      self.started = false
      self.done = false
      self.currentState = { }
      self.currentIndex = 0
      self.timer = nil
      self.chars = string.totable(self.text)
      self.skipcount = 0
      self.effectData = { }
    end,
    fillConfigDefaults = function(self)
      local defaults = {
        framemod = 4,
        colour = {
          1,
          1,
          1,
          1
        },
        xspacing = 0,
        yspacing = 0,
        xmax = -1,
        ymax = 3
      }
      for key, defaultvalue in pairs(defaults) do
        if self.config[key] == nil then
          self.config[key] = defaultvalue
        end
      end
    end,
    begin = function(self)
      if not self.started then
        self.started = true
        self.timer = Timer()
        return self:incText()
      end
    end,
    currentChar = function(self)
      return self.chars[self.currentIndex]
    end,
    handleEffects = function(self)
      local effects = { }
      if self:currentChar() == "{" then
        local code = ""
        self.currentIndex = self.currentIndex + 1
        while self:currentChar() ~= "}" do
          code = code .. self:currentChar()
          self.currentIndex = self.currentIndex + 1
        end
        self.currentIndex = self.currentIndex + 1
        local destruct = string.split(code, ",")
        code = destruct[1]
        local args
        do
          local _accum_0 = { }
          local _len_0 = 1
          for _index_0 = 2, #destruct do
            local x = destruct[_index_0]
            _accum_0[_len_0] = x
            _len_0 = _len_0 + 1
          end
          args = _accum_0
        end
        local _exp_0 = code
        if "test" == _exp_0 then
          print(args[1])
        elseif "wave" == _exp_0 then
          self.effectData.wave = tonumber(args[1])
        elseif "framemod" == _exp_0 then
          self.config.framemod = tonumber(args[1])
        elseif "pause" == _exp_0 then
          self.skipcount = tonumber(args[1])
          effects.cancel = true
        elseif "colour" == _exp_0 then
          do
            local _accum_0 = { }
            local _len_0 = 1
            local _max_0 = 4
            for _index_0 = 1, _max_0 < 0 and #args + _max_0 or _max_0 do
              local x = args[_index_0]
              _accum_0[_len_0] = tonumber(x)
              _len_0 = _len_0 + 1
            end
            self.effectData.textColour = _accum_0
          end
          self.effectData.colourCount = tonumber(args[5])
        else
          print("Unknown code parsed - " .. code)
        end
      end
      if self.effectData.wave ~= nil then
        effects.wave = self.effectData.wave
        self.effectData.wave = self.effectData.wave - 1
        if self.effectData.wave == 0 then
          self.effectData.wave = nil
        end
      end
      if self.effectData.colourCount ~= nil then
        effects.colour = table.shallow_copy(self.effectData.textColour)
        self.effectData.colourCount = self.effectData.colourCount - 1
        if self.effectData.colourCount == 0 then
          self.effectData.colourCount = nil
          self.effectData.textColour = nil
        end
      end
      return effects
    end,
    incText = function(self)
      self.currentIndex = self.currentIndex + 1
      if self.currentIndex <= #self.text then
        local effects = self:handleEffects()
        if effects.cancel then
          self.currentIndex = self.currentIndex - 1
        else
          self.currentState[#self.currentState + 1] = {
            char = self:currentChar(),
            effects = effects,
            width = font:getWidth(self:currentChar()),
            height = font:getHeight("I")
          }
        end
      else
        self.done = true
      end
    end,
    update = function(self, dt)
      if self.started then
        self.framecount = self.framecount + 1
        self.timer:update(dt)
        if self.skipcount > 0 then
          self.skipcount = self.skipcount - 1
        end
        if self.framecount % self.config.framemod == 0 and self.skipcount == 0 then
          return self:incText()
        end
      end
    end,
    draw = function(self)
      love.graphics.setFont(font)
      local width = 0
      local height = 0
      if self.started then
        for index, state in pairs(self.currentState) do
          if state.effects.colour ~= nil then
            love.graphics.setColor(state.effects.colour)
          else
            love.graphics.setColor(self.config.colour)
          end
          local xoffset = width
          local yoffset = height
          if state.effects.wave ~= nil then
            yoffset = yoffset + (6 * math.sin((self.framecount + state.effects.wave * 3) / 10))
          end
          if state.char == "\n" then
            height = height + (state.height + self.config.yspacing)
            width = 0
          else
            love.graphics.print(state.char, self.startx + xoffset, self.starty + yoffset)
            width = width + (state.width + self.config.xspacing)
          end
        end
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, text, startx, starty, config)
      if config == nil then
        config = { }
      end
      self.text, self.startx, self.starty, self.config = text, startx, starty, config
      self:fillConfigDefaults()
      return self:reset()
    end,
    __base = _base_0,
    __name = "DialogText"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  DialogText = _class_0
end
local DialogScript
do
  local _class_0
  local _base_0 = {
    reset = function(self)
      self.currentDialog = nil
      self.currentIndex = 0
      self:incDialog()
      self.currentDialog:reset()
      self.started = false
      self.done = false
      self.readyForInput = false
      self.readyToQuit = false
    end,
    begin = function(self)
      self.started = true
      return self.currentDialog:begin()
    end,
    advanceInput = function(self)
      if not self.started then
        return self:begin()
      elseif self.readyForInput then
        local moredialog = self:incDialog()
        if moredialog then
          self.currentDialog:reset()
          return self.currentDialog:begin()
        else
          self.done = true
        end
      elseif self.done then
        self.readyToQuit = true
      end
    end,
    incDialog = function(self)
      self.currentIndex = self.currentIndex + 1
      if self.currentIndex > #self.textlist then
        return false
      end
      self.currentDialog = DialogText(self.textlist[self.currentIndex], self.startx, self.starty, self.config)
      return true
    end,
    update = function(self, dt)
      if self.currentDialog ~= nil then
        self.currentDialog:update(dt)
        self.readyForInput = self.started and not self.done and (function()
          local _base_1 = self.currentDialog
          local _fn_0 = _base_1.done
          return function(...)
            return _fn_0(_base_1, ...)
          end
        end)()
      end
    end,
    draw = function(self)
      if self.currentDialog ~= nil then
        return self.currentDialog:draw()
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, textlist, startx, starty, config)
      if config == nil then
        config = { }
      end
      self.textlist, self.startx, self.starty, self.config = textlist, startx, starty, config
      return self:reset()
    end,
    __base = _base_0,
    __name = "DialogScript"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  DialogScript = _class_0
  return _class_0
end
