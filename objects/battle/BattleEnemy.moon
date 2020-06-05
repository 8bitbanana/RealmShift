require "objects/battle/BattlePlayer"

-- @pos is the bottom left to accomadate different sizes

export class BattleEnemy extends BattlePlayer
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
		print("Attacking target " .. targetindex)
		attackScene = CutsceneAttack({tts:20, index:targetindex})
		@parent.cutscenes\addCutscene(attackScene)
		@parent.state\changeState(BattleTurnState, {ttl:40})

	getCursorPos: () =>
		return {
			x:@pos.x+3
			y:@pos.y-68
		}

	draw_alive: () =>
		lg.setColor(RED)
		lg.rectangle("fill", @pos.x, @pos.y-@size.h, @size.w, @size.h)
		lg.setColor(BLACK)
		lg.rectangle("line", @pos.x, @pos.y-@size.h, @size.w, @size.h)

	draw_dead: () =>
		lg.setColor(GRAY)
		lg.rectangle("fill", @pos.x, @pos.y-@size.h, @size.w, @size.h)
		lg.setColor(BLACK)
		lg.rectangle("line", @pos.x, @pos.y-@size.h, @size.w, @size.h)