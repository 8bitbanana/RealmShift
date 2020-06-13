Inspect = require "lib/inspect"
export class ModalOption
	new: (@text, @cancel=false) =>
		@pos = {x:0, y:0}
		@size = {
			w:dialog_font\getWidth(@text)
			h:dialog_font\getHeight(@text)
		}

	draw: =>
		lg.setFont(dialog_font)
		lg.setColor(0,0,0)
		lg.print(@text, @pos.x, @pos.y)

export class DialogModal
	new: (@options) =>
		if @options == nil
			@options = {
				ModalOption("Sure!"),
				ModalOption("Wait a second...", true)
			}
		else
			for i,option in pairs @options
				if type(option) == "string"
					if string.sub(option, 1, 8) == "[CANCEL]"
						@options[i] = ModalOption(string.sub(option, 9), true)

					else
						@options[i] = ModalOption(option)
		@reset!

	reset: =>
		@result = nil
		@done = false
		@selected = 1
		for i,option in pairs @options
			@selected = i if option.cancel

		optionCount = #@options
		assert(optionCount>0)

		maxW = 0
		@size = {w:17, h:10}
		currentPos = {x:14, y:3}

		for i,option in pairs @options
			option.pos = table.shallow_copy(currentPos)
			if option.size.w > maxW
				maxW = option.size.w
			@size.h += option.size.h
			break if i==optionCount
			@size.h += 3
			currentPos.y += option.size.h + 5
		@size.w += maxW
		@pos = {
			x: GAME_WIDTH - 5 - @size.w
			y: GAME_HEIGHT - 5 - @size.h
		}

		for option in *@options
			option.pos.x += @pos.x
			option.pos.y += @pos.y

		@cursor = Cursor({x:0,y:0}, "right")
		@updateCursorPos!

	advanceInput: => @select!

	cancelInput: =>
		for i, option in pairs @options
			if option.cancel
				@selected = i
				@select!
				return

	updateCursorPos: =>
		option = @selectedOption!
		mid = math.floor(option.size.h / 2)
		@cursor.pos = table.shallow_copy(option.pos)
		@cursor.pos.x -= 15
		@cursor.pos.y += mid - 10

	selectedOption: =>
		return @options[@selected]

	update: =>
		@moveOptionCursor(-1) if input\pressed("up")
		@moveOptionCursor(1)  if input\pressed("down")
		@cursor\update!

	moveOptionCursor: (dir) =>
		@selected += dir
		@selected = 1 if @selected < 1
		@selected = #@options if @selected > #@options
		@updateCursorPos!

	select: =>
		@result = @selected
		@done = true

	draw: =>
		lg.setColor(1,1,1)
		lg.rectangle("fill", @pos.x, @pos.y, @size.w, @size.h)
		lg.setColor(0,0,0)
		lg.rectangle("line", @pos.x, @pos.y, @size.w, @size.h)
		for option in *@options
			option\draw!
		@cursor\draw!
