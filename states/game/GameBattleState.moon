require "states/state"
Inspect = require "lib/inspect"

WRAP_PLAYER_CURSOR = false

export class GameBattleState extends State
	new: (@parent, @rx=0, @ry=0, @bg=backgrounds.desert) =>
		-- @rx and @ry are the return positions for the player to return to
		-- on the overworld map after the battle is won
		print(@rx, @ry)

		@players = {nil,nil,nil,nil}
		@enemies = {nil}
		@selectedSpace = 1

		@state = nil

		@enemyPosData = {}
		@indexItemToUse = nil

		@aniObjs = ObjectManager!
		@cutscenes = BattleCutsceneManager(@)

		-- type is player or enemy
		@turndata = {type:nil, index:0}
		@initiative = {}
		@initiativeIndex = 0

		@selectionCallback = ()->
		@dialogCallback = ()->

	updateEntityIndexes: (type, oldindex, newindex) =>
		if @turndata.type == type and oldindex == @turndata.index
			@turndata.index = newindex
		for i,initiative in pairs @initiative
			if initiative.type == type and initiative.index == oldindex
				@initiative[i].index = newindex
				break

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
		@players = @parent.party
		for player in *@players
			player.parent = @ if player != nil
		@calculatePlayerPos!

		@enemies = {
-- 			BattleEnemy!
-- 			BattleEnemy!
-- 			BattleEnemy!
			BattleEnemyArcher!
			BattleEnemyLancer!
		}
		for enemy in *@enemies
			enemy.parent = @ if enemy != nil
		@calculateEnemyPos!

		@calculateInitiative!
		@getNextInitiative true
		@state\changeState(TurnIntroState)

	calculatePlayerPos: =>
		for i, player in pairs @players
			player.pos = @getPlayerIndexPos i

	getPlayerIndexPos: (i) =>
		return {
			x: 97+28*i
			y: 127
		}

	calculateEnemyPos: =>
		totalEnemyWidth = 0
		enemyCount = 0
		for enemy in *@enemies
			totalEnemyWidth += enemy.size.w
			enemyCount += 1

		leftPadding = 5
		leftPadding = 10 if (totalEnemyWidth < 90)

		extraSpace = 110 - leftPadding - totalEnemyWidth
		assert(extraSpace >= 0)
		gap = math.floor(extraSpace / enemyCount)
		gap = 10 if gap > 10

		currentX = leftPadding
		for i, enemy in pairs @enemies
			enemy.pos = {
				x: currentX,
				y: 127
			}
			@enemyPosData[i] = enemy.pos
			currentX += enemy.size.w
			currentX += gap

	getEnemyIndexPos: (i) =>
		return @enemyPosData[i]

	turnEnd: () =>
		@getNextInitiative true
		@state\changeState(TurnIntroState)

	turnStart: () =>
		switch @turndata.type
			when "player"
				@state\changeState(BattleMenuState)
			when "enemy"
				@enemyTurn!

	calculateInitiative: =>
		@initiative = {}
		for i, player in pairs @players
			table.insert(@initiative, {
				speed: player.stats.speed,
				index: i,
				type: "player",
				entity: player
			})
		for i, enemy in pairs @enemies
			table.insert(@initiative, {
				speed: enemy.stats.speed,
				index: i,
				type: "enemy",
				entity: enemy
			})
		sortfunc = (a, b) ->
			return a.speed > b.speed
		table.sort(@initiative, sortfunc)
		@printInitiative!

	printInitiative: =>
		for i,v in pairs @initiative
			print("#{i} T:#{v.type} I:#{v.index} S:#{v.speed}")

	getNextInitiative: (apply=false)=>
		nextIndex = @initiativeIndex + 1
		nextIndex = 1 if nextIndex > #@initiative
		while @initiative[nextIndex].entity.dead -- dead people don't get a turn, wild I know
			nextIndex += 1
			nextIndex = 1 if nextIndex > #@initiative
			if nextIndex == @initiativeIndex
				error "Everyone is dead - initiative has looped"
		nextInitiative = @initiative[nextIndex]
		if apply
			@initiativeIndex = nextIndex
			@turndata = {
				type: nextInitiative.type,
				index: nextInitiative.index
			}
		return nextInitiative.entity


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
			swapscene = CutsceneSwap({tts:0.033, type:"player", firstindex:@currentTurnIndex.index,secondindex:index})
			@cutscenes\addCutscene(swapscene)
			@state\changeState(BattleTurnState, {ttl:0.5})
		@state\changeState(BattleSpaceSelectState, {selectedspace:@currentTurnIndex.index})

	itemAction: () =>
		@selectionCallback = (index) =>
			item = game.inventory.items[index]
			@indexItemToUse = index
			switch item.use_target
				when "player"
					@selectionCallback = (index) =>
						target = @players[index]
						item = game.inventory.items[@indexItemToUse]
						usable, message = item\is_usable_on_target(target)
						if usable
							message = game.inventory\useItem(@indexItemToUse, target)
							tree = DialogTree({
								DialogBox(message)
							})
							@dialogCallback = () =>
								@turnEnd!
							@state\changeState(BattleDialogState, {tree:tree})
						else
							tree = DialogTree({
								DialogBox(message)
							})
							@dialogCallback = () =>
								-- @selectionCallback is still this function, goes back
								@state\changeState(BattlePlayerSelectState)
							@state\changeState(BattleDialogState, {tree:tree})
					@state\changeState(BattlePlayerSelectState)
				when "none"
					--stub
					item = game.inventory.items[@indexItemToUse]
					message = game.inventory\useItem(@indexItemToUse)
					@state\changeState(BattleTurnState, {ttl:0.5})
		@state\changeState(BattleItemSelectState)

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

	updateTimers: =>
		-- Update Player's and Enemie's Timers
		-- Used for animating opacity & other tweens
		for p in *@players
			if p
				if p.timer
					p.timer\update(dt)
		for e in *@enemies
			if e
				if e.timer
					e.timer\update(dt)

	update: =>
		@\updateTimers!

		@state\update!
		@cutscenes\update!
		@aniObjs\updateObjects!
		@aniObjs\checkDestroyed!

		-- Check if battle has been won, then return to the overworld if true
		if @\checkWon!
			-- Gold drops currently random
			gold = math.random(0, 100)
			-- Item drops currently fixed
			drops = {Potion!, Potion!}
			-- Random gold drops feels fine but maybe we want
			-- certain percentage drop rates for items per enemy type
			@state\changeState(BattleWinState,
			{rx:@rx, ry:@ry, gold:gold, drops:drops})

		-- To-do: what happens if the player loses?
		-- Suggestion: They lose gold and return to previous town
		elseif @\checkLost!
			print("You died chump")
			game.next_state = {state: GameOverworldState, params: {@rx, @ry}}
			-- ^^^^^ This will be changed to transition to a game over state
			-- or save game reload state etc.

	drawBackground: =>
		lg.draw(@bg, 0,0)

		-- Translucent background bar
		lg.setColor({0,0,0,0.5})
		lg.rectangle("fill", 0,GAME_HEIGHT-24, GAME_WIDTH,24)

	draw: =>
-- 		lg.setColor(0.28,0.81,0.81,1)
-- 		lg.rectangle("fill",0,0,GAME_WIDTH,GAME_HEIGHT) -- sky
-- 		lg.setColor(0.25,0.63,0.22,1)
-- 		lg.rectangle("fill",0,127,GAME_WIDTH, 53) -- grass
		@\drawBackground!

		for player in *@players
				player\draw! if player
		for enemy in *@enemies
				enemy\draw! if enemy
		@state\draw!
		@aniObjs\drawObjects!
		@cutscenes\draw!
