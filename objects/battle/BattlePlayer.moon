DAMAGE_FORMULA = {
	aw: 1 -- attack weight
	dw: 1.2 -- defence weight
	bd: 5, -- base damage
	vm: 0.25 -- variance multiply
	va: 2 -- variance addition
}

Inspect = require("lib/inspect")

export class BattlePlayer
	name: "BattlePlayer"
	new: ()=>
		@parent = nil
		@timer = Timer!
		@pos = {x:0,y:0}
		@color = {1,1,1, 1}
		@basestats = {
			hp: 0,
			attack: 0,
			defence: 0,
			speed: 0,
			magic: 0
		}
		@buffs = {
			rally: false,
			poison: false
		}
		@dead = false
		@size = {w:24, h:32}
		@sprite = sprites.battle.main_char

	init: () =>
		@stats = table.shallow_copy(@basestats)
		@hp = @stats.hp

	-- Using incomingattack, run the damage formula and
	-- reduce @hp by that amount.
	-- Return the amount of hp lost
	takeDamage: (incomingattack) =>
		damage = math.floor((DAMAGE_FORMULA.va+(DAMAGE_FORMULA.vm*((incomingattack*DAMAGE_FORMULA.aw)-(@stats.defence*DAMAGE_FORMULA.dw)))) * DAMAGE_FORMULA.bd)
		damage = 1 if damage < 1
		@hp -= damage
		print("I took " .. damage .. " damage ("..incomingattack.."ATK "..@stats.defence.."DEF)")
		if @hp < 0
			@\die!
		return damage

	die: =>
		@hp = 0
		@dead = true

		-- Animate death fade-out
		@timer\tween(1, @, {color: {1,0,0, 0}}, 'out-sine')

	-- Run @takedamage on target, according to attack
	-- Override the damage if needed for a skill
	-- Apply any damage increasing/reducing buffs
	attack: (target, damageOverride) =>
		damage = nil
		if damageOverride
			damage = damageOverride
		else
			damage = @stats.attack
		damage *= 1.1 if @buffs.rally

		target\takeDamage(damage)

	-- Skill metadata, to be overridden
	skillPrimaryInfo: () => return {
		name: "SKILLPRIMARY"
		desc: "Base primary skill"
		valid: () => return false
	}
	skillSecondaryInfo: () => return {
		name: "SKILLSECONDARY"
		desc: "Base secondary skill"
		valid: () => return false
	}

	-- Do primary/secondary skills, to be overridden
	skillPrimary: () =>
	skillSecondary: () =>

	-- Return if I am a valid target for stuff
	isValidTarget: (targetType) =>
		switch targetType
			when "attack"
				return @hp > 0
			when "move"
				return @hp > 0
			when "always"
				return true
			else
				error("isValidTarget - Invalid target type - " .. targetType)

	-- Return x,y pos of where the cursor should be
	-- (usually above my head)
	getCursorPos: () =>
		return {
			x:@pos.x+0
			y:@pos.y-49
		}

	draw: () =>
		if @dead
			@draw_dead!
		else
			@draw_alive!
			@draw_health!

	-- Draw a health tracker below me
	draw_health: () =>
-- 		lg.printf(@hp, @pos.x+2, @pos.y, 20, "left")
-- 		lg.printf(@stats.hp, @pos.x+2, @pos.y+12, 20, "right")
		hp = @hp
		max_hp = @basestats.hp
		max_len = @size.w
		len = (hp/max_hp)*max_len
		x = @pos.x
		y = @pos.y

		-- Health Bar
		lg.setColor(BLACK)
		lg.rectangle("fill", x, y+5, max_len, 2)
		lg.setColor(RED)
		lg.rectangle("fill", x-1, y+4, len, 2)
		lg.setColor(WHITE)

		-- Health Numbers
		shadowPrint(max_hp, x+12, y+16)
