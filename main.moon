push = require "lib/push"

CANVAS_SIZE = {
    width: 240,
    height: 160
}

WINDOW_DEFAULT_SIZE = {
    width: 800,
    height: 600
}

love.load = ->
    love.graphics.setDefaultFilter("nearest", "nearest", 1)

    push_opts = {
        fullscreen:false,
        resizable:true,
        pixelperfect:true,
        canvas:true
    }
    push\setupScreen(CANVAS_SIZE.width, CANVAS_SIZE.height, WINDOW_DEFAULT_SIZE.width, WINDOW_DEFAULT_SIZE.height, push_opts)

    export image = love.graphics.newImage("sprites/example.png")
    
love.update = ->

love.resize = (w, h) ->
    push\resize(w, h)

love.draw = ->
    export image

    push\start!
    love.graphics.draw(image, 10, 10)
    push\finish!