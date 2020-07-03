
Inspect = require "lib.inspect"
export class Cursor
	new: (@pos, @dir)=>
		@posoffset={x:0,y:0}
		@t = 0
	update: () =>
		offset = math.sin(@t / 10)
		switch @dir
			when "left"
				@posoffset.x = offset
			when "right"
				@posoffset.x = offset
			when "up"
				@posoffset.y = offset
			when "down"
				@posoffset.y = offset
		@t+=1
	draw: () =>
		postotal = {
			x:@pos.x + @posoffset.x,
			y:@pos.y + @posoffset.y
		}
		switch @dir
			when "left" -- ni
				sprites.battle.cursor_right\draw(postotal.x, postotal.y)
			when "right"
				sprites.battle.cursor_right\draw(postotal.x, postotal.y)
			when "up" -- ni
				sprites.battle.cursor_down\draw(postotal.x, postotal.y)
			when "down"
				sprites.battle.cursor_down\draw(postotal.x, postotal.y)
