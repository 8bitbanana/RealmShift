
export class Message
	new: (@pos={x: 0, y: 0}, @width=128, @height=32, @text="test_text") =>


	init: =>


	update: =>


	draw: =>
		font = lg.getFont!
		_, text = font\getWrap(@text, @width)

		y = @pos.y
		for line in *text
			shadowPrint(line, @pos.x, y)
			y += 10
