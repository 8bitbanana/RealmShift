local Timer = require("lib/Timer")
local Inspect = require("lib/inspect")
local X_SPACING = 0
local Y_SPACING = 0
local FRAME_MOD = 2
local CURSOR_BLINK_MOD = 60
do
  local _class_0
  local _base_0 = {
    reset = function(self)
      self.modal = nil
      if self.modaloptions ~= nil then
        self.modal = DialogModal(self.modaloptions)
      end
      self.modalresult = nil
      self.waitingForModal = false
      self.skipping = false
      self.waitingForInput = false
      self.waitingForClose = false
      self.done = false
      self.visible = false
      self.currentIndex = 0
      self.framecount = 0
      self.skipcount = 0
      self.linecount = 1
      self.scrollFlag = false
      self.targetscrollOffset = 0
      self.scrollOffset = self.targetscrollOffset
      self.cursorBlinkFrameOffset = 0
      self.chars = { }
      self.tokens = { }
      self:tokenise()
      return self:incText()
    end,
    advanceInput = function(self)
      if not self.waitingForInput then
        self.skipping = true
      end
      if self.waitingForInput then
        self.waitingForInput = false
      end
      if self.waitingForClose then
        self.done = true
        self.waitingForClose = false
      end
      if self.modal and self.waitingForModal then
        self.modal:advanceInput()
        if self.modal.done then
          self.done = true
          self.modalresult = self.modal.result
          self.waitingForModal = false
        end
      end
    end,
    tokenise = function(self)
      self.chars = { }
      self.tokens = { }
      local rawTokens = { }
      local currentRawToken = ""
      local inAToken = false
      local charIndex = 0
      for index, char in pairs(string.totable(self.text)) do
        local _continue_0 = false
        repeat
          if char == "{" then
            inAToken = true
            _continue_0 = true
            break
          end
          if inAToken then
            if char == "}" then
              inAToken = false
              table.insert(rawTokens, {
                token = currentRawToken,
                index = charIndex
              })
              currentRawToken = ""
              _continue_0 = true
              break
            end
            currentRawToken = currentRawToken .. char
          else
            table.insert(self.chars, char)
            charIndex = charIndex + 1
          end
          _continue_0 = true
        until true
        if not _continue_0 then
          break
        end
      end
      for _index_0 = 1, #rawTokens do
        local x = rawTokens[_index_0]
        local rawToken = x.token
        charIndex = x.index
        local destruct = string.split(rawToken, ",")
        local code = destruct[1]
        local multilength_codes = {
          ["wave"] = true,
          ["color"] = true
        }
        local code_offsets = {
          ["input"] = -1,
          ["pause"] = -1
        }
        local length = 1
        local args = { }
        if multilength_codes[code] ~= nil then
          length = tonumber(destruct[2])
          do
            local _accum_0 = { }
            local _len_0 = 1
            for _index_1 = 3, #destruct do
              local x = destruct[_index_1]
              _accum_0[_len_0] = x
              _len_0 = _len_0 + 1
            end
            args = _accum_0
          end
        else
          do
            local _accum_0 = { }
            local _len_0 = 1
            for _index_1 = 2, #destruct do
              local x = destruct[_index_1]
              _accum_0[_len_0] = x
              _len_0 = _len_0 + 1
            end
            args = _accum_0
          end
        end
        for i = 1, length do
          local extraoffset = 0
          for k, v in pairs(code_offsets) do
            if k == code then
              extraoffset = extraoffset + v
            end
          end
          if self.tokens[charIndex + i + extraoffset] == nil then
            self.tokens[charIndex + i + extraoffset] = { }
          end
          local token = {
            code = code,
            index = i + 1,
            args = args
          }
          table.insert(self.tokens[charIndex + i + extraoffset], token)
        end
      end
    end,
    incText = function(self)
      if self.waitingForInput then
        return 
      end
      if self.currentIndex < #self.chars then
        self.currentIndex = self.currentIndex + 1
        if self.chars[self.currentIndex] == "\n" then
          self.linecount = self.linecount + 1
          if self.linecount > 3 then
            self.scrollFlag = true
            self.waitingForInput = true
            self.cursorBlinkFrameOffset = self.framecount % CURSOR_BLINK_MOD
          end
        end
        if self.tokens[self.currentIndex] ~= nil then
          local _list_0 = self.tokens[self.currentIndex]
          for _index_0 = 1, #_list_0 do
            local token = _list_0[_index_0]
            if token.code == "input" then
              self.waitingForInput = true
            end
            if token.code == "pause" then
              self.skipcount = tonumber(token.args[1])
            end
          end
        end
      else
        if self.modal then
          self.waitingForModal = true
          self.waitingForInput = true
        else
          self.waitingForInput = true
          self.waitingForClose = true
          self.cursorBlinkFrameOffset = self.framecount % CURSOR_BLINK_MOD
        end
      end
    end,
    update = function(self)
      self.framecount = self.framecount + 1
      if self.skipcount > 0 then
        self.skipcount = self.skipcount - 1
      end
      if self.scrollFlag and not self.waitingForInput then
        self.targetscrollOffset = self.targetscrollOffset - dialogfont:getHeight()
        self.scrollFlag = false
      end
      if self.targetscrollOffset ~= self.scrollOffset then
        self.scrollOffset = self.scrollOffset + math.sign(self.targetscrollOffset - self.scrollOffset)
      end
      if self.skipping then
        while not self.waitingForInput do
          self:incText()
        end
        self.skipping = false
      else
        if self.framecount % FRAME_MOD == 0 and self.skipcount == 0 then
          self:incText()
        end
      end
      if self.modal and self.waitingForModal then
        return self.modal:update()
      end
    end,
    draw = function(self)
      lg.setColor(1, 1, 1)
      lg.rectangle("fill", 3, 107, 234, 50)
      lg.setColor(0, 0, 0)
      lg.rectangle("line", 3, 107, 234, 50)
      Push:setCanvas("dialogbox")
      lg.clear()
      local width = 0
      local height = 0
      lg.setFont(dialogfont)
      for index = 1, self.currentIndex do
        lg.setColor(0, 0, 0)
        local xoffset = width
        local yoffset = height
        if self.tokens[index] ~= nil then
          local _list_0 = self.tokens[index]
          for _index_0 = 1, #_list_0 do
            local token = _list_0[_index_0]
            local _exp_0 = token.code
            if "color" == _exp_0 then
              lg.setColor(token.args)
            elseif "wave" == _exp_0 then
              yoffset = yoffset + (6 * math.sin((self.framecount + token.index * 3) / 10))
            end
          end
        end
        if self.chars[index] == "\n" then
          height = height + (dialogfont:getHeight() + Y_SPACING)
          width = 0
        else
          lg.print(self.chars[index], 3 + xoffset, 3 + yoffset + self.scrollOffset, 0)
          width = width + (dialogfont:getWidth(self.chars[index]) + X_SPACING)
        end
      end
      Push:setCanvas("main")
      if self.waitingForInput and not self.waitingForModal and (self.framecount - self.cursorBlinkFrameOffset) % CURSOR_BLINK_MOD > CURSOR_BLINK_MOD / 2 then
        sprites.gui.cursor:draw(216, 142)
      end
      if self.modal and self.waitingForModal then
        return self.modal:draw()
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, text, modaloptions)
      self.text, self.modaloptions = text, modaloptions
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
