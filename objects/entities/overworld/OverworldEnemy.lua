do
  local _class_0
  local _base_0 = {
    checkCollidePlayer = function(self)
      local p = game.state.player
      local rect1 = {
        x = p.pos.x,
        y = p.pos.y,
        width = p.width,
        height = p.height
      }
      local rect2 = {
        x = self.pos.x,
        y = self.pos.y,
        width = 8,
        height = 8
      }
      if AABB(rect1, rect2) then
        print("Transition to Battle state!")
        game.next_state = {
          state = GameBattleState,
          params = {
            p.pos.x,
            p.pos.y
          }
        }
      end
    end,
    update = function(self)
      self.timer:update(dt)
      return self:checkCollidePlayer()
    end,
    draw = function(self)
      return sprites.overworld.enemy:draw(self.pos.x, self.pos.y)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, pos)
      if pos == nil then
        pos = {
          x = 0,
          y = 0
        }
      end
      self.pos = pos
      self.dir = math.random(4)
      self.spd = 0.5
      self.timer = Timer()
    end,
    __base = _base_0,
    __name = "OverworldEnemy"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  OverworldEnemy = _class_0
end
