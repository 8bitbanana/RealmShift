
export class PlayerIdleState extends State
	new: (@parent) =>
		@\resetVel!
	
	resetVel: =>
		@parent.vel.x = 0
		@parent.vel.y = 0
	
	update: =>
		if dirPressed! then
			@\changeState(PlayerMoveState)
	
	draw: =>
		if @parent.sprite
			@parent.sprite\draw(@parent.pos.x, @parent.pos.y)