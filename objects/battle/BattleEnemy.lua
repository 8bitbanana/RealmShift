require("objects/battle/BattlePlayer")
do
  local _class_0
  local _parent_0 = BattlePlayer
  local _base_0 = {
    draw = function(self)
      lg.setColor(RED)
      _class_0.__parent.__base.draw(self, false)
      return lg.print("EN", self.pos.x, self.pos.y)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      _class_0.__parent.__init(self)
      self.stats.hp = 20
      self.stats.attack = 1
      self.stats.defence = 1
      self.stats.speed = 1
      return self:init()
    end,
    __base = _base_0,
    __name = "BattleEnemy",
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
  BattleEnemy = _class_0
end