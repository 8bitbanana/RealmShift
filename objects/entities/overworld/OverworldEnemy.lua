do
  local _class_0
  local _base_0 = {
    makeTouchable = function(self)
      self.touchable = true
    end,
    blinkSprite = function(self)
      self.blink = not self.blink
    end,
    startChase = function(self)
      return self.timer:after(self.wait, (function()
        local _base_1 = self
        local _fn_0 = _base_1.chasePlayer
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)())
    end,
    addVariation = function(self, n, p)
      if p == nil then
        p = 0.10
      end
      if math.random() <= p then
        return (n * -1)
      end
      return n
    end,
    chasePlayer = function(self)
      local p = game.state.player
      local dx = p.pos.x - self.pos.x
      local dy = p.pos.y - self.pos.y
      if dx ~= 0 then
        dx = dx / abs(dx)
      end
      if dy ~= 0 then
        dy = dy / abs(dy)
      end
      dx = self:addVariation(dx)
      dy = self:addVariation(dy)
      print(dx, dy)
      local tx = self.pos.x + (dx * 8)
      local ty = self.pos.y + (dy * 8)
      return self.timer:tween(self.spd, self.pos, {
        x = tx,
        y = ty
      }, 'out-elastic', (function()
        local _base_1 = self
        local _fn_0 = _base_1.startChase
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)())
    end,
    checkCollidePlayer = function(self)
      local p = game.state.player
      if AABB(self, p) then
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
    destroy = function(self)
      print("OverworldEnemy destroy called")
      self.timer:destroy()
      self.destroyed = true
    end,
    update = function(self)
      self.timer:update(dt)
      if self.touchable then
        return self:checkCollidePlayer()
      end
    end,
    draw = function(self)
      if not self.blink then
        return sprites.overworld.enemy:draw(self.pos.x, self.pos.y)
      end
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
      self.spd = 0.8
      self.wait = 1.0
      self.timer = Timer()
      self:startChase()
      self.touchable = false
      self.timer:after(self.wait, (function()
        local _base_1 = self
        local _fn_0 = _base_1.makeTouchable
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)())
      self.blink = false
      return self.timer:every(self.wait / 12, (function()
        local _base_1 = self
        local _fn_0 = _base_1.blinkSprite
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)(), 12)
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
