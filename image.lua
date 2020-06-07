
function loadSprites()
	sprites = {
		player = {
			idle = Soda.newSprite(lg.newImage("images/sprites/characters/test_char.png"), 8, 8),
		},
		overworld = {
			enemy = Soda.newSprite(lg.newImage("images/sprites/overworld/enemy_icon.png"), 4, 4),
		},
		battle = {
			cursor_right = Soda.newSprite(lg.newImage("images/sprites/battle/cursor_right.png"), 8, 12),
			cursor_down = Soda.newSprite(lg.newImage("images/sprites/battle/cursor_down.png"), 12, 8),
			main_char = Soda.newSprite(lg.newImage("images/sprites/battle/main_char.png"), 8, -16),
			paladin_char = Soda.newSprite(lg.newImage("images/sprites/battle/paladin_char.png"), 8, -16),
		},
		gui = {
		  z_button = Soda.newSprite(lg.newImage("images/sprites/gui/z_button.png"), 13, 13),
		  x_button = Soda.newSprite(lg.newImage("images/sprites/gui/x_button.png"), 13, 13),
		  cursor = Soda.newSprite(lg.newImage("images/sprites/gui/cursor.png"), 12, 8),
		},
	}
end

-- function imgToQuads(img, w, h)
	-- local quads = {}

	-- for y=0, (img:getHeight()/h)-1 do
		-- for x=0, (img:getWidth()/w)-1 do
			-- quads[#quads+1] = love.graphics.newQuad(math.floor((x*w)), math.floor((y*h)), math.floor(w), math.floor(h), img:getDimensions())
		-- end
	-- end

	-- return quads
-- end

-- function loadSprites()
	-- sprites = {}

	-- local sprite_folders = lf.getDirectoryItems("images/sprites")
	-- for _, sprite_name in pairs(sprite_folders) do
		-- -- print(sprite_name)
		-- local anim_files = lf.getDirectoryItems("images/sprites/"..sprite_name)
		-- for _, anim_name in pairs(anim_files) do
			-- anim_name = string.sub(anim_name, 1, -5)
			-- -- print(anim_name)

			-- local _, size_start = string.find(anim_name, "-")
			-- local size_string = string.sub(anim_name, size_start+1, #anim_name)
			-- local x_index = string.find(size_string, "x")
			-- local w = tonumber(string.sub(size_string, 1, x_index-1))
			-- local h = tonumber(size_string:sub(x_index+1, #size_string))

			-- -- print(size_string)
			-- -- print(w)
			-- -- print(h)
			-- -- print("\n\n")

			-- if not sprites[sprite_name] then
				-- sprites[sprite_name] = {}
			-- end
			-- if not sprites[sprite_name][anim_name] then
				-- sprites[sprite_name][anim_name] = {}
			-- end

			-- sprites[sprite_name][anim_name].image = lg.newImage("images/sprites/"..sprite_name.."/"..anim_name..".png")
			-- sprites[sprite_name][anim_name].quads = imgToQuads(sprites[sprite_name][anim_name].image, w, h)
		-- end
	-- end


	-- for k,v in pairs(sprites) do
		-- print(k,v)
		-- for i,j in pairs(v) do
			-- print(i,j)
		-- end
		-- print("\n--------\n")
	-- end

-- end

-- EXAMPLE STRUCTURE FOR HOW SPRITES ARE STORED

	-- sprites = {
		-- ["Sprite name"] = {
			-- ["Anim name"] = {
				-- image = lg.newImage("images/sprites/cursor/cursor-16x16.png"),
				-- quads = imgToQuads(sprites["cursor"]["cursor-16x16"].image, 16,16)
			-- }
		-- }
	-- }

-- function getRandomAnimName(sprite_name)
	-- local length = getTableLength(sprites[sprite_name])
	-- local index = math.random(1, length)
	-- local counter = 0

	-- for anim_name, _ in pairs(sprites[sprite_name]) do

		-- counter = counter + 1
		-- if index == counter then return anim_name end
	-- end
-- end
