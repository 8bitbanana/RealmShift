local Timer = require("lib/Timer")
local X_SPACING = 0
local Y_SPACING = 0
local FRAME_MOD = 4
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
math.sign = function(x)
  if x < 0 then
    return -1
  elseif x > 0 then
    return 1
  else
    return 0
  end
end
do
  local _class_0
  local _base_0 = {
    reset = function(self)
      self.started = false
      self.done = false
      self.visible = false
      self.chars = string.totable(self.text)
      self.currentState = { }
      self.currentIndex = 0
      self.framecount = 0
      self.skipcount = 0
      self.effectData = { }
      self.linecount = 1
      self.targetscrolloffset = 0
      self.scrolloffset = self.targetscrolloffset
    end,
    begin = function(self)
      if not self.started then
        self.started = true
        return self:incText()
      end
    end,
    update = function(self, dt)
      if self.started then
        self.framecount = self.framecount + 1
        if self.skipcount > 0 then
          self.skipcount = self.skipcount - 1
        end
        if self.targetscrolloffset ~= self.scrolloffset then
          self.scrolloffset = self.scrolloffset + math.sign(self.targetscrolloffset - self.scrolloffset)
        end
        if self.framecount % FRAME_MOD == 0 and self.skipcount == 0 then
          return self:incText()
        end
      end
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
    currentChar = function(self)
      return self.chars[self.currentIndex]
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
            width = dialogfont:getWidth(self:currentChar()),
            height = dialogfont:getHeight(),
            effects = effects
          }
          if self:currentChar() == "\n" then
            self.linecount = self.linecount + 1
            if self.linecount > 3 then
              self.targetscrolloffset = self.targetscrolloffset - dialogfont:getHeight()
            end
          end
        end
      else
        self.done = true
      end
    end,
    draw = function(self)
      lg.setColor(1, 1, 1)
      lg.rectangle("fill", 3, 107, 234, 50)
      Push:setCanvas("dialogbox")
      lg.clear()
      local width = 0
      local height = 0
      lg.setFont(dialogfont)
      if self.started then
        for index, state in pairs(self.currentState) do
          if state.effects.colour ~= nil then
            lg.setColor(state.effects.colour)
          else
            lg.setColor(0, 0, 0)
          end
          local xoffset = width
          local yoffset = height
          if state.effects.wave ~= nil then
            yoffset = yoffset + (6 * math.sin((self.framecount + state.effects.wave * 3) / 10))
          end
          if state.char == "\n" then
            height = height + (state.height + Y_SPACING)
            width = 0
          else
            lg.print(state.char, 3 + xoffset, 3 + yoffset + self.scrolloffset, 0)
            width = width + (state.width + X_SPACING)
          end
        end
      end
      return Push:setCanvas("main")
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, text)
      self.text = text
      return self:reset()
    end,
    __base = _base_0,
    __name = "DialogBox"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  DialogBox = _class_0
end
