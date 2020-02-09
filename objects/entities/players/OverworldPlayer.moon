
export class OverworldPlayer
	new: (@pos = {x: 12, y: 7}) =>
		
	
	move: (dx=0, dy=0) =>
		@pos.x += dx
		@pos.y += dy
	
	update: =>
		interval = 0.5
		
		if input\down("left", interval)
			@\move(-1, 0)
		if input\down("right", interval)
			@\move(1, 0)
		if input\down("up", interval)
			@\move(0, -1)
		if input\down("down", interval)
			@\move(0, 1)
		
	draw: =>
		lg.setColor(ORANGE)
		lg.circle("fill", @pos.x*8+3, @pos.y*8+8, 8)
		lg.setColor(WHITE)
		lg.circle("line", @pos.x*8+3, @pos.y*8+8, 8)
		lg.print({BLACK, "P"}, @pos.x*8+1, @pos.y*8+1)
		lg.print({WHITE, "P"}, @pos.x*8, @pos.y*8)