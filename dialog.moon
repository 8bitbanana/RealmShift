Timer = require "lib/Timer"

X_SPACING = 0
Y_SPACING = 2
FRAME_MOD = 4

font = lg.newFont("fonts/iso8.ttf")

string.split = (s, delim) ->
    return [w for w in s\gmatch("([^"..delim.."]+)")]

string.totable = (s) ->
    t = {}
    s\gsub(".", (c)->table.insert(t, c)) 
    return t

table.shallow_copy = (t) ->
    return {k, v for k, v in pairs t}

export class DialogBox
    new: (@text) =>
        @reset!

    reset: () =>
        @started = false
        @done = false
        @chars = string.totable(@text)
        @currentState = {}
        @currentIndex = 0
        @framecount = 0

    begin: () =>
        @started = true

    update: (dt) =>
        if @started
            @framecount += 1
            if @framecount % FRAME_MOD == 0
                @incText!

    currentChar: () =>
        return @chars[@currentIndex]

    incText: () =>
        @currentIndex += 1
        if @currentIndex <= #@text
            @currentState[#@currentState+1] = {
                char: @currentChar!,
                width:font\getWidth(@currentChar!),
                width:font\getHeight("Iq")
            }
        else
            @done = true

    draw: () =>
        lg.setColor(1, 1, 1)
        lg.rectangle("fill", 3, 107, 234, 50)
        width = 0
        height = 0
        lg.setColor(0, 0, 0)
        lg.setFont(font)
        if @started
            for index, state in pairs @currentState
                xoffset = width
                yoffset = height
                if state.char == "\n"
                    height += state.height + Y_SPACING
                    width = 0
                else
                    lg.print(state.char, 6+xoffset, 110+yoffset, 0)
                    width += state.width + X_SPACING
