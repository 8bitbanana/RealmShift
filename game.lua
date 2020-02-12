do
  local _class_0
  local _base_0 = {
    init = function(self)
      return self.state:init()
    end,
    gotoNextState = function(self)
      self.state:changeState(self.next_state)
      self.next_state = nil
    end,
    update = function(self)
      if self.state then
        self.state:update()
      end
      self.dialogmanager:update()
      if input:pressed("dialogdebug") then
        if self.dialogbox.done then
          self.dialogbox:reset()
        else
          self.dialogbox:begin()
        end
      end
      if self.next_state then
        self:gotoNextState()
        return print(self.state.__name)
      end
    end,
    draw = function(self)
      if self.state then
        self.state:draw()
      end
      if self.dialogmanager.running then
        return self.dialogmanager:draw()
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.state = GameExploreState(self)
      self.dialogmanager = DialogManager()
      self.next_state = nil
      self.dialogbox = DialogBox("This is a test of the dialog box{pause,30}\nIt seems to work fairly well so far,\nalthough I did have to edit {colour,0,0,1,1,8}Push.lua.{pause,30}\n3{pause,30}\n4{pause,30}\n5{pause,30}\n6{pause,50}\n{wave,4}Wow!")
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
