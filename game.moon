
export class Game
	new: () =>
		@timer = Timer!
		@state = GameExploreState(@)
		@next_state = nil

		@dialogmanager = DialogManager!
		
		@transitioning = false
		@transition_progress = 0.0
		@transition_length = 0.25
	
	init: =>
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
	
		if @transitioning
			-- do nothing yet, may put something here in the future
			-- print("transition progress: #{@transition_progress}")
			nil
	
		else
			if @state
				@state\update!
				@dialogmanager\update!


		-- DEBUG CODE, NEEDS TO BE MOVED --
		-----------------------------------
		
		if input\pressed "dialogdebug"
			if @dialogmanager.running
				@dialogmanager\advanceInput!
			else
				@dialogmanager\push(DialogBox("This is a test of the {color,1,0,0,1,6}{wave,6}dialog box{pause,30}\nIt seems to work fairly well so far,\nalthough I did have to edit {colour,0,0,1,1,8}Push.lua.\n3\n4 test input{input}wow\n5\n6\n{wave,4}Wow!"))

		if input\pressed "battledebug"
			@next_state = {state: GameBattleState, params: {}}
		
		-----------------------------------
		
		
		if @next_state and not @transitioning
			@\startStateTransitionIn!
	
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
			if @dialogmanager.running
				@dialogmanager\draw!