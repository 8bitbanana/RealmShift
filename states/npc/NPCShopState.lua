do
  local _class_0
  local _parent_0 = State
  local _base_0 = {
    update = function(self)
      if self.parent:checkInteract("shop") then
        local room_path = game.state.current_room.room_path
        local p = game.state.player
        local rx = p.pos.x
        local ry = p.pos.y
        game.next_state = {
          state = GameShopState,
          params = {
            self.parent.item_list,
            room_path,
            rx,
            ry
          }
        }
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, parent)
      self.parent = parent
    end,
    __base = _base_0,
    __name = "NPCShopState",
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
  NPCShopState = _class_0
end
