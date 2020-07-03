do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    init = function(self) end,
    moveCursor = function(self)
      if input:pressed("up") then
        if self.cursor == 1 then
          self.cursor = #self.item_list
        else
          self.cursor = self.cursor - 1
        end
      elseif input:pressed("down") then
        if self.cursor == #self.item_list then
          self.cursor = 1
        else
          self.cursor = self.cursor + 1
        end
      end
    end,
    checkBuy = function(self)
      if input:pressed("confirm") then
        local item = self.item_list[self.cursor]
        local gold = game.inventory.gold
        if gold >= item.price then
          return true
        else
          sounds.negative:stop()
          sounds.negative:play()
          return false
        end
      end
    end,
    purchaseItem = function(self)
      local item = self.item_list[self.cursor]
      game.inventory.gold = game.inventory.gold - item.price
      game.inventory:addItem(item())
      sounds.coin_final:stop()
      sounds.item_pocket:stop()
      sounds.coin_final:play()
      return sounds.item_pocket:play()
    end,
    checkLeave = function(self)
      if input:pressed("back") then
        return true
      end
    end,
    leaveShop = function(self)
      game.next_state = {
        state = GameExploreState,
        params = {
          self.rpath,
          self.rx,
          self.ry
        }
      }
    end,
    update = function(self)
      self.timer = self.timer + dt
      self:moveCursor()
      if self:checkBuy() then
        return self:purchaseItem()
      elseif self:checkLeave() then
        return self:leaveShop()
      end
    end,
    printShop = function(self)
      lg.setFont(big_font)
      shadowPrint("Shop", 32, 16)
      return lg.setFont(default_font)
    end,
    printGold = function(self)
      return shadowPrint("gold: " .. tostring(game.inventory.gold), 160, 16, GOLD)
    end,
    drawCursor = function(self)
      local x = 16 - (self.timer % 0.35) * 8
      local y = 40 + ((self.cursor - 1) * 12) + 2
      lg.setColor(WHITE)
      return sprites.gui.finger_cursor:draw(x, y)
    end,
    drawShopItems = function(self)
      local x = 32
      local y = 40
      local _list_0 = self.item_list
      for _index_0 = 1, #_list_0 do
        local item = _list_0[_index_0]
        if item.sprite then
          item.sprite:draw(x, y + 2)
        end
        shadowPrint(item.name, x + 24, y)
        shadowPrint(tostring(item.price) .. "G", x + 160, y, GOLD)
        y = y + 12
      end
      return lg.setColor(WHITE)
    end,
    drawItemDescription = function(self)
      local item = self.item_list[self.cursor]
      local font = lg.getFont()
      local _, text = font:getWrap(item.desc, GAME_WIDTH - 48)
      local y = 108
      for _index_0 = 1, #text do
        local line = text[_index_0]
        shadowPrint(line, 24, y)
        y = y + 10
      end
    end,
    drawTooltips = function(self)
      shadowPrint("z - purchase", 32, GAME_HEIGHT - 18)
      return shadowPrint("x - leave", 128, GAME_HEIGHT - 18)
    end,
    draw = function(self)
      lg.clear({
        0,
        0.45,
        0.7
      })
      self:printShop()
      self:printGold()
      self:drawShopItems()
      self:drawItemDescription()
      self:drawCursor()
      return self:drawTooltips()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent, item_list, rpath, rx, ry)
      if item_list == nil then
        item_list = { }
      end
      if rx == nil then
        rx = 0
      end
      if ry == nil then
        ry = 0
      end
      self.parent, self.item_list, self.rpath, self.rx, self.ry = parent, item_list, rpath, rx, ry
      self.timer = 0
      self.cursor = 1
    end,
    __base = _base_0,
    __name = "GameShopState",
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
  GameShopState = _class_0
end