-- 		shadowPrint("/", x+6, y+10)
		shadowPrint(hp, x, y+8)

	-- Draw call if alive
	draw_alive: () =>
		if @sprite
			@sprite.color = @color
			@sprite\draw(@pos.x, @pos.y)
		else
			lg.setColor(RED)
			lg.rectangle("fill", @pos.x, @pos.y-@size.h, @size.w, @size.h)
			lg.setColor(BLACK)
			lg.rectangle("line", @pos.x, @pos.y-@size.h, @size.w, @size.h)

	draw_dead: () =>
		if @sprite
			lg.setBlendMode("add")
			@sprite.color = @color
			@sprite\draw(@pos.x, @pos.y)
			lg.setBlendMode("alpha")
		else
			lg.setColor(GRAY)
			lg.rectangle("fill", @pos.x, @pos.y-@size.h, @size.w, @size.h)
			lg.setColor(BLACK)
			lg.rectangle("line", @pos.x, @pos.y-@size.h, @size.w, @size.h)


export class Mage extends BattlePlayer
	name: "Mage"
	new: (...) =>
		super ...
		@basestats.hp = 50
		@basestats.attack = 100--3
		@basestats.defence = 2
		@basestats.speed = 5
		@basestats.magic = 10
		@init!

	draw_alive: () =>
		lg.setColor(MAGE_COL)
		super false

export class Fighter extends BattlePlayer
	name: "Fighter"
	new: (...) =>
		super ...
		@sprite = sprites.battle.artificer_char
		-- Sprite does not match class but is temporary until classes are finalised
		@basestats.hp = 50
		@basestats.attack = 100--8
		@basestats.defence = 4
		@basestats.speed = 7
		@basestats.magic = 2
		@init!

	-- Lunge - shoves forwards as far as you can,
	-- dealing more damage with a bigger lunge
	skillPrimaryInfo: => return {
		name:"LUNGE",
		desc:"Lunge forward as far as you can, dealing more damage with a bigger lunge."
	}
	skillPrimary: () =>
		myindex = nil
		for i, player in pairs @parent.players
			myindex = i if player == @
		assert myindex != nil
		damage = @stats.attack * myindex / 2

		@parent.selectionCallback = (index) =>
			shovescene = CutsceneShove({tts:0, dir:-4})
			attackscene = CutsceneAttack({tts:0.1, index:index, damage:damage})
			@cutscenes\addCutscene(shovescene)
			@cutscenes\addCutscene(attackscene)
			@state\changeState(BattleTurnState, {ttl:0.5})
		@parent.state\changeState(BattleEnemySelectState)

	-- Reposition - swap two allies places
	skillSecondaryInfo: () => return {
		name:"REPOSITION",
		desc:"Swap the position of two allies, or move an ally to an empty space."
	}
	skillSecondary: () =>
		myindex = nil
		for i, player in pairs @parent.players
			myindex = i if player == @
		assert myindex != nil
		@parent.selectionCallback = (firstindex) =>
			@selectionCallback = (secondindex) =>
				currentSpace = firstindex
				assert currentSpace != nil
				assert secondindex <= 4
				swapscene = CutsceneSwap({tts:0.033, type:"player", firstindex:firstindex, secondindex:secondindex})
				@cutscenes\addCutscene(swapscene)
				@state\changeState(BattleTurnState, {ttl:0.5})
			@state\changeState(BattleSpaceSelectState, {selectedspace:firstindex})
		@parent.state\changeState(BattlePlayerSelectState, {selectedIndex:myindex})

	draw_alive: () =>
		lg.setColor(FIGHTER_COL)
		super false

export class Paladin extends BattlePlayer
	name: "Paladin"
	new: (...) =>
		super ...
		@sprite = sprites.battle.paladin_char
		@basestats.hp = 50
		@basestats.attack = 100--5

		@basestats.defence = 8
		@basestats.speed = 3
		@basestats.magic = 6
		@init!

	-- Rally - apply a small damage and speed buff
	-- to all allies
	skillPrimaryInfo: () => return {name:"RALLY"}
	skillPrimary: () =>


	draw_alive: () =>
		lg.setColor(PALADIN_COL)
		super false

export class Rogue extends BattlePlayer
	name: "Rogue"
	new: (...) =>
		super ...
		@basestats.hp = 50
		@basestats.attack = 9
		@basestats.defence = 2
		@basestats.speed = 8
		@basestats.magic = 2
		@init!

	draw_alive: () =>
		lg.setColor(ROGUE_COL)
		super false
