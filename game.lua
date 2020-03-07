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
      if self.transitioning then
        local _ = nil
      else
        if self.state then
          self.state:update()
          self.dialogmanager:update()
        end
      end
      if input:pressed("dialogdebug") then
        if self.dialogmanager.running then
          self.dialogmanager:advanceInput()
        else
          self.dialogmanager:push(DialogBox("This is a test of the {color,1,0,0,1,6}{wave,6}dialog box{pause,30}\nIt seems to work fairly well so far,\nalthough I did have to edit {colour,0,0,1,1,8}Push.lua.\n3\n4 test input{input}wow\n5\n6\n{wave,4}Wow!"))
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
        if self.dialogmanager.running then
          return self.dialogmanager:draw()
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
      self.dialogmanager = DialogManager()
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
