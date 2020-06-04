Timer = require "lib/Timer"
Inspect = require "lib/inspect"

X_SPACING = 0
Y_SPACING = 0
FRAME_MOD = 2
CURSOR_BLINK_MOD = 60

export class DialogBox
	new: (@text) =>
		@reset!

	reset: =>
		@started = false -- The dialog has started
		@waitingForInput = false -- The dialog is waiting for input
		@waitingForClose = false -- The dialog is waiting for the final input
		@done = false -- The dialog is finished: the manager should close it
		@visible = false -- Flag to make the dialog draw/not draw
		@currentIndex = 0
		@framecount = 0
		@skipcount = 0
		@linecount = 1
		@scrollFlag = false
		@targetscrollOffset = 0
		@scrollOffset = @targetscrollOffset
		@cursorBlinkFrameOffset = 0
		@chars = {} -- List of raw text chars (unlike @text, which also has the unprocessed tokens)
		@tokens = {} -- List of processed formatting tokens
		@tokenise!

	advanceInput: () =>
		@waitingForInput = false if @waitingForInput
		if @waitingForClose
			@done = true
			@waitingForClose = false

	begin: =>
		if not @started
			@started = true
			@incText!

	tokenise: =>
		@chars = {}
		@tokens = {}

		rawTokens = {}
		currentRawToken = ""
		inAToken = false
		charIndex = 0
		for index, char in pairs string.totable(@text)
			if char == "{"
				inAToken = true
				continue
			if inAToken
				if char == "}"
					inAToken = false
					table.insert(rawTokens, {
						token:currentRawToken,
						index:charIndex
					})
					currentRawToken = ""
					continue
				currentRawToken ..= char
			else
				table.insert(@chars, char)
				charIndex += 1
		for x in *rawTokens
			rawToken = x.token
			charIndex = x.index
			destruct = string.split(rawToken, ",")
			code = destruct[1]
			multilength_codes = {"wave":true, "color":true}
			length = 1 -- why are vars defined in if statements
			args = {}  -- local to that if statement???
			if multilength_codes[code] != nil
				length = tonumber(destruct[2])
				args = [x for x in *destruct[3,]]
			else
				args = [x for x in *destruct[2,]]
			for i=1, length
				@tokens[charIndex+i] = {} if @tokens[charIndex+i] == nil
				token = {code:code, index:i+1, args:args}
				table.insert(@tokens[charIndex+i], token)

	incText: () =>
		return if @waitingForInput
		if @currentIndex < #@chars
			@currentIndex += 1
			if @chars[@currentIndex] == "\n"
				@linecount += 1
				if @linecount > 3
					@scrollFlag = true
					@waitingForInput = true
					@cursorBlinkFrameOffset = @framecount % CURSOR_BLINK_MOD
			if @tokens[@currentIndex] != nil
				for token in *@tokens[@currentIndex]
					if token.code == "input"
						@waitingForInput = true
					if token.code == "pause"
						@skipcount = tonumber(token.args[1])
		else
			@waitingForInput = true
			@waitingForClose = true
			@cursorBlinkFrameOffset = @framecount % CURSOR_BLINK_MOD

	update: =>
		if @started
			@framecount += 1
			@skipcount -= 1 if @skipcount > 0
			if @scrollFlag and not @waitingForInput
				@targetscrollOffset -= dialogfont\getHeight!
				@scrollFlag = false
			if @targetscrollOffset != @scrollOffset
				@scrollOffset += math.sign(@targetscrollOffset - @scrollOffset)
			if @framecount % FRAME_MOD == 0 and @skipcount == 0
				@incText!

	draw: =>
		if @started
			lg.setColor(1, 1, 1)
			lg.rectangle("fill", 3, 107, 234, 50)
			Push\setCanvas("dialogbox")
			lg.clear()
			width = 0
			height = 0
			lg.setFont(dialogfont)
			for index=1, @currentIndex
				lg.setColor(0, 0, 0)
				xoffset = width
				yoffset = height
				if @tokens[index] != nil
					for token in *@tokens[index]
						switch token.code
							when "color"
								lg.setColor(token.args)
							when "wave"
								yoffset += 6*math.sin((@framecount + token.index*3) / 10)
				if @chars[index] == "\n"
					height += dialogfont\getHeight! + Y_SPACING
					width = 0
				else
					lg.print(@chars[index], 3+xoffset, 3+yoffset+@scrollOffset, 0)
					width += dialogfont\getWidth(@chars[index]) + X_SPACING
			Push\setCanvas("main")
			if @waitingForInput and (@framecount - @cursorBlinkFrameOffset) % CURSOR_BLINK_MOD > CURSOR_BLINK_MOD / 2
				sprites.gui.cursor\draw(219, 146)
