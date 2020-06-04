require "states/state"
Inspect = require "lib/inspect"

WRAP_PLAYER_CURSOR = false

export class GameBattleState extends State
	new: (@parent, @rx=0, @ry=0) =>
		-- @rx and @ry are the return positions for the player to return to
		-- on the overworld map after the battle is won
		print(@rx, @ry)

		@players = {nil,nil,nil,nil}
		@enemies = {nil}
		@selectedSpace = 1

		@state = nil

		@aniObjs = ObjectManager!
		@cutscenes = BattleCutsceneManager(@)

		-- type is player or enemy
		@turndata = {type:nil, index:0}

		@selectionCallback = ()->
		@cutsceneCallback = ()->

	activeEntities: =>
		switch @turndata.type
			when "player"
				return @players
			when "enemy"
				return @enemies
			else
				return nil

	inactiveEntities: =>
		switch @turndata.type
			when "enemy"
				return @players
			when "player"
				return @enemies
			else
				return nil

	currentTurn: =>
		entities = @activeEntities!
		return nil if entities == nil
		return @activeEntities![@turndata.index]

	init: =>
		-- BattlePlayer position is the bottom-left of the sprite
		@state = State(@)
		@players = {
				Paladin(@, {x:120,y:127}), -- player x is 92+28*i
				Fighter(@, {x:148,y:127}),
				nil,
				Mage(@, {x:204,y:127}),
		}
		@calculatePlayerPos!

		@enemies = {
			BattleEnemy(@, {x:10,y:127})
			BattleEnemy(@, {x:50,y:127})
		}

		@getNextInitiative true
		@state\changeState(TurnIntroState)

	calculatePlayerPos: =>
		for i, player in pairs @players
			player.pos = @getPlayerIndexPos i

	getPlayerIndexPos: (i) =>
		return {
			x: 92+28*i
			y: 127
		}

	turnEnd: () =>
		@getNextInitiative true
		@state\changeState(TurnIntroState)

	turnStart: () =>
		switch @turndata.type
			when "player"
				@state\changeState(BattleMenuState)
			when "enemy"
				@enemyTurn!

	getNextInitiative: (apply=false)=>
		nextup = nil
		nextupSpeed = -999
		nextupData = {type:nil, index:0}
		nextup_all = nil
		nextup_allSpeed = -999
		nextup_allData = {type:nil, index:0}

		currentTurnSpeed = 999
		currentTurnSpeed = @currentTurn!.stats.speed if @currentTurn! != nil

		for index, player in pairs @players
			continue if player == nil
			if player.stats.speed > nextupSpeed and player.stats.speed < currentTurnSpeed
				nextup = player
				nextupSpeed = player.stats.speed
				nextupData = {type:"player", index:index}
			if player.stats.speed > nextup_allSpeed
				nextup_all = player
				nextup_allSpeed = player.stats.speed
				nextup_allData = {type:"player", index:index}
		for index, enemy in pairs @enemies
			continue if enemy == nil
			if enemy.stats.speed > nextupSpeed and enemy.stats.speed < currentTurnSpeed
				nextup = enemy
				nextupSpeed = enemy.stats.speed
				nextupData = {type:"enemy", index:index}
			if enemy.stats.speed > nextup_allSpeed
				nextup_all = enemy
				nextup_allSpeed = enemy.stats.speed
				nextup_allData = {type:"enemy", index:index}
		if nextup == nil
			@turndata = nextup_allData if apply
			return nextup_all
		else
			@turndata = nextupData if apply
			return nextup


	attackAction: () =>
		@selectionCallback = (index) =>
			attackscene = CutsceneAttack({tts:0.1, index:index})
			@cutscenes\addCutscene(attackscene)
			@state\changeState(BattleTurnState, {ttl:0.33})
		@state\changeState(BattleEnemySelectState)

	enemyTurn: () =>
		@currentTurn!\enemyTurn!

	skillAction: () =>
		@state\changeState(BattleSkillSelectState)

	waitAction: () =>
		@state\changeState(BattleTurnState, {ttl:0.5})

	swapAction: () =>
		@selectionCallback = (index) ->
			currentSpace = @currentTurnIndex.index
			assert currentSpace != nil
			assert index <= 4
			swapscene = CutsceneSwap({tts:0.033, firstindex:@currentTurnIndex.index,secondindex:index})
			@cutscenes\addCutscene(swapscene)
			@state\changeState(BattleTurnState, {ttl:0.5})
		@state\changeState(BattleSpaceSelectState, {selectedspace:@currentTurnIndex.index})

	selectedPlayer: =>
		return @players[@selectedSpace]

	checkDead: (tbl) =>
		for o in *tbl
			if o ~= nil
				if o.dead == false
					return false
		return true

	checkWon: =>
		if @state.__class.__name == "TurnIntroState" and @\checkDead(@enemies)
			return true
		return false

	checkLost: =>
		@\checkDead(@players)

	update: =>
		@state\update!
		@cutscenes\update!
		@aniObjs\updateObjects!
		@aniObjs\checkDestroyed!

		-- Check if battle has been won, then return to the overworld if true
		if @\checkWon!
			game.next_state = {state: GameOverworldState, params: {@rx, @ry}}

		-- To-do: what happens if the player loses?
		-- Suggestion: They lose gold and return to previous town
		elseif @\checkLost!
			print("You died chump")
			game.next_state = {state: GameOverworldState, params: {@rx, @ry}}
			-- ^^^^^ This will be changed to transition to a game over state
			-- or save game reload state etc.

	draw: =>
		lg.setColor(0.28,0.81,0.81,1)
		lg.rectangle("fill",0,0,GAME_WIDTH,GAME_HEIGHT) -- sky
		lg.setColor(0.25,0.63,0.22,1)
		lg.rectangle("fill",0,127,GAME_WIDTH, 53) -- grass
		for player in *@players
				player\draw! if player
		for enemy in *@enemies
				enemy\draw! if enemy
		@state\draw!
		@aniObjs\drawObjects!
