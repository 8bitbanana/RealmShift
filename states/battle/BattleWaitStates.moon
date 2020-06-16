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

export class BattleDialogState extends State
	new: (@parent, @args) =>

	init: () =>
		@dialog = DialogManager!
		@dialog\setTree(@args.tree)

	update: () =>
		@dialog\update!
		if input\pressed "confirm"
			@dialog\advanceInput!
		if input\pressed "back"
			@parent.dialog\cancelInput!
		if not @dialog.running
			@parent\dialogCallback!

	draw: () =>
		@dialog\draw!

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
