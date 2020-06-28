do
  local _class_0
  local _base_0 = {
    init = function(self)
      return self:loadObjects()
    end,
    getObjectLayers = function(self)
      local object_layers = { }
      local layers = self.map.layers
      for _index_0 = 1, #layers do
        local layer = layers[_index_0]
        if layer.type == "objectgroup" then
          table.insert(object_layers, layer)
        end
      end
      return object_layers
    end,
    createMapObject = function(self, obj_data)
      local pos = {
        x = obj_data.x,
        y = obj_data.y
      }
      local width = obj_data.width
      local height = obj_data.height
      local obj_class = _G[obj_data.type]
      print(obj_class)
      if obj_class then
        local obj = obj_class(pos, width, height)
        for k, v in pairs(obj_data.properties) do
          obj[k] = v
        end
        if obj.init then
          obj:init()
        end
        if obj.solid then
          self.world:add(obj, obj.pos.x, obj.pos.y, obj.width, obj.height)
        end
        return obj
      end
    end,
    loadObjects = function(self)
      local object_layers = self:getObjectLayers()
      for _index_0 = 1, #object_layers do
        local layer = object_layers[_index_0]
        local _list_0 = layer.objects
        for _index_1 = 1, #_list_0 do
          local obj_data = _list_0[_index_1]
          local obj = self:createMapObject(obj_data)
          if obj then
            game.state.objects:addObject(obj)
          end
        end
      end
    end,
    update = function(self)
      return self.map:update(dt)
    end,
    draw = function(self, pos)
      if pos == nil then
        pos = {
          x = 0,
          y = 0
        }
      end
      local _list_0 = self.map.layers
      for _index_0 = 1, #_list_0 do
        local layer = _list_0[_index_0]
        if layer.type == "tilelayer" then
          layer.x = -pos.x
          layer.y = -pos.y
          self.map:drawTileLayer(layer)
        end
      end
      if SHOW_COLLIDERS then
        lg.setColor(RED)
        local items = self.world:getItems()
        for _index_0 = 1, #items do
          local i = items[_index_0]
          local x, y, w, h = self.world:getRect(i)
          local c = game.state.camera
          lg.rectangle("line", x - c.pos.x, y - c.pos.y, w, h)
        end
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, room_path)
      self.room_path = room_path
      self.world = Bump.newWorld()
      self.map = STI("rooms/" .. tostring(self.room_path) .. ".lua", {
        "bump"
      })
      return self.map:bump_init(self.world)
    end,
    __base = _base_0,
    __name = "Room"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Room = _class_0
end
