do
  local _class_0
  local _base_0 = {
    init = function(self)
      return self.state:init()
    end,
    gotoNextState = function(self)
      self.state:changeState(self.next_state.state, self.next_state.params)
      self.next_state = nil
    end,
    update = function(self)
      if self.state then
        self.state:update()
      end
      self.dialogmanager:update()
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
      if self.next_state then
        print("next_state: " .. tostring(self.next_state))
        print("state: " .. tostring(self.next_state.state.__name))
        print("params: " .. tostring(self.next_state.params))
        print("params unpacked: " .. tostring(unpack(self.next_state.params)))
        local _list_0 = self.next_state.params
        for _index_0 = 1, #_list_0 do
          local i = _list_0[_index_0]
          print(i)
        end
        print()
      end
      if self.next_state then
        return self:gotoNextState()
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
      self.state = GameExploreState(self, {
        "towns/test_town"
      })
      self.next_state = nil
      self.dialogmanager = DialogManager()
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
