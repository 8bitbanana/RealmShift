Inspect = require("lib/Inspect")

export class BattleCutsceneManager
	new: (@parent) =>
		@cutscenes = {}

	addCutscene: (cutscene) =>
		cutscene.root = @parent
		cutscene\init!
		table.insert(@cutscenes, cutscene)

	update: =>
		for i, cutscene in pairs @cutscenes
			if cutscene.done
				table.remove(@cutscenes, i)
			else
				cutscene\update!

	draw: =>
		for cutscene in *@cutscenes
			cutscene\draw!

export class BattleCutscene
	new: (@args={}) =>
		@root = nil
		@started = false
		@done = false
		@tts_max = 0
		@ttl_max = 0.16

	init: =>
		assert @root != nil
		@tts_max = @args.tts if @args.tts
		@ttl_max = @args.ttl if @args.ttl
		@tts = @tts_max
		@ttl = @ttl_max

	progress: =>
		return 0 if not @started
		return 1 if @done
		return 1-(@ttl / @ttl_max)

	sceneStart: =>

	sceneUpdate: =>

	sceneFinish: =>

	draw: =>

	update: ()=>
		if @started
			@ttl-=dt
			if @ttl <= 0
				@sceneFinish!
				@done = true
			if not @done
				@sceneUpdate!
		else
			@tts -=dt
			if @tts <= 0
				@started = true
				@sceneStart!

-- Display a single dialog box
-- Visual only
export class CutsceneDialog extends BattleCutscene
	new: (...) =>
		super ...
		@ttl_max = 1

	sceneStart: =>
		@dialog = DialogBox(@args.text)
	
	sceneUpdate: =>
		@dialog\update! if @dialog

	sceneFinish: =>
		@dialog\clearCanvas!
		@dialog = nil

	draw: =>
		@dialog\draw! if @dialog

-- currentTurn attacks player/enemy at @args.index
export class CutsceneAttack extends BattleCutscene
	new: (...) =>
		super ...
		@ttl_max = 0.16
		@attacked = false

	sceneUpdate: =>
		if @ttl <= 0.13 and not @attacked
			@attacked = true
			damage = @root\currentTurn!\attack(@root\inactiveEntities![@args.index], @args.damage)
			pos = @root\inactiveEntities![@args.index]\getCursorPos!
			particle = BattleDamageNumber(pos, damage)
			@root.aniObjs\addObject(particle)
		-- Fancy slash graphics to go here

	sceneFinish: =>

export class CutsceneHail extends BattleCutscene
	new: (...) =>
		super ...
		@ttl_max = 2
		@cooldown = 0

	sceneStart: =>

	sceneUpdate: =>
		if @cooldown <= 0
			pos = {
				x:math.floor(random(110,247)),
				y:math.floor(random(-40,0))
			}
			particle = BattleHail(pos)
			@root.aniObjs\addObject(particle)
			@cooldown = 2
		else
			@cooldown -= 1

	sceneFinish: =>

-- To be used with CutsceneShove
-- Bubbles the target, lifting them up for the duration
export class CutsceneBubbleRise extends BattleCutscene
	new: (...) =>
		super ...
		@ttl_max = 1

	sceneStart: =>
		@edges = {
			top: {x:0, y:-20}
			bottom: {x:0, y:0}
		}
		
		@offset = {x:0, y:0}

	sceneUpdate: =>
		@args.target.pos = vector.add(@args.target.pos, @offset)
		if @progress! < 0.5
			prog = @progress!
			prog = math.sin(prog*PI)
			@offset = vector.lerp(@edges.bottom, @edges.top, prog)
		else
			prog = @progress!-0.5
			prog = math.sin(prog*PI)
			@offset = vector.lerp(@edges.top, @edges.bottom, prog)

	sceneFinish: =>

export class CutsceneBuff extends BattleCutscene
	new: (...) =>
		super ...
		@ttl = 0.16

	sceneStart: =>
		if @args.entities
			@entities = @args.entities
			assert @entities != nil
		else if @args.target
			@target = @args.target
			assert @target != nil
		else
			error "Neither entities/target specified"

	sceneUpdate: =>

	sceneFinish: =>
		if @target
			assert @target.buffs[@args.buff] != nil
			@target.buffs[@args.buff] = true
		else if @entities
			for entity in *@entities
				continue if not entity
				assert entity.buffs[@args.buff] != nil
				entity.buffs[@args.buff] = true



