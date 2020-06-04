do
  local _class_0
  local _base_0 = {
    addObject = function(self, obj)
      if obj then
        return table.insert(self.objects, obj)
      end
    end,
    countObjects = function(self, class_name)
      local count = 0
      if _G[class_name] then
        local _list_0 = self.objects
        for _index_0 = 1, #_list_0 do
          local o = _list_0[_index_0]
          if o.__class.__name == class_name then
            count = count + 1
          end
        end
      end
      return count
    end,
    updateObjects = function(self)
      for i = 1, #self.objects do
        local o = self.objects[i]
        if o.update and not o.destroyed then
          o:update()
        end
      end
    end,
    drawObjects = function(self)
      for i = 1, #self.objects do
        local o = self.objects[i]
        if o.draw then
          o:draw()
        end
      end
    end,
    destroyAll = function(self)
      for i = #self.objects, 1, -1 do
        local o = self.objects[i]
        if o.destroy then
          o:destroy()
        end
        table.remove(self.objects, i)
      end
    end,
    checkDestroyed = function(self)
      for i = #self.objects, 1, -1 do
        local o = self.objects[i]
        if o then
          if o.destroyed then
            table.remove(self.objects, i)
          end
        end
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.objects = { }
    end,
    __base = _base_0,
    __name = "ObjectManager"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  ObjectManager = _class_0
end
