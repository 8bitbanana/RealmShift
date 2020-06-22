require "objects/battle/BattlePlayer"

-- @pos is the bottom left to accomadate different sizes

export class BattleEnemy extends BattlePlayer
	name: "BattleEnemy"
	new: (...) =>
		super ...
		@basestats.hp = 100
		@basestats.attack = 3
		@basestats.defence = 4
		@basestats.speed = 2
		@size = {w:30, h:48}
		@init!

	enemyTurn: () =>
		-- Get a list of all the possible targets
		indexes = {}
		for i, target in pairs @parent\inactiveEntities!
			continue if target == nil
			continue if not target\isValidTarget("attack")
			table.insert(indexes, i)
		targetindex = indexes[love.math.random(#indexes)]
-- 		print("Attacking target " .. targetindex)
		attackScene = CutsceneAttack({tts:0.33, index:targetindex})
		@parent.cutscenes\addCutscene(attackScene)
		@parent.state\changeState(BattleTurnState, {ttl:0.66})

	getCursorPos: () =>
		return {
			x:@pos.x+3
			y:@pos.y-68
		}

-- 	draw_alive: () =>
-- 		if @sprite
-- 			@sprite\draw(@pos.x, @pos.y)
-- 		else
-- 			lg.setColor(RED)
-- 			lg.rectangle("fill", @pos.x, @pos.y-@size.h, @size.w, @size.h)
-- 			lg.setColor(BLACK)
-- 			lg.rectangle("line", @pos.x, @pos.y-@size.h, @size.w, @size.h)

-- 	draw_dead: () =>
-- 		if @sprite
-- 			lg.setColor({1,1,1,@opacity})
-- 			@sprite\draw(@pos.x, @pos.y)
-- 		else
-- 			lg.setColor(GRAY)
-- 			lg.rectangle("fill", @pos.x, @pos.y-@size.h, @size.w, @size.h)
-- 			lg.setColor(BLACK)
-- 			lg.rectangle("line", @pos.x, @pos.y-@size.h, @size.w, @size.h)


export class BattleEnemyArcher extends BattleEnemy
	name: "Archer"
	new: (...) =>
		super ...
		@sprite = sprites.battle.archer_enemy

export class BattleEnemyLancer extends BattleEnemy
	name: "Lancer"
	new: (...) =>
		super ...
		@sprite = sprites.battle.lancer_enemy
