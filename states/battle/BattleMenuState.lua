require("states/state")
do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    draw = function(self)
      lg.setColor(1, 1, 1, 1)
      lg.rectangle("fill", 116, 4, 116, 50)
      lg.setColor(0, 0, 0, 1)
      lg.rectangle("line", 116, 4, 116, 50)
      lg.setColor(1, 1, 1, 1)
      local selectedX = self.parent:selectedPlayer().pos.x
      lg.polygon("fill", selectedX + 2, 53, selectedX + 12, 91, selectedX + 22, 53)
      lg.setColor(0, 0, 0, 1)
      return lg.line(selectedX + 2, 53, selectedX + 12, 91, selectedX + 22, 53)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent)
      self.parent = parent
      local a = 1
    end,
    __base = _base_0,
    __name = "BattleMenuState",
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
  BattleMenuState = _class_0
end