-- @args.index shoves forwards as far as it can in @args.dir direction
-- Other players are shoved in the opposite direction to make room
-- Todo - convert to work on enemies
export class CutsceneShove extends BattleCutscene
	new: (...) =>
		super ...
		@ttl = 0.40
		@moves = {}

	sceneStart: =>
		assert(@root.turndata.type == "player")
		oldindex = @args.index or @root.turndata.index
		newindex = oldindex + @args.dir
		newindex = 1 if newindex < 1
		newindex = 4 if newindex > 4
		shovestart = newindex
		shoveend = nil
		shovedir = nil
		if @args.dir < 0 -- shove forwards
			for i=shovestart, 4
				if @root.players[i] == nil or i == oldindex
					shoveend = i
					break
			shovedir = 1
		else       -- shove backwards
			for i=shovestart, 1, -1
				if @root.players[i] == nil or i == oldindex
					shoveend = i
					break
			shovedir = -1
		assert shovestart != nil
		assert shoveend != nil
		@moves = {{oldindex, newindex}}
		for i=shovestart, shoveend-shovedir, shovedir
			if @root.players[i] != nil
				table.insert(@moves, {i, i+shovedir})

	sceneUpdate: =>
		for move in *@moves
			oldindex, newindex = move[1], move[2]
			oldpos = @root\getPlayerIndexPos(oldindex)
			newpos = @root\getPlayerIndexPos(newindex)
			@root.players[oldindex].pos = vector.lerp(oldpos, newpos, @progress!)

	sceneFinish: =>
		newPlayers = {nil,nil,nil,nil}
		for index=1, 4
			continue if @root.players[index] == nil
			newindex = index
			for move in *@moves
				if move[1] == index
					newindex = move[2]
					@root\updateEntityIndexes("player", move[1], move[2])
					break
			newPlayers[newindex] = @root.players[index]
		@root.players = newPlayers
		@root\calculatePlayerPos!

-- Swaps players at @args.firstindex and @args.secondindex
export class CutsceneSwap extends BattleCutscene
	new: (...) =>
		super ...
		@ttl = 0.40

	sceneStart: =>
		@entities = nil
		@entities = @root.players if @args.type == "player"
		@entities = @root.enemies if @args.type == "enemy"
		assert @entities != nil

		@playerA = @entities[@args.firstindex]
		@playerB = @entities[@args.secondindex]
		assert @args.firstindex != @args.secondindex

		if @playerA
			@posA = @playerA.pos
		else
			@posA = @root\getPlayerIndexPos(@args.firstindex) if @args.type == "player"
			@posA = @root\getEnemyIndexPos(@args.firstindex) if @args.type == "enemy"
		if @playerB
			@posB = @playerB.pos
		else
			@posB = @root\getPlayerIndexPos(@args.secondindex) if @args.type == "player"
			@posB = @root\getEnemyIndexPos(@args.secondindex) if @args.type == "enemy"

	sceneUpdate: =>
		if @playerA != nil
			@playerA.pos = vector.lerp(@posA, @posB, @progress!)
		if @playerB != nil
			@playerB.pos = vector.lerp(@posB, @posA, @progress!)

	sceneFinish: =>
		@entities[@args.firstindex], @entities[@args.secondindex] = @entities[@args.secondindex], @entities[@args.firstindex]
		-- if @playerA != nil
		-- 	@root\updateEntityIndexes(@args.type, @args.firstindex, @args.secondindex)
		-- if @playerB != nil
		-- 	@root\updateEntityIndexes(@args.type, @args.secondindex, @args.firstindex)
		@root\swapEntityIndexes(@args.type, @args.firstindex, @args.secondindex)
		@root\calculatePlayerPos! if @args.type == "player"
		@root\calculateEnemyPos! if @args.type == "enemy"
