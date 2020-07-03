do
  local _class_0
  local _base_0 = {
    init = function(self) end,
    update = function(self) end,
    draw = function(self)
      local font = lg.getFont()
      local _, text = font:getWrap(self.text, self.width)
      local y = self.pos.y
      for _index_0 = 1, #text do
        local line = text[_index_0]
        shadowPrint(line, self.pos.x, y)
        y = y + 10
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, pos, width, height, text)
      if pos == nil then
        pos = {
          x = 0,
          y = 0
        }
      end
      if width == nil then
        width = 128
      end
      if height == nil then
        height = 32
      end
      if text == nil then
        text = "test_text"
      end
      self.pos, self.width, self.height, self.text = pos, width, height, text
    end,
    __base = _base_0,
    __name = "Message"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Message = _class_0
end
