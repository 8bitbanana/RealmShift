
function setupRandom()
	math.randomseed(os.time())
	math.random();math.random();math.random();
end

function dirPressed()
	return input:down("left") or input:down("right") or input:down("up") or input:down("down")
end

function lerp(s, e, f)
	local p = 1-(f^dt)
	return (s + p*(e - s))
end

function random(min, max)
	local min, max = min or 0, max or 1
	return (min > max and (love.math.random()*(min - max) + max)) or (love.math.random()*(max - min) + min)
end

function round(n)
	return math.floor(n + 0.5)
end

function clamp(low, n, high)
	return math.min(math.max(low, n), high)
end

function sign(x)
	if x<0 then
	 return -1
	elseif x>0 then
	 return 1
	else
	 return 0
	end
end

function getAngle(x1,y1, x2,y2)
	return math.atan2(y2-y1, x2-x1)
end

function onScreen(x, y, border)
	local border = border or 0
	local cam = game.camera
	
	local cx, cy = cam.pos.x, cam.pos.y
	return x > cx - border and x < cx + GAME_WIDTH + border and
				 y > cy - border and y < cy + GAME_HEIGHT + border
end

function pointBoxCollision(point, box)
	return point.x > box.x and point.x < box.x + box.width and
				 point.y > box.y and point.y < box.y + box.height
end

-----------------------------------------------------

function recursiveEnumerate(folder, file_list)
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

function requireFiles(files)
	-- This func will only require .lua files
	for _, file in ipairs(files) do
		if file:sub(-3, #file) == "lua" then
			local file = file:sub(1, -5)
			require(file)
		end
	end
end

function requireFolder(path)
	local files = {}
	recursiveEnumerate(path, files)
	requireFiles(files)
end

------------------------------------------------------

function UUID()
	local fn = function(x)
		local r = love.math.random(16) - 1
		r = (x == "x") and (r + 1) or (r % 4) + 9
		return ("0123456789abcdef"):sub(r, r)
	end
	return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", fn))
end

--------------------------------------------------------

function count_all(f)
    local seen = {}
    local count_table
    count_table = function(t)
        if seen[t] then return end
            f(t)
	    seen[t] = true
	    for k,v in pairs(t) do
	        if type(v) == "table" then
		    count_table(v)
	        elseif type(v) == "userdata" then
		    f(v)
	        end
	end
    end
    count_table(_G)
end

function type_count()
    local counts = {}
    local enumerate = function (o)
        local t = type_name(o)
        counts[t] = (counts[t] or 0) + 1
    end
    count_all(enumerate)
    return counts
end

global_type_table = nil
function type_name(o)
    if global_type_table == nil then
        global_type_table = {}
            for k,v in pairs(_G) do
	        global_type_table[v] = k
	    end
	global_type_table[0] = "table"
    end
    return global_type_table[getmetatable(o) or 0] or "Unknown"
end

--------------------------------------------------------------------

function getTableLength(t)
	local length = 0
	for k, v in pairs(t) do
		length = length + 1
	end
	return length
end