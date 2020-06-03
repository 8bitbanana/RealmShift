do
  local _class_0
  local _base_0 = {
    init = function(self)
      return self.state:init()
    end,
    startStateTransitionIn = function(self)
      self.state:destroy()
      self.state = nil
      self.transitioning = true
      self.transition_progress = 0.0
      return self.timer:tween(self.transition_length, self, {
        transition_progress = 1.0
      }, 'in-out-cubic', (function()
        local _base_1 = self
        local _fn_0 = _base_1.startStateTransitionOut
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)(), "transition")
    end,
    startStateTransitionOut = function(self)
      self.state = self.next_state.state(self, unpack(self.next_state.params))
      self.state:init()
      self.next_state = nil
      self.transition_progress = 1.0
      return self.timer:tween(self.transition_length, self, {
        transition_progress = 0.0
      }, 'in-out-cubic', (function()
        local _base_1 = self
        local _fn_0 = _base_1.endStateTransition
        return function(...)
          return _fn_0(_base_1, ...)
        end
      end)(), "transition")
    end,
    endStateTransition = function(self)
      self.transitioning = false
    end,
    update = function(self)
      self.timer:update(dt)
      self.button_prompts = {
        z = "",
        x = ""
      }
      if self.transitioning then
        local _ = nil
      else
        if self.state then
          self.state:update()
          self.dialog:update()
        end
      end
      if input:pressed("dialogdebug") then
        if self.dialog.running then
          self.dialog:advanceInput()
        else
          self.dialog:push(DialogBox("This is a {color,4,1,0,0}{wave,4}test!\nHoly{pause,25} crap!"))
        end
      end
      if input:pressed("battledebug") then
        self.next_state = {
          state = GameBattleState,
          params = { }
        }
      end
      if self.next_state and not self.transitioning then
        return self:startStateTransitionIn()
      end
    end,
    drawButtonPrompts = function(self)
      sprites.gui.z_button:draw(GAME_WIDTH - 64, 0)
      sprites.gui.x_button:draw(GAME_WIDTH - 56, 16)
      shadowPrint(self.button_prompts.z, GAME_WIDTH - 40, 4)
      return shadowPrint(self.button_prompts.x, GAME_WIDTH - 32, 16)
    end,
    drawStateTransition = function(self)
      if self.state then
        self.state:draw()
      end
      local p = self.transition_progress
      lg.setColor({
        0,
        0,
        0,
        p
      })
      lg.rectangle("fill", 0, 0, GAME_WIDTH, GAME_HEIGHT)
      return lg.setColor(WHITE)
    end,
    draw = function(self)
      if self.transitioning then
        return self:drawStateTransition()
      else
        if self.state then
          self.state:draw()
        end
        self.dialog:draw()
        if self.state.__class.__name ~= "GameBattleState" then
          return self:drawButtonPrompts()
        end
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.timer = Timer()
      self.state = GameExploreState(self)
      self.next_state = nil
      self.button_prompts = {
        z = "",
        x = ""
      }
      self.dialog = DialogManager()
      self.transitioning = false
      self.transition_progress = 0.0
      self.transition_length = 0.25
    end,
    __base = _base_0,
    __name = "Game"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Game = _class_0
end
