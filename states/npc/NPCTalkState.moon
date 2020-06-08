
export class NPCTalkState extends State
	new: (@parent) =>

	update: =>
		if @parent.dialog
			@parent\checkTalk!

	draw: =>
		p = @parent
		p.sprite\draw(p.pos.x, p.pos.y)
