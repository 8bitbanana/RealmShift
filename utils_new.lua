string.split = function(s, delim)
  local _accum_0 = { }
  local _len_0 = 1
  for w in s:gmatch("([^" .. delim .. "]+)") do
    _accum_0[_len_0] = w
    _len_0 = _len_0 + 1
  end
  return _accum_0
end
string.totable = function(s)
  local t = { }
  s:gsub(".", function(c)
    return table.insert(t, c)
  end)
  return t
end
table.stripKeys = function(t)
  local _accum_0 = { }
  local _len_0 = 1
  for k, v in pairs(t) do
    _accum_0[_len_0] = v
    _len_0 = _len_0 + 1
  end
  return _accum_0
end
table.shallow_copy = function(t)
  local _tbl_0 = { }
  for k, v in pairs(t) do
    _tbl_0[k] = v
  end
  return _tbl_0
end
math.sign = function(x)
  if x < 0 then
    return -1
  elseif x > 0 then
    return 1
  else
    return 0
  end
end
setupRandom = function()
  math.randomseed(os.time())
  return math.random()(math.random()(math.random()))
end
dirPressed = function()
  return input:down("left") or input:down("right") or input:down("up") or input:down("down")
end
lerp = function(s, e, f)
  local p = 1 - (f ^ dt)
  return (s + p * (e - s))
end
random = function(min, max)
  if min == nil then
    min = 0
  end
  if max == nil then
    max = 1
  end
  return (min > max and (love.math.random() * (min - max) + max)) or (love.math.random() * (max - min) + min)
end
round = function(n)
  return math.floor(n + 0.5)
end
clamp = function(low, n, high)
  return math.min(math.max(low, n), high)
end
getAngle = function(x1, y1, x2, y2)
  return math.atan2(y2 - y1, x2 - x1)
end
limitPosToCurrentRoom = function(obj)
  local map = game.state.current_room.map
  local tile_size = map.tilewidth
  local maxw = (map.width * tile_size) - obj.width
  local maxh = (map.height * tile_size) - obj.height
  obj.pos.x = clamp(0, obj.pos.x, maxw)
  obj.pos.y = clamp(0, obj.pos.y, maxh)
end
onScreen = function(x, y, border)
  if border == nil then
    border = 0
  end
  local cam = game.state.camera
  local cx, cy = cam.pos.x, cam.pos.y
  return x > cx - border and x < cx + GAME_WIDTH + border and y > cy - border and y < cy + GAME_HEIGHT + border
end
pointBoxCollision = function(point, box)
  return point.x > box.x and point.x < box.x + box.width and point.y > box.y and point.y < box.y + box.height
end
shadowPrint = function(text, x, y)
  if text == nil then
    text = "empty_text"
  end
  if x == nil then
    x = 0
  end
  if y == nil then
    y = 0
  end
  lg.setColor(WHITE)
  lg.print({
    BLACK,
    text
  }, x + 1, y + 1)
  return lg.print(text, x, y)
end
recursiveEnumerate = function(folder, file_list)
  local items = love.filesystem.getDirectoryItems(folder)
  for _, item in ipairs(items) do
    local file = folder .. '/' .. item
    if love.filesystem.getInfo(file).type == "file" then
      table.insert(file_list, file)
    elseif love.filesystem.getInfo(file).type == "directory" then
      recursiveEnumerate(file, file_list)
    end
  end
end
requireFiles = function(files)
  for _, file in ipairs(files) do
    if file:sub(-3, #file) == "lua" then
      file = file:sub(1, -5)
      require(file)
    end
  end
end
requireFolder = function(path)
  local files = { }
  recursiveEnumerate(path, files)
  return requireFiles(files)
end
UUID = function()
  local fn
  fn = function(x)
    local r = love.math.random(16) - 1
    r = (x == "x") and (r + 1) or (r % 4) + 9
    return ("0123456789abcdef"):sub(r, r)
  end
  return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", fn))
end
getTableLength = function(t)
  local length = 0
  for k, v in pairs(t) do
    length = length + 1
  end
  return length
end
