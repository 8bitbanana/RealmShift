Timer = require "lib/Timer"

X_SPACING = 0
Y_SPACING = 0
FRAME_MOD = 2
CURSOR_BLINK_MOD = 60

export class DialogBox
    new: (@text) =>
        @reset!

    reset: () =>
        @started = false -- The dialog has started
        @waitingForInput = false -- The dialog is waiting for input
        @waitingForClose = false -- The dialog is waiting for the final input to be done
        @done = false -- The user has finished with the dialog - the manager should move on
        @visible = false -- Flag to make the dialog not draw (hold key to hide dialogs for example)
        @chars = string.totable(@text)
        @currentState = {} 
        @currentIndex = 0
        @framecount = 0

        @skipcount = 0
        @effectData = {}

        @linecount = 1
        @scrollFlag = false -- Set this to true to scroll up on the next time waitingForInput is cleared
        @targetscrollOffset = 0 -- Scroll offset (w/ interpolation)
        @scrollOffset = @targetscrollOffset

        @cursorBlinkFrameOffset = 0 -- An offset for what frames the cursor blinks at, so that the flashing will start from the beginning every time

    advanceInput: () =>
        @waitingForInput = false if @waitingForInput
        if @waitingForClose
            @done = true
            @waitingForClose = false

    begin: () =>
        if not @started
            @started = true
            @incText!

    update: () =>
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

    handleEffects: () =>
        effects = {}
        if @currentChar! == "{"
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
                when "test"
                    print args[1]
                when "wave" -- w a v y
                    @effectData.wave = tonumber(args[1])
                when "pause" -- pause for arg1 frames
                    @skipcount = tonumber(args[1])
                    effects.cancel = true
                when "color" -- set colour to arg1-4 rgba for arg5 characters
                    @effectData.textColour = [tonumber(x) for x in *args[1,4]]
                    @effectData.colourCount = tonumber(args[5])
                when "input" -- pause until user input
                    @waitingForInput = true
                    effects.cancel = true
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

    currentChar: () =>
        return @chars[@currentIndex]

    incText: () =>
        return if @waitingForInput
        @currentIndex += 1
        if @currentIndex <= #@text
            effects = @handleEffects!
            if effects.cancel
                @currentIndex -= 1
            else
                @currentState[#@currentState+1] = {
                    char: @currentChar!,
                    width:dialogfont\getWidth(@currentChar!),
                    height:dialogfont\getHeight!,
                    effects:effects
                }
                if @currentChar! == "\n"
                    @linecount += 1
                    if @linecount > 3
                        @scrollFlag = true
                        @waitingForInput = true
                        @cursorBlinkFrameOffset = @framecount % CURSOR_BLINK_MOD
        else
            @waitingForInput = true
            @waitingForClose = true
            @cursorBlinkFrameOffset = @framecount % CURSOR_BLINK_MOD

    draw: () =>
        lg.setColor(1, 1, 1)
        lg.rectangle("fill", 3, 107, 234, 50)

        if @started
            Push\setCanvas("dialogbox")
            lg.clear()
            width = 0
            height = 0
            lg.setFont(dialogfont)
            for index, state in pairs @currentState
                if state.effects.colour != nil
                    lg.setColor(state.effects.colour)
                else
                    lg.setColor(0, 0, 0)
                xoffset = width
                yoffset = height
                if state.effects.wave != nil
                    yoffset += 6*math.sin((@framecount + state.effects.wave*3) / 10)
                if state.char == "\n"
                    height += state.height + Y_SPACING
                    width = 0
                else
                    lg.print(state.char, 3+xoffset, 3+yoffset+@scrollOffset, 0)
                    width += state.width + X_SPACING
            Push\setCanvas("main")
            if @waitingForInput and (@framecount - @cursorBlinkFrameOffset) % CURSOR_BLINK_MOD > CURSOR_BLINK_MOD / 2
                sprites.dialog.cursor\draw(219, 146)

