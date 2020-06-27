
export class NPCWanderState extends State
	new: (@parent) =>
		@wait_time   = 2
		@wander_time = 2
		@spd         = 30
		@dir         = 0 -- Direction in radians
		@dd					= 8 -- Direction Delta; how much @dir can change every frame when moving

		@timer = Timer!
		@\startWandering!

	startWandering: =>
		-- Get new random direction to start moving in
		@dir = math.random() * TWO_PI
		rtime = math.random() * 2 -- Random delay from 0-2 seconds
		@timer\after(@wait_time + rtime, @\wander)

	wander: =>
		-- during will call @\moveAround! every frame for @wander_time seconds
		-- then call @\startWandering after @wander_time seconds have passed
		rtime = math.random() * 2 -- Random delay from 0-2 seconds
		@timer\during(@wander_time, @\moveAround, @\startWandering)

	moveAround: =>
		-- Slightly alter movement direction each frame
		angle_delta = @dd * dt
		@dir += random(-angle_delta, angle_delta)
		-- ^^^^ Note that random is different from math.random. random is in utils_new.moon

		p = @parent
		world = game.state.current_room.world
		-- Get position we want to move to
		nx = p.pos.x + cos(@dir) * (@spd * dt)
		ny = p.pos.y + sin(@dir) * (@spd * dt)
		-- Move and collide with physics world
		p.pos.x, p.pos.y = world\move(p, nx, ny)

	update: =>
		@timer\update(dt)
		if @parent.dialog
			@parent\checkTalk!

	destroy: =>
		@timer\destroy!
