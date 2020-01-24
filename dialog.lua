local Timer = require("lib/Timer")
local X_SPACING = 0
local Y_SPACING = 2
local FRAME_MOD = 4
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
do
  local _class_0
  local _base_0 = {
    reset = function(self)
      self.started = false
      self.done = false
      self.chars = string.totable(self.text)
      self.currentState = { }
      self.currentIndex = 0
      self.framecount = 0
    end,
    begin = function(self)
      self.started = true
    end,
    update = function(self, dt)
      if self.started then
        self.framecount = self.framecount + 1
        if self.framecount % FRAME_MOD == 0 then
          return self:incText()
        end
      end
    end,
    currentChar = function(self)
      return self.chars[self.currentIndex]
    end,
    incText = function(self)
      self.currentIndex = self.currentIndex + 1
      if self.currentIndex <= #self.text then
        self.currentState[#self.currentState + 1] = {
          char = self:currentChar(),
          width = font:getWidth(self:currentChar()),
          width = font:getHeight("Iq")
        }
      else
        self.done = true
      end
    end,
    draw = function(self)
      lg.setColor(1, 1, 1)
      lg.rectangle("fill", 3, 107, 234, 50)
      local width = 0
      local height = 0
      lg.setColor(0, 0, 0)
      lg.setFont(font)
      if self.started then
        for index, state in pairs(self.currentState) do
          local xoffset = width
          local yoffset = height
          if state.char == "\n" then
            height = height + (state.height + Y_SPACING)
            width = 0
          else
            lg.print(state.char, 6 + xoffset, 110 + yoffset, 0)
            width = width + (state.width + X_SPACING)
          end
        end
      end
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
