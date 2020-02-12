
export class Game
	new: () =>
		@state = GameExploreState(@)

		@dialogmanager = DialogManager!
	
	init: =>
		@state\init!
	
	update: =>
		if @state
			@state\update!
		@dialogmanager\update!

		if input\pressed "dialogdebug"
			if @dialogmanager.running
				@dialogmanager\advanceInput!
			else
				@dialogmanager\push(DialogBox("This is a test of the {color,1,0,0,1,6}{wave,6}dialog box{pause,30}\nIt seems to work fairly well so far,\nalthough I did have to edit {colour,0,0,1,1,8}Push.lua.\n3\n4 test input{input}wow\n5\n6\n{wave,4}Wow!"))
		
	draw: =>
		if @state
			@state\draw!
		if @dialogmanager.running
			@dialogmanager\draw!