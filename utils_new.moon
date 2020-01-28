
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

table.shallow_copy = (t) ->
    return {k, v for k, v in pairs t}

math.sign = (x) ->
    if x < 0 return -1
    elseif x > 0 return 1
    else return 0


setupRandom = () ->
	math.randomseed(os.time())
	math.random() math.random() math.random()

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

onScreen = (x, y, border=0) ->
	cam = game.state.camera
	
	cx, cy = cam.pos.x, cam.pos.y
	return x > cx - border and x < cx + GAME_WIDTH + border and
				 y > cy - border and y < cy + GAME_HEIGHT + border

pointBoxCollision = (point, box) ->
	return point.x > box.x and point.x < box.x + box.width and
				 point.y > box.y and point.y < box.y + box.height

------------------------------------------

-- recursiveEnumerate used with requireFiles to recursively require all .lua files in a directory
recursiveEnumerate = (folder, file_list) ->
	items = love.filesystem.getDirectoryItems(folder)
	for _, item in ipairs(items) do
		file = folder .. '/' .. item
		if love.filesystem.getInfo(file).type == "file"
			table.insert(file_list, file)
		elseif love.filesystem.getInfo(file).type == "directory"
			recursiveEnumerate(file, file_list)

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