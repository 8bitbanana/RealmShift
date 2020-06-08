
-- {
-- 	[1]:2,
-- 	[2]:{3,5},
-- 	[3]:4,
-- 	[4]:6,
-- 	[5]:6
-- }

export class DialogTree
	new: (@dialogs, @map) =>
		@reset!

	reset: =>
		for dialog in *@dialogs
			dialog\reset!

		@currentIndex = 1
		@lastOption = nil
		@started = false
		@done = false
		@awaitinginput = false

	current: =>
		return @dialogs[@currentIndex]

	advanceInput: () =>
		@current!\advanceInput! if @current!
		if @current!.done
			@lastOption = @current!.modalresult
			@nextup!

	finish: =>
		@done = true

	nextup: =>
		previous = @current!
		next = @map[@currentIndex]
		switch type(next)
			when "number"
				@currentIndex = next
			when "table"
				@currentIndex = next[@lastOption]
			when "nil"
				@currentIndex = nil
			else error "Unexpected type in @map"
		if @currentIndex == nil
			@\finish!
		if @current! == nil
			@\finish!
		else
			@current!\reset!


	update: =>
		if @current! != nil
			@current!\update!
			@awaitinginput = @current!\awaitinginput
			if @current!.done
				@lastOption = @current!.modalresult
				@nextup!

	draw: =>
		@current!\draw! if @current!
