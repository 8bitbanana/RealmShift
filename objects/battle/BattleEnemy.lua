require("objects/battle/BattlePlayer")
do
  local _class_0
  local _parent_0 = BattlePlayer
  local _base_0 = {
    getCursorPos = function(self)
      return {
        x = self.pos.x + 3,
        y = self.pos.y - 68
      }
    end,
    draw_alive = function(self)
      lg.setColor(RED)
      lg.rectangle("fill", self.pos.x, self.pos.y - 48, 30, 48)
      lg.setColor(BLACK)
      return lg.rectangle("line", self.pos.x, self.pos.y - 48, 30, 48)
    end,
    draw_dead = function(self)
      lg.setColor(GRAY)
      lg.rectangle("fill", self.pos.x, self.pos.y - 48, 30, 48)
      lg.setColor(BLACK)
      return lg.rectangle("line", self.pos.x, self.pos.y - 48, 30, 48)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      _class_0.__parent.__init(self, ...)
      self.basestats.hp = 100
      self.basestats.attack = 3
      self.basestats.defence = 4
      self.basestats.speed = 2
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
