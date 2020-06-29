
function loadSprites()
	-- Static sprites
	sprites = {
		player = {
			idle = Soda.newSprite(lg.newImage("images/sprites/characters/test_char.png"), 8, 8),
		},
		npc = {
			merchant = Soda.newSprite(lg.newImage("images/sprites/characters/merchant.png"), 8, 8),
		},
		overworld = {
			bridge = Soda.newSprite(lg.newImage("images/sprites/overworld/bridge_tile.png"), 4, 4),
			enemy = Soda.newSprite(lg.newImage("images/sprites/overworld/enemy_icon.png"), 4, 4),
		},
		items = {
			potion = Soda.newSprite(lg.newImage("images/sprites/item/potion.png"), 8, 8),
			small_potion = Soda.newSprite(lg.newImage("images/sprites/item/small_potion.png"), 8, 8),
			bridge = Soda.newSprite(lg.newImage("images/sprites/item/bridge_item.png"), 8, 8),
		},
		battle = {
			cursor_right = Soda.newSprite(lg.newImage("images/sprites/battle/cursor_right.png"), 8, 12),
			cursor_down = Soda.newSprite(lg.newImage("images/sprites/battle/cursor_down.png"), 12, 8),
			main_char = Soda.newSprite(lg.newImage("images/sprites/battle/main_char.png"), 8, -16),
			paladin_char = Soda.newSprite(lg.newImage("images/sprites/battle/paladin_char.png"), 8, -16),
			artificer_char = Soda.newSprite(lg.newImage("images/sprites/battle/artificer_char.png"), 8, -16),
			archer_enemy = Soda.newSprite(lg.newImage("images/sprites/battle/archer_enemy.png"), 14, -23),
			lancer_enemy = Soda.newSprite(lg.newImage("images/sprites/battle/lancer_enemy.png"), 14, -23),
			buffs = {
				rally = Soda.newSprite(lg.newImage("images/sprites/battle/buffs/boost_golden.png"), 5, 5),
				poison = Soda.newSprite(lg.newImage("images/sprites/battle/buffs/poison.png"), 5, 5),
				defence = Soda.newSprite(lg.newImage("images/sprites/battle/buffs/defence.png"), 5, 5)
			}
		},
		gui = {
			finger_cursor = Soda.newSprite(lg.newImage("images/sprites/gui/finger_cursor.png"), 8, 8),
		  z_button = Soda.newSprite(lg.newImage("images/sprites/gui/z_button.png"), 13, 13),
		  x_button = Soda.newSprite(lg.newImage("images/sprites/gui/x_button.png"), 13, 13),
		  cursor = Soda.newSprite(lg.newImage("images/sprites/gui/cursor.png"), 12, 8),
		  cursor_small = Soda.newSprite(lg.newImage("images/sprites/gui/cursor_small.png"), 8, 8),
		  banner_strip = Soda.newSprite(lg.newImage("images/sprites/gui/banner_strip.png"), 0, 0),
		  banner_strip_end = {
		  	Soda.newSprite(lg.newImage("images/sprites/gui/banner_strip_end_1.png"), 0, 0),
		  	Soda.newSprite(lg.newImage("images/sprites/gui/banner_strip_end_2.png"), 0, 0),
		  	Soda.newSprite(lg.newImage("images/sprites/gui/banner_strip_end_3.png"), 0, 0),
		  	Soda.newSprite(lg.newImage("images/sprites/gui/banner_strip_end_4.png"), 0, 0),
		  	Soda.newSprite(lg.newImage("images/sprites/gui/banner_strip_end_5.png"), 0, 0),
		  	Soda.newSprite(lg.newImage("images/sprites/gui/banner_strip_end_6.png"), 0, 0),
		  	Soda.newSprite(lg.newImage("images/sprites/gui/banner_strip_end_7.png"), 0, 0),
		  	Soda.newSprite(lg.newImage("images/sprites/gui/banner_strip_end_8.png"), 0, 0),
		  	Soda.newSprite(lg.newImage("images/sprites/gui/banner_strip_end_9.png"), 0, 0),
		  	Soda.newSprite(lg.newImage("images/sprites/gui/banner_strip_end_10.png"), 0, 0),
		  	Soda.newSprite(lg.newImage("images/sprites/gui/banner_strip_end_11.png"), 0, 0),
		  },
		},
	}

	--Animated Sprites
	sprites.items.gold_coin = Soda.newAnimatedSprite(8, 8)
	sprites.items.gold_coin:addAnimation('main', {
		image = lg.newImage("images/sprites/item/gold_coin.png"),
		frameWidth = 16,
		frameHeight = 16,
		frames = {
			{1,1,3,1, 0.1}
		}
	})

	backgrounds = {
		-- May change to use Sodapop library if backgrounds get animated
		desert = lg.newImage("images/backgrounds/desert.png")
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
