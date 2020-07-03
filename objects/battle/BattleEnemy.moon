require "objects.battle.BattlePlayer"

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

	chooseTarget: =>
		indexes = {}
		for i, target in pairs @parent\inactiveEntities!
			continue if target == nil
			continue if not target\isValidTarget("attack")
			table.insert(indexes, i)
		targetindex = indexes[love.math.random(#indexes)]
		return targetindex

	attack: (target, damageOverride) =>
		damage = nil
		if damageOverride
			damage = damageOverride
		else
			damage = @stats.attack
		target\takeDamage(damage)

	enemyTurn: () =>
		-- Get a list of all the possible targets
		targetindex = @chooseTarget!
-- 		print("Attacking target " .. targetindex)
		damage = @stats.attack
		if @spaceDamage
			print "Enemy damage multi " .. @spaceDamage[targetindex]
			damage *= @spaceDamage[targetindex]
		attackScene = CutsceneAttack({tts:0.33, index:targetindex, damage:damage})
		@parent.cutscenes\addCutscene(attackScene)
		@parent.state\changeState(BattleTurnState, {ttl:0.66})

	getCursorPos: () =>
		return {
			x:@pos.x+3
			y:@pos.y-68
		}


export class BattleEnemyArcher extends BattleEnemy
	name: "Archer"
	new: (...) =>
		super ...
		@sprite = sprites.battle.archer_enemy

	-- Archer tries to hit the back lines
	chooseTarget: =>
		for i=4, 1, -1
			target = @parent\inactiveEntities![i]
			continue if target == nil
			continue if not target\isValidTarget("attack")
			if random(0,1) > 0.9
				print "skip"
				continue 
			return i

	spaceDamage: {
		0.5,
		0.7,
		0.9,
		1.0
	}

export class BattleEnemyLancer extends BattleEnemy
	name: "Lancer"
	new: (...) =>
		super ...
		@basestats.attack = 5
		@sprite = sprites.battle.lancer_enemy

	-- Lancer tries to hit the front lines
	chooseTarget: =>
		for i=1, 4, 1
			target = @parent\inactiveEntities![i]
			continue if target == nil
			continue if not target\isValidTarget("attack")
			if random(0,1) > 0.9
				print "skip"
				continue 
			return i

	spaceDamage: {
		1.0,
		0.9,
		0.7,
		0.5
	}