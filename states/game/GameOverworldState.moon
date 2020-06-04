
require "states/state"

export class GameOverworldState extends State
	new: (@parent, @tx=0, @ty=0) =>
		@objects = ObjectManager!
		@current_room = Room("overworld/overworld_1")

		@enemy_spawn_rate = 3
		@max_enemies = 3
		@enemy_timer = Timer!

	init: =>
		@current_room\init!

		@player = OverworldPlayer({x: @tx, y: @ty})
		@camera = Camera!
		@camera\setPos(@player.pos)
		@camera\limitPos(@current_room)

		@objects\addObject(@camera)
		@objects\addObject(@player)

		-- Add player to physics world so they can collide with tiles
		@current_room.world\add(@player, @player.pos.x, @player.pos.y, @player.width, @player.height)

		-- Start enemy spawner timer
		@enemy_timer\every(@enemy_spawn_rate, @\spawnEnemy)

	spawnEnemy: =>
		enemy_count = @objects\countObjects("OverworldEnemy")
		if enemy_count < @max_enemies
			range = 5
			tx = @player.pos.x + (math.random(range*2) - range) * 8
			ty = @player.pos.y + (math.random(range*2) - range) * 8
			print(tx, ty)
			e = OverworldEnemy({x: tx, y: ty})
			@objects\addObject(e)

	destroy: =>
		@enemy_timer\destroy!
		super\destroy!

	update: =>
		@enemy_timer\update(dt)

		@objects\updateObjects!
		@objects\checkDestroyed!

	draw: =>
		Push\setCanvas("main")

		@current_room\draw(@camera.pos)

		lg.push!
		lg.translate(-@camera.pos.x, -@camera.pos.y)
		@objects\drawObjects!

		-- DEBUG PRINTING --
		-- shadowPrint("This is the overworld!\nThis is where the player will explore the\nworld and enter new areas such as towns &\ndungeons etc.\n\n\n\n\n\nCurrently all you can do is move.")

		lg.pop!
