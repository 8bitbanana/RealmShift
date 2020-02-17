
export class Game
	new: () =>
		@state = GameExploreState(@, {"towns/test_town"})
		@next_state = nil

		@dialogmanager = DialogManager!
	
	init: =>
		@state\init!
	
	gotoNextState: =>
		@state\changeState(@next_state.state, @next_state.params)
		@next_state = nil
	
	update: =>	
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
		
		if @next_state
			print("next_state: #{@next_state}")
			print("state: #{@next_state.state.__name}")
			print("params: #{@next_state.params}")
			print("params unpacked: #{unpack(@next_state.params)}")
			for i in *@next_state.params
				print(i)
			print()
		
		if @next_state
			@\gotoNextState!
		
	draw: =>
		if @state
			@state\draw!
		if @dialogmanager.running
			@dialogmanager\draw!