
export class Game
	new: () =>


	init: =>
		@timer = Timer!
		@state = GameTitleState(@) --GameExploreState(@)
		@next_state = nil
		@button_prompts = {z: "", x: ""}

		@dialog = DialogManager!
		@pause_menu = PauseMenu!
		@paused = false

		@party = {
			Paladin!
			Fighter!
			nil,
			Mage!
		}

		-- Gold is stored in the Inventory
		@inventory = Inventory(@)

		@transitioning = false
		@transition_progress = 0.0
		@transition_length = 0.25

		if @state.init
			@state\init!

	-----------------------------------------------

	startStateTransitionIn: =>
		@state\destroy!
		@state = nil

		@transitioning = true
		@transition_progress = 0.0

		-- Fade to black, then call startStateTransitionOut
		@timer\tween(@transition_length, @, {transition_progress: 1.0}, 'in-out-cubic', @\startStateTransitionOut, "transition")

	startStateTransitionOut: =>
		-- Create, set and initiate the new game state
		@state = @next_state.state(@, unpack(@next_state.params))
		-- ^^^^ unpack() could cause issues again here and may need to be changed
		-- to a key, value loop like when loading map objects
		@state\init!

		@next_state = nil

		@transition_progress = 1.0

		-- Fade from black to the new state
		@timer\tween(@transition_length, @, {transition_progress: 0.0}, 'in-out-cubic', @\endStateTransition, "transition")

	endStateTransition: =>
		@transitioning = false

	-----------------------------------------------

	update: =>
		@timer\update(dt)

    -- Reset Contextual Button Prompts
		@button_prompts = {z: "", x: ""}

		if @transitioning
			-- do nothing yet, may put something here in the future
			-- print("transition progress: #{@transition_progress}")
			nil

		else
			if @paused
				@pause_menu\update!
			elseif @state
				@state\update!
				@dialog\update!

		if input\pressed "pause"
			@paused = not @paused

		-- DEBUG CODE, NEEDS TO BE MOVED --
		-----------------------------------

		if input\pressed "dialogdebug"

			if @dialog.running
				@dialog\advanceInput!
-- 			else
-- 				tree = DialogTree({
-- 					DialogBox("Dialog 1"),
-- 					DialogBox("Dialog 2"),
-- 					DialogBox("Dialog 3{input}\nWhere would you\nlike to go?",
-- 					 {"Go to dialog 4", "Go to dialog 5-6", "Go back to the start"}),
-- 					DialogBox("Dialog 4")
-- 					DialogBox("Dialog 5")
-- 					DialogBox("Dialog 6 wow {pause,30}{color,4,1,0,0}{wave,4}nice")
-- 				},{
-- 					[1]:2,
-- 					[2]:3,
-- 					[3]:{4,5,1},
-- 					[4]:nil,
-- 					[5]:6
-- 					[6]:nil
-- 				})

-- 				@dialog\setTree(tree)

		if input\pressed "battledebug"
			@next_state = {state: GameBattleState, params: {}}

		if input\pressed "inventorydebug"
			@next_state = {state: GameInventoryState, params: {}}

		if input\pressed "overworlddebug"
			@next_state = {state: GameOverworldState, params: {12*8, 8*8}}

		if input\pressed "gameoverdebug"
			@next_state = {state: GameOverState, params: {}}

		-----------------------------------

		if @next_state and not @transitioning
			@\startStateTransitionIn!

	drawButtonPrompts: =>
		sprites.gui.z_button\draw(GAME_WIDTH - 64, 0)
		sprites.gui.x_button\draw(GAME_WIDTH - 56, 16)
		shadowPrint(@button_prompts.z, GAME_WIDTH - 40, 4)
		shadowPrint(@button_prompts.x, GAME_WIDTH - 32, 16)

	drawStateTransition: =>
		if @state
			@state\draw!

		p = @transition_progress

		lg.setColor({0, 0, 0, p})
		lg.rectangle("fill", 0,0, GAME_WIDTH, GAME_HEIGHT)
		-- lg.rectangle("fill", 0,0, GAME_WIDTH*p, GAME_HEIGHT)
		lg.setColor(WHITE)

	draw: =>
		if @transitioning
			@drawStateTransition!
		else
			if @state
				@state\draw!
				if @state.__class.__name == "GameExploreState" or @state.__class.__name == "GameOverworldState"
					@drawButtonPrompts!
			if @paused
				@pause_menu\draw({0.5, 0.5, 0.5})

			@dialog\draw!

