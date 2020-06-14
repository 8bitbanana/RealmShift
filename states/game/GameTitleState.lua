require("states/state")
do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    init = function(self) end,
    activate = function(self)
      self.active = true
      self.timer:tween(2, self, {
        title_wobble_factor = 1
      }, 'in-out-cubic')
      return self.timer:tween(2, self, {
        banner_opacity = 1
      }, 'in-out-cubic')
    end,
    checkPlay = function(self)
      if self.active then
        if input:pressed('confirm') then
          game.next_state = {
            state = GameExploreState,
            params = { }
          }
        end
      end
    end,
    update = function(self)
      self.timer:update(dt)
      self.count = self.count + dt
      return self:checkPlay()
    end,
    drawBackground = function(self)
      lg.setColor({
        1,
        1,
        1,
        self.banner_opacity
      })
      return self.room:draw()
    end,
    drawBanner = function(self)
      local x = 0
      local y = 0
      for i = 0, 107 do
        x = (2 * i)
        y = 40 + self.title_wobble_factor * (sin(1.5 + self.count * 2 - (i / 12)) * 3)
        local spr = sprites.gui.banner_strip
        spr.color = {
          1,
          1,
          1,
          self.banner_opacity
        }
        spr:draw(x, y)
      end
      for i = 1, 11 do
        y = 40 + self.title_wobble_factor * (sin(1.5 + self.count * 2 - ((i + 108) / 12)) * 3)
        local spr = sprites.gui.banner_strip_end[i]
        spr.color = {
          1,
          1,
          1,
          self.banner_opacity
        }
        spr:draw(x + (2 * i), y)
      end
    end,
    drawTitle = function(self)
      lg.setFont(title_font)
      local gap = 0
      for i = 1, #self.title do
        local letter = self.title:sub(i, i)
        local x = 40 + gap
        local y_wobble = self.title_wobble_factor * (sin(self.count * 2 - (i / 3)) * 3)
        local y = self.title_y + y_wobble
        shadowPrint(letter, x, y, {
          1,
          1,
          1,
          self.title_opacity
        })
        gap = gap + title_font:getWidth(letter)
      end
      return lg.setFont(default_font)
    end,
    drawPlayButton = function(self)
      if self.active then
        if (self.count % 2) < 1 then
          return shadowPrint("Z - Play", 96, GAME_HEIGHT - 32)
        end
      end
    end,
    draw = function(self)
      lg.clear(BLACK)
      self:drawBackground()
      self:drawBanner()
      self:drawTitle()
      return self:drawPlayButton()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent)
      self.parent = parent
      self.title = "Heroes of Highever"
      self.timer = Timer()
      self.room = Room("overworld/overworld_new")
      self.count = 0
      self.banner_opacity = 0
      self.title_y = GAME_HEIGHT + 8
      self.title_opacity = -0.5
      self.title_wobble_factor = 0
      self.active = false
      self.timer:tween(3, self, {
        title_opacity = 1
      }, 'out-cubic')
      return self.timer:tween(3, self, {
        title_y = 32
      }, 'out-cubic', (function()
        local _base_1 = self
        local _fn_0 = _base_1.activate
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)())
    end,
    __base = _base_0,
    __name = "GameTitleState",
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
  GameTitleState = _class_0
end
