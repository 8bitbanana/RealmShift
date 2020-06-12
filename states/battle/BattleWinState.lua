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
        local _fn_0 = _base_1.startDropCounter
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)(), 'player_reveal')
    end,
    increasePlayerCount = function(self)
      self.pcount = self.pcount + 1
      return sounds.ui_wah_1:play()
    end,
    startDropCounter = function(self)
      return self.timer:every(0.5, (function()
        local _base_1 = self
        local _fn_0 = _base_1.increaseDropCount
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)(), #self.drops, (function()
        local _base_1 = self
        local _fn_0 = _base_1.startGoldCounter
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)(), 'drops_reveal')
    end,
    increaseDropCount = function(self)
      self.dcount = self.dcount + 1
      sounds.item_pocket:setPitch(random(0.75, 1.25))
      sounds.item_pocket:stop()
      return sounds.item_pocket:play()
    end,
    startGoldCounter = function(self)
      return self.timer:after(0.5, function()
        return self.timer:during(self.gcount_len, (function()
          local _base_1 = self
          local _fn_0 = _base_1.increaseGoldCount
          return function(...)
            return _fn_0(_base_1, ...)
          end
        end)(), (function()
          local _base_1 = self
          local _fn_0 = _base_1.endBattleSummary
          return function(...)
            return _fn_0(_base_1, ...)
          end
        end)(), 'gold_reveal')
      end)
    end,
    increaseGoldCount = function(self)
      self.show_gold = true
      self.last_gcount = self.gcount
      self.gcount = self.gcount + ((self.gold / self.gcount_len) * dt)
      if floor(self.gcount) > floor(self.last_gcount) then
        sounds.coin:stop()
        if abs(self.gold - round(self.gcount)) < 1 then
          sounds.coin_final:stop()
          return sounds.coin_final:play()
        else
          return sounds.coin:play()
        end
      end
    end,
    skipAnimation = function(self)
      self.timer:cancel('player_reveal')
      self.timer:cancel('drops_reveal')
      self.timer:cancel('gold_reveal')
      return self:endBattleSummary()
    end,
    checkSkip = function(self)
      if self.can_skip and (input:pressed("confirm") or input:pressed("back")) then
        return self:skipAnimation()
      end
    end,
    endBattleSummary = function(self)
      print("endBattleSummary")
      self.pcount = 4
      self.dcount = #self.drops
      self.gcount = self.gold
      self.show_gold = true
      self.can_return = true
    end,
    checkReturn = function(self)
      if self.can_return and input:pressed("confirm") then
        game.inventory:addGold(self.gold)
        if self.drops then
          game.inventory:addItems(self.drops)
        end
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
      self:checkReturn()
      self:checkSkip()
      self.timer:update(dt)
      self.blink_timer = (self.blink_timer + dt) % self.blink_len
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
        local y = 104 - ((i % 2) * 40)
        self:drawPortraitBorder(x, y)
        if p then
          p.sprite:draw(x, y)
          self:drawHealthBar(p, x, y - 6)
        end
      end
    end,
    drawDrops = function(self)
      local x = 32
      for i = 1, self.dcount do
        local y = GAME_HEIGHT - 64 + (i * 16)
        local item = self.drops[i]
        if item then
          if item.sprite then
            item.sprite:draw(x, y)
          end
          shadowPrint(item.name, x + 10, y - 4)
        end
      end
    end,
    drawGoldCount = function(self)
      local x = 96
      local y = GAME_HEIGHT - self.padding - 4
      if self.show_gold then
        if self.gcount > 0 then
          shadowPrint("+" .. tostring(self.gold), x + 24, y - 12)
        end
        shadowPrint("Gold:", x, y, GOLD)
        local current_gold = game.inventory.gold
        return shadowPrint(current_gold + floor(self.gcount), x + 32, y, GOLD)
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
      if self.drops then
        self:drawDrops()
      end
      self:drawGoldCount()
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
      self.drops = args.drops or nil
      self.dcount = 0
      self.gold = args.gold or 0
      self.show_gold = false
      self.gcount = 0
      self.last_gcount = 0
      self.gcount_len = 1
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
