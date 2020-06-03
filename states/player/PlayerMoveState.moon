
Inspect = require "lib/inspect"

export class PlayerMoveState extends State
	new: (@parent) =>
		-- Acceleration applied to velocity when pressing directional key
		@acc  = 24
		-- Friction for slowing velocity
		@fric = 12
		-- Max speed player can move by
		@max_vel = 60

	updateVel: =>
		-- Declare local variables so we don't have to type so much
		p   = @parent
		spd = @acc * dt

		if input\down("left")
			p.vel.x -= spd
		if input\down("right")
			p.vel.x += spd
		if input\down("up")
			p.vel.y -= spd
		if input\down("down")
			p.vel.y += spd

	applyFric: =>
		p    = @parent
		v    = p.vel
		fric = @fric * dt

		-- Slow down horizontal movement
		if v.x > fric
			v.x -= fric
		elseif v.x < -fric
			v.x += fric
		else
			v.x = 0

		-- Slow down vertical movement
		if v.y > fric
			v.y -= fric
		elseif v.y < -fric
			v.y += fric
		else
			v.y = 0

	limitVel: =>
		p = @parent
		mv = @max_vel * dt
		p.vel.x = clamp(-mv, p.vel.x, mv)
		p.vel.y = clamp(-mv, p.vel.y, mv)

	applyVel: =>
		-- get Physics world of current room / level / area / stage
		world = game.state.current_room.world

		p = @parent

		-- print(Inspect(world))
		-- print("\n\n\n")
		-- print(Inspect(p))

		-- Apply velocity to position and handle collisions with walls etc.
		p.pos.x, p.pos.y = world\move(p, p.pos.x + p.vel.x, p.pos.y + (p.height/2) + p.vel.y)
		-- Re-offset player's y position so that collision box & pos is correct
		p.pos.y -= (p.height/2)

	update: =>
		@\updateVel!
		@\applyFric!
		@\limitVel!
		@\applyVel!

		if not dirPressed! and (abs(@parent.vel.x) + abs(@parent.vel.y)) < 0.1
			@\changeState(PlayerIdleState)

	draw: =>
		if @parent.sprite
			@parent.sprite\draw(@parent.pos.x, @parent.pos.y)
