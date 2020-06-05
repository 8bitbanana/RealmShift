export class BattleTurnState extends State
	new: (@parent, @args) =>

	init: () =>
		@ttl = @args.ttl
		@done = false

	update: () =>
		@ttl -= dt if not @done
		if @ttl <= 0 and not @done
			@done = true
			@parent\turnEnd!

export class TurnIntroState extends State
	new: (@parent, @args={}) =>

	init: =>
		@ttl = 1.0
		@ttl = @args.ttl if @args.ttl

	update: () =>
		@ttl -= dt if not @done
		if @ttl <= 0 and not @done
			@done = true
			@parent\turnStart!

	draw: () =>
		lg.print("TurnIntro", 10, 10)
