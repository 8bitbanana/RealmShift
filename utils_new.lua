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
deepcopy = function(orig)
  local orig_type = type(orig)
  local copy = { }
  if orig_type == 'table' then
    copy = { }
    for orig_key, orig_value in next,orig,nil do
      copy[deepcopy(orig_key)] = deepcopy(orig_value)
    end
    setmetatable(copy, deepcopy(getmetatable(orig)))
  else
    copy = orig
  end
  return copy
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
table.contains = function(t, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
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
AABB = function(b1, b2)
  return b1.pos.x < (b2.pos.x + b2.width) and (b1.pos.x + b1.width) > b2.pos.x and b1.pos.y < (b2.pos.y + b2.height) and (b1.pos.y + b1.height) > b2.pos.y
end
shadowPrint = function(text, x, y, col)
  if text == nil then
    text = "empty_text"
  end
  if x == nil then
    x = 0
  end
  if y == nil then
    y = 0
  end
  if col == nil then
    col = WHITE
  end
  lg.setColor(WHITE)
  lg.print({
    BLACK,
    text
  }, x + 1, y + 1)
  return lg.print({
    col,
    text
  }, x, y)
end
replaceSlashes = function(path)
  return path:gsub("/", ".")
end
recursiveEnumerate = function(path, file_list)
  local files = lf.getDirectoryItems(path)
  for _index_0 = 1, #files do
    local f = files[_index_0]
    local file_path = path .. "/" .. f
    local typ = lf.getInfo(file_path).type
    if typ == "file" then
      local require_path = replaceSlashes(file_path)
      table.insert(file_list, require_path)
    elseif typ == "directory" then
      recursiveEnumerate(file_path, file_list)
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
printTable = function(tbl)
  for k, v in pairs(tbl) do
    print(k, v)
  end
end
