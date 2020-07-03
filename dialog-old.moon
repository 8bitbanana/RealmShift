Timer = require "lib.Timer"

font = lg.newFont("fonts/iso8.ttf")

-- Split string s by character delim
-- https://stackoverflow.com/a/40151628/8708443
string.split = (s, delim) ->
	return [w for w in s\gmatch("([^"..delim.."]+)")]

string.totable = (s) ->
	t = {}
	s\gsub(".", (c)->table.insert(t, c)) 
	return t

table.shallow_copy = (t) ->
	return {k, v for k, v in pairs t}

class DialogText
	new: (@text, @startx, @starty, @config={}) =>
		@fillConfigDefaults!
		@reset!

	reset: () =>
		@framecount = 0 -- Counter (+1 each update())
		@started = false
		@done = false
		@currentState = {} -- table of {char, effects, width, height} to pass to draw function
		@currentIndex = 0 -- current character index
		@timer = nil -- chrono Timer (currently unused)
		@chars = string.totable(@text) -- convert table from @text string

		@skipcount = 0 -- Set above 0 to pause for that many frames
		@effectData = {} -- table for storing data and counters for handleEffects

	fillConfigDefaults: () =>
		defaults = {
			framemod:4, -- Delay of text (e.g. inc every 4 frames)
			colour: {1,1,1,1} -- Default colour of text
			xspacing: 0 -- Extra horizontal spacing for each char
			yspacing: 0 -- Extra vertical spacing for each char
			xmax: -1
			ymax: 3
		}
		for key, defaultvalue in pairs defaults
			@config[key] = defaultvalue if @config[key] == nil

	begin: () =>
		if not @started
			@started = true
			@timer = Timer!
			@incText!

	currentChar: () =>
		return @chars[@currentIndex]

	handleEffects: () =>
		effects = {}
		if @currentChar! == "{" -- parse formatting codes
			code = ""
			@currentIndex += 1
			while @currentChar! != "}"
				code ..= @currentChar!
				@currentIndex += 1
			@currentIndex += 1
			destruct = string.split(code, ",")
			code = destruct[1]
			args = [x for x in *destruct[2,]]
			switch code
				when "test" -- print arg1 to console
					print args[1]
				when "wave" -- make next arg1 characters wavy
					@effectData.wave = tonumber(args[1])
				when "framemod" -- update framemod (speed) to arg1
					@config.framemod = tonumber(args[1])
				when "pause" -- pause for arg1 frames
					@skipcount = tonumber(args[1])
					effects.cancel = true
				when "colour" -- set colour to arg1-4 for arg5 characters
					@effectData.textColour = [tonumber(x) for x in *args[1,4]]
					@effectData.colourCount = tonumber(args[5])
				else
					print "Unknown code parsed - " .. code
		if @effectData.wave != nil
			effects.wave = @effectData.wave
			@effectData.wave -= 1
			@effectData.wave = nil if @effectData.wave == 0
		if @effectData.colourCount != nil
			effects.colour = table.shallow_copy @effectData.textColour
			@effectData.colourCount -= 1
			if @effectData.colourCount == 0
				@effectData.colourCount = nil 
				@effectData.textColour = nil
		return effects
		
			
	incText: () =>
		@currentIndex += 1
		if @currentIndex <= #@text
			effects = @handleEffects!
			if effects.cancel
				@currentIndex -= 1
			else
				@currentState[#@currentState+1] = {
					char:@currentChar!,
					effects:effects,
					width:font\getWidth(@currentChar!)
					height:font\getHeight("I")
				}
		else
			@done = true

	update: (dt) =>
		if @started
			@framecount += 1
			@timer\update(dt)
			@skipcount -= 1 if @skipcount > 0
			if @framecount % @config.framemod == 0 and @skipcount == 0
				@incText!

	draw: () =>
		love.graphics.setFont(font)
		width = 0
		height = 0
		if @started
			for index, state in pairs @currentState
				if state.effects.colour != nil
					love.graphics.setColor(state.effects.colour)
				else
					love.graphics.setColor(@config.colour)
				xoffset = width
				yoffset = height
				if state.effects.wave != nil
					yoffset += 6*math.sin((@framecount + state.effects.wave*3) / 10)
				if state.char == "\n"
					height += state.height + @config.yspacing
					width = 0
				else
					love.graphics.print(state.char, @startx + xoffset, @starty + yoffset)
					width += state.width + @config.xspacing


class DialogScript
	new: (@textlist, @startx, @starty, @config={}) =>
		@reset!

	reset: () =>
		@currentDialog = nil -- The current DialogText obj
		@currentIndex = 0 -- The current page index
		@incDialog!
		@currentDialog\reset!
		@started = false -- This script has started
		@done = false -- The last page is done
		@readyForInput = false -- The current page has finished advancing and the user can press advance to move to the next page
		@readyToQuit = false  -- The user has pressed advance when the dialog is finished - so this window should be closed

	begin: () =>
		@started = true
		@currentDialog\begin!
	
	advanceInput: () =>
		if not @started
			@begin!
		elseif @readyForInput
			moredialog = @incDialog!
			if moredialog
				@currentDialog\reset!
				@currentDialog\begin!
			else
				@done = true
		elseif @done
			@readyToQuit = true
		-- Pressing advance to speed dialog up could be added here

		
	-- Returns true if there is more pages of dialog to go
	incDialog: () =>
		@currentIndex += 1
		if @currentIndex > #@textlist
			return false
		@currentDialog = DialogText(@textlist[@currentIndex], @startx, @starty, @config)
		return true

	update: (dt) =>
		if @currentDialog != nil
			@currentDialog\update dt
			@readyForInput = @started and not @done and @currentDialog\done

	draw: () =>
		if @currentDialog != nil
			@currentDialog\draw!