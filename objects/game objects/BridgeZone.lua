do
  local _class_0
  local _base_0 = {
    init = function(self) end,
    checkPlayerBridge = function(self)
      self.has_bridge = false
      local world = game.state.current_room.world
      local player = game.state.player
      local _, cols, len
      _, _, cols, len = world:check(self, self.pos.x, self.pos.y)
      for _index_0 = 1, #cols do
        local c = cols[_index_0]
        local other = c.other
        if other == player then
          if game.inventory:hasItem(BridgeItem) then
            self.has_bridge = true
          end
        end
      end
    end,
    update = function(self)
      return self:checkPlayerBridge()
    end,
    drawBridge = function(self)
      return sprites.overworld.bridge:draw(216, 136)
    end,
    draw = function(self)
      if self.has_bridge then
        return self:drawBridge()
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, pos, width, height)
      if pos == nil then
        pos = {
          x = 0,
          y = 0
        }
      end
      if width == nil then
        width = 16
      end
      if height == nil then
        height = 16
      end
      self.pos, self.width, self.height = pos, width, height
      self.has_bridge = false
    end,
    __base = _base_0,
    __name = "BridgeZone"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  BridgeZone = _class_0
end
