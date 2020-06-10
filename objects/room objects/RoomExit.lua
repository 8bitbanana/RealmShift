do
  local _class_0
  local _base_0 = {
    gotoOverworld = function(self)
      game.next_state = {
        state = GameOverworldState,
        params = {
          self.tx,
          self.ty
        }
      }
    end,
    gotoRoom = function(self)
      game.next_state = {
        state = GameExploreState,
        params = {
          self.dest_room,
          self.tx,
          self.ty
        }
      }
    end,
    changeRoom = function(self)
      if self.dest_room == "overworld" then
        return self:gotoOverworld()
      else
        return self:gotoRoom()
      end
    end,
    checkPlayerEntered = function(self)
      local p = game.state.player
      if p then
        if AABB(self, p) then
          if self.is_door then
            game.button_prompts.z = "Enter"
            if input:pressed("open_door") then
              return self:changeRoom()
            end
          else
            return self:changeRoom()
          end
        end
      end
    end,
    update = function(self)
      self:checkPlayerEntered()
      self.icon_timer = self.icon_timer + dt
      self.icon_timer = self.icon_timer % 0.3
    end,
    drawDebug = function(self)
      lg.setColor(ORANGE)
      lg.rectangle("line", self.pos.x, self.pos.y, self.width, self.height)
      lg.print({
        BLACK,
        "Dest: " .. tostring(self.dest_room)
      }, self.pos.x + 1, self.pos.y - 15)
      lg.setColor(WHITE)
      return lg.print("Dest: " .. tostring(self.dest_room), self.pos.x, self.pos.y - 16)
    end,
    drawIcon = function(self)
      lg.setColor(BLACK)
      if self.is_door then
        sprites.gui.cursor_small:draw(self.pos.x - 4, self.pos.y - (14) + (self.icon_timer * 8))
      else
        sprites.gui.cursor:draw(self.pos.x - 4, self.pos.y - (self.height / 2) + (self.icon_timer * 16))
      end
      return lg.setColor(WHITE)
    end,
    draw = function(self)
      return self:drawIcon()
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, pos, width, height, dest_room, is_door, tx, ty)
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
      if dest_room == nil then
        dest_room = "test_town"
      end
      if is_door == nil then
        is_door = false
      end
      if tx == nil then
        tx = 0
      end
      if ty == nil then
        ty = 0
      end
      self.pos, self.width, self.height, self.dest_room, self.is_door, self.tx, self.ty = pos, width, height, dest_room, is_door, tx, ty
      self.icon_timer = 0
    end,
    __base = _base_0,
    __name = "RoomExit"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  RoomExit = _class_0
end
