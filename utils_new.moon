
-- NOTE: --
-- The utils.lua file but re-written in moonscript to make functions more readable
-- Also moved some local functions from dialog.moon into this file to make them global

export *

string.split = (s, delim) ->
    return [w for w in s\gmatch("([^"..delim.."]+)")]

string.totable = (s) ->
    t = {}
    s\gsub(".", (c)->table.insert(t, c))
    return t

-- stripKeys returns a copy of the passed table that contains only the values and no keys
-- e.g. {["name"] = "Garry", ["height"] = 12} becomes
--			{"Garry", 12}
table.stripKeys = (t) ->
	return [v for k,v in pairs(t)]

deepcopy = (orig) ->
    orig_type = type(orig)
    copy = {}
    if orig_type == 'table'
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)

        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig

    return copy

table.shallow_copy = (t) ->
    return {k, v for k, v in pairs t}

math.sign = (x) ->
    if x < 0 return -1
    elseif x > 0 return 1
	else return 0

table.contains = (t, element) ->
	for _, value in pairs table
		return true if value == element
	return false

--------------------------------

setupRandom = () ->
	math.randomseed(os.time())
	math.random() math.random() math.random()

--------------------------------

dirPressed = () ->
	return input\down("left") or input\down("right") or input\down("up") or input\down("down")

lerp = (s, e, f) ->
	p = 1-(f^dt)
	return (s + p*(e - s))

random = (min=0, max=1) ->
	return (min > max and (love.math.random()*(min - max) + max)) or (love.math.random()*(max - min) + min)

round = (n) ->
	return math.floor(n + 0.5)

clamp = (low, n, high) ->
	return math.min(math.max(low, n), high)

getAngle = (x1,y1, x2,y2) ->
	return math.atan2(y2-y1, x2-x1)

limitPosToCurrentRoom = (obj) ->
	map = game.state.current_room.map
	tile_size = map.tilewidth
	maxw = (map.width * tile_size) - obj.width
	maxh = (map.height * tile_size) - obj.height

	obj.pos.x = clamp(0, obj.pos.x, maxw)
	obj.pos.y = clamp(0, obj.pos.y, maxh)

onScreen = (x, y, border=0) ->
	cam = game.state.camera

	cx, cy = cam.pos.x, cam.pos.y
	return x > cx - border and x < cx + GAME_WIDTH + border and
				 y > cy - border and y < cy + GAME_HEIGHT + border

pointBoxCollision = (point, box) ->
	return point.x > box.x and point.x < box.x + box.width and
				 point.y > box.y and point.y < box.y + box.height

-- Axis Aligned Bounding Box Collision Detection / Are these two squares overlapping?
AABB = (b1, b2) ->
	return b1.pos.x < (b2.pos.x+b2.width) and (b1.pos.x+b1.width) > b2.pos.x and
	b1.pos.y < (b2.pos.y+b2.height) and (b1.pos.y+b1.height) > b2.pos.y

shadowPrint = (text="empty_text", x=0, y=0, col=WHITE) ->
	lg.setColor(WHITE)
	lg.print({BLACK, text}, x+1, y+1)
	lg.print({col, text}, x, y)

------------------------------------------


-- replaceSlashes is needed to replace forward slashes in a directory string so we can properly require files on any OS
replaceSlashes = (path) ->
	return path\gsub("/", ".")

-- recursiveEnumerate used with requireFiles to recursively require all .lua files in a directory
recursiveEnumerate = (path, file_list) ->
	files = lf.getDirectoryItems(path)
	for f in *files
		file_path = path.."/"..f
		typ = lf.getInfo(file_path).type

		if typ == "file"
			require_path = replaceSlashes(file_path)
			table.insert(file_list, require_path)
		elseif typ == "directory"
			recursiveEnumerate(file_path, file_list)

requireFiles = (files) ->
	-- This func will only require .lua files
	for _, file in ipairs(files) do
		if file\sub(-3, #file) == "lua"
			file = file\sub(1, -5)
			require(file)

requireFolder = (path) ->
	files = {}
	recursiveEnumerate(path, files)
	requireFiles(files)

UUID = () ->
	fn = (x) ->
		r = love.math.random(16) - 1
		r = (x == "x") and (r + 1) or (r % 4) + 9
		return ("0123456789abcdef")\sub(r, r)

	return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx")\gsub("[xy]", fn))

getTableLength = (t) ->
	length = 0
	for k, v in pairs(t) do
		length = length + 1

	return length

printTable = (tbl) ->
	for k, v in pairs(tbl)
		print(k, v)
