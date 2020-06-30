TAIL_LENGTH = 6
OFFSET_PER_FRAME = {x:-5,y:5}

export class BattleHail
	new: (@pos) =>
		@startoffset = @pos
		@endoffset = vector.add(@startoffset, vector.mult(OFFSET_PER_FRAME, TAIL_LENGTH))
		@time = 0
		@destroyed = false
		-- print("start - "..vector.tostring(@startoffset))
		-- print("  end - "..vector.tostring(@endoffset))

	update: =>
		@startoffset = vector.add(@startoffset, OFFSET_PER_FRAME)
		@endoffset = vector.add(@endoffset, OFFSET_PER_FRAME)
		
		if @endoffset.y > 140
			@destroyed = true
		else
			@time += 1

	draw: =>
		lg.setColor(0,0,1)
		lg.line(@startoffset.x, @startoffset.y, @endoffset.x, @endoffset.y)
		
