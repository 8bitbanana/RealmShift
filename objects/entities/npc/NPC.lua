require("objects/entities/player/Player")
require("objects/game objects/dialog/Dialog")
local Inspect = require("lib/inspect")
do
  local _class_0
  local _parent_0 = Player
  local _base_0 = {
    init = function(self)
      if self.name then
        self.dialog = self:loadDialog()
      end
    end,
    loadDialog = function(self)
      if (self.name ~= nil) and (self.name ~= "") then
        local file_path = "dialog/" .. tostring(self.name) .. ".lua"
        local file, error = loadfile(file_path)
        if error then
          print(error)
        else
          local d = file()
          return d
        end
      end
      return nil
    end,
    getTalkZone = function(self)
      return {
        pos = {
          x = self.pos.x - self.talk_range,
          y = self.pos.y - self.talk_range
        },
        width = self.width + (self.talk_range * 2),
        height = self.height + (self.talk_range * 2)
      }
    end,
    checkTalk = function(self)
      local talk_zone = self:getTalkZone()
      local p = game.state.player
      if p then
        if AABB(talk_zone, p) then
          game.button_prompts = {
            z = "Talk",
            x = ""
          }
          local gd = game.dialog
          if not gd.running then
            if input:pressed("talk") then
              print("setting dialog tree")
              gd:setTree(self.dialog)
              return self.state:changeState(NPCTalkState)
            end
          else
            if input:pressed("talk") then
              print(("advancing text"))
              gd:advanceInput()
              if gd.tree and gd.tree.done then
                print("dialog done")
                return self.state:changeState(NPCWanderState)
              end
            end
          end
        end
      end
    end,
    drawTalkZone = function(self)
      local c = self:getTalkZone()
      lg.setColor(ORANGE)
      lg.rectangle("line", c.pos.x, c.pos.y, c.width, c.height)
      return lg.setColor(WHITE)
    end,
    draw = function(self)
      self:drawTalkZone()
      return _class_0.__parent.draw(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, pos)
      if pos == nil then
        pos = {
          x = 0,
          y = 0
        }
      end
      self.pos = pos
      self.width = 16
      self.height = 16
      self.name = ""
      self.talk_range = 8
      self.vel = {
        x = 0,
        y = 0
      }
      self.sprite = sprites.player.idle
      self.state = NPCWanderState(self)
    end,
    __base = _base_0,
    __name = "NPC",
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
  NPC = _class_0
end
