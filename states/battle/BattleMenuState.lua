require("states/state")
local Inspect = require("lib/inspect")
local WRAP_ITEM_CURSOR = false
local MenuItem
do
  local _class_0
  local _base_0 = {
    clicked = function(self) end,
    valid = function(self)
      return true
    end,
    draw = function(self)
      if self.parent:selectedItem() == self then
        sprites.battle.cursor:draw(self.pos.x - 15, self.pos.y - 4)
      end
      if self:valid() then
        lg.setColor(BLACK)
      else
        lg.setColor(GRAY)
      end
      return lg.print(self.text, self.pos.x, self.pos.y)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, parent, text, pos)
      self.parent, self.text, self.pos = parent, text, pos
    end,
    __base = _base_0,
    __name = "MenuItem"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  MenuItem = _class_0
end
do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    drawMenu = function(self)
      for index, item in pairs(self.items) do
        item:draw()
      end
    end,
    selectedItem = function(self)
      return self.items[self.selectedIndex]
    end,
    update = function(self)
      if input:pressed("up") then
        self:moveItemCursor(-1)
      end
      if input:pressed("down") then
        self:moveItemCursor(1)
      end
      if input:pressed("left") then
        self:moveItemCursor(-2)
      end
      if input:pressed("right") then
        self:moveItemCursor(2)
      end
      if input:pressed("confirm") then
        return self:selectedItem():clicked()
      end
    end,
    moveItemCursor = function(self, dir)
      local newindex = self.selectedIndex + dir
      if newindex < 1 then
        return 
      end
      if newindex > 4 then
        return 
      end
      if self.selectedIndex == 2 and dir == 1 then
        return 
      end
      if self.selectedIndex == 3 and dir == -1 then
        return 
      end
      self.selectedIndex = newindex
    end,
    draw = function(self)
      lg.setColor(1, 1, 1, 1)
      lg.rectangle("fill", 116, 4, 116, 50)
      lg.setColor(0, 0, 0, 1)
      lg.rectangle("line", 116, 4, 116, 50)
      lg.setColor(1, 1, 1, 1)
      local selectedX = self.parent:selectedPlayer().pos.x
      lg.polygon("fill", selectedX + 2, 53, selectedX + 12, 91, selectedX + 22, 53)
      lg.setColor(0, 0, 0, 1)
      lg.line(selectedX + 2, 53, selectedX + 12, 91, selectedX + 22, 53)
      return self:drawMenu()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent)
      self.parent = parent
      self.items = {
        MenuItem(self, "ATTACK", {
          x = 130,
          y = 11
        }),
        MenuItem(self, "MOVE", {
          x = 130,
          y = 30
        }),
        MenuItem(self, "SKILL", {
          x = 195,
          y = 11
        }),
        MenuItem(self, "ITEM", {
          x = 195,
          y = 30
        })
      }
      self.items[1].clicked = function(self)
        return self.parent.parent:attackAction()
      end
      self.selectedIndex = 1
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
