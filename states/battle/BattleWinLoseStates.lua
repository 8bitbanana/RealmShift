do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    startAnimation = function(self)
      self.can_skip = true
      return self.timer:every(0.5, (function()
        local _base_1 = self
        local _fn_0 = _base_1.increasePlayerCount
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)(), 4, (function()
        local _base_1 = self
        local _fn_0 = _base_1.endBattleSummary
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)(), 'player_reveal')
    end,
    increasePlayerCount = function(self)
      self.pcount = self.pcount + 1
    end,
    skipAnimation = function(self)
      self.timer:cancel('player_reveal')
      self.pcount = 4
      return self:endBattleSummary()
    end,
    checkSkip = function(self)
      if self.can_skip and (input:pressed("confirm") or input:pressed("back")) then
        return self:skipAnimation()
      end
    end,
    endBattleSummary = function(self)
      self.can_return = true
    end,
    checkReturn = function(self)
      if self.can_return and input:pressed("confirm") then
        game.next_state = {
          state = GameOverworldState,
          params = {
            self.rx,
            self.ry
          }
        }
      end
    end,
    update = function(self)
      self.timer:update(dt)
      self.blink_timer = (self.blink_timer + dt) % self.blink_len
      self:checkReturn()
      return self:checkSkip()
    end,
    drawScreenBackground = function(self)
      local dx = (GAME_WIDTH - self.width) / 2
      local dy = (GAME_HEIGHT - self.height) / 2
      lg.setColor({
        0,
        0,
        0,
        self.opacity
      })
      lg.rectangle("fill", dx, dy, self.width, self.height)
      return lg.setColor(WHITE)
    end,
    drawHealthBar = function(self, player, x, y)
      local hp = player.hp
      local max_hp = player.basestats.hp
      local max_len = 40
      local len = (hp / max_hp) * max_len
      lg.setColor(BLACK)
      lg.rectangle("fill", x + 25, y - 15, max_len, 2)
      lg.setColor(RED)
      lg.rectangle("fill", x + 24, y - 16, len, 2)
      lg.setColor(WHITE)
      return shadowPrint(tostring(hp) .. "/" .. tostring(max_hp), x + 29, y - 26)
    end,
    drawPortraitBorder = function(self, x, y)
      local w = 72
      local h = -28
      lg.setColor({
        0.3,
        0.3,
        0.3,
        self.opacity
      })
      return lg.rectangle("line", x, y - 4, w, h)
    end,
    drawPlayerPortraits = function(self)
      local players = self.parent.players
      for i = 1, self.pcount do
        local p = players[i]
        local x = 32 + (floor((i - 1) / 2) * 104)
        local y = 112 - ((i % 2) * 40)
        self:drawPortraitBorder(x, y)
        if p then
          p.sprite:draw(x, y)
          self:drawHealthBar(p, x, y - 6)
        end
      end
    end,
    drawButtonPrompt = function(self)
      if self.blink_timer <= self.blink_len / 2 then
        local x = 176
        local y = GAME_HEIGHT - self.padding
        if self.can_skip and not self.can_return then
          x = 176
          shadowPrint("Skip", x + 20, y)
        elseif self.can_skip and self.can_return then
          x = 160
          shadowPrint("Confirm", x + 20, y)
        end
        if self.can_skip then
          return sprites.gui.cursor:draw(x, y)
        end
      end
    end,
    draw = function(self)
      self:drawScreenBackground()
      self:drawPlayerPortraits()
      return self:drawButtonPrompt()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent, args)
      self.parent = parent
      self.timer = Timer()
      self.blink_timer = 0
      self.blink_len = 1
      self.rx = args.rx
      self.ry = args.ry
      self.padding = 32
      self.width = GAME_WIDTH - self.padding
      self.height = GAME_HEIGHT - self.padding
      self.opacity = 0
      self.pcount = 0
      self.gcount = 0
      self.can_skip = false
      self.can_return = false
      return self.timer:tween(0.5, self, {
        opacity = 0.85
      }, 'out-cubic', (function()
        local _base_1 = self
        local _fn_0 = _base_1.startAnimation
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)())
    end,
    __base = _base_0,
    __name = "BattleWinState",
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
  BattleWinState = _class_0
end
