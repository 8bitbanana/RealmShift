require("objects.entities.npc.NPC")
do
  local _class_0
  local _parent_0 = NPC
  local _base_0 = {
    init = function(self)
      print(self.item_list)
      self.item_list = loadfile(self.item_list)()
      print(self.item_list)
      self.state = NPCShopState(self)
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
      _class_0.__parent.__init(self, self.pos)
      self.sprite = sprites.npc.merchant
    end,
    __base = _base_0,
    __name = "NPCMerchant",
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
  NPCMerchant = _class_0
end
