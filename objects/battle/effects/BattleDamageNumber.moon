Inspect = require("lib/inspect")
export class BattleDamageNumber
	new: (@pos, @number) =>
		@currentoffset = {x:0,y:0}
		@currentalpha = 0
		@time = 0
		@destroyed = false

	update: =>
		if @time < 7
			@currentalpha = (@time / 7)
		else if @time < 30
			@currentalpha = 1 - ((@time-7) / 23)
		else
			@destroyed = true
			@currentalpha = 0
		@currentoffset = vector.mult(vector.up, @time)
		@time += 1

	draw: =>
		lg.setColor(0,0,0,@currentalpha)
		newpos = vector.add(@pos, @currentoffset)
		lg.print(tostring(@number), newpos.x, newpos.y)