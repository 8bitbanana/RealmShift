do
  local _class_0
  local _base_0 = {
    addObject = function(self, obj)
      if obj then
        return table.insert(self.objects, obj)
      end
    end,
    updateObjects = function(self)
      for i = 1, #self.objects do
        local o = self.objects[i]
        if o.update then
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
