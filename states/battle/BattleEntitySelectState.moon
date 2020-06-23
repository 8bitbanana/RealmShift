require "states/state"
require "utils_vector"
Inspect = require "lib/inspect"

-- NOTE
-- To make a back out function - just make
-- pressing B restart the turn entirely
-- Don't bother with stacks and stuff
-- Keep everything the same - make a function
-- in GameBattleState that resets the turn
-- and make BattleEntitySelectState and friends
-- and call it when B is pressed 

export class BattleEntitySelectState extends State
	new: (@parent, @params) =>
		@selectedIndex = 1
		@cursor = nil
		@entities = nil
		@targetType = nil

	init: =>
		assert @entities != nil
		assert #@entities > 0
		@cursor = Cursor({x:0,y:0}, "down")
		if @params.selectedIndex
			@selectedIndex = @params.selectedIndex
			assert @isValidTarget(@selectedIndex)
		else
			for i, entity in pairs @entities
				if @isValidTarget i
					@selectedIndex = i
					break
		@moveCursor 0

	isValidTarget: (index) =>
		entity = @entities[index]
		if entity == nil
			return false
		else
			return entity\isValidTarget @targetType

	moveCursor: (dir) =>
		newindex = @selectedIndex
		while true
			newindex += dir
			break if newindex < 1
			break if newindex > #@entities
			break if @isValidTarget newindex
		if @isValidTarget newindex
			@selectedIndex = newindex
			@setCursor(newindex)
	
	setCursor: (index) =>
		entity = @entities[index]
		@cursor.pos = entity\getCursorPos!

	confirm: () =>
		@parent\selectionCallback(@selectedIndex)

	update: =>
		@cursor\update!
		@moveCursor(-1) if input\pressed("left")
		@moveCursor(1) if input\pressed("right")
		@confirm! if input\pressed("confirm")
		@parent\turnStart! if input\pressed("back")

	draw: =>
		@cursor\draw!

export class BattleEnemySelectState extends BattleEntitySelectState
	init: =>
		@entities = @parent.enemies
		@targetType = "attack"
		super!

export class BattleSpaceSelectState extends BattleEntitySelectState
	init: =>
		@entities = @parent.players
		@startindex = nil
		if @params.selectedspace != nil
			@startindex = @params.selectedspace
			@startpos = {
				x: 104+28*@params.selectedspace
				y: 94
			}
		super!

	setCursor: (index) =>
		@cursor.pos = {
			x: 92+28*index
			y: 78
		}

	isValidTarget: (index) =>
		return false if index < 1
		return false if index > 4
		return false if index == @startindex
		return true

	drawarc: () =>
		startpos = @startpos
		endpos = vector.add(@cursor.pos, {x:12,y:6})
		endpos.y += math.floor(@cursor.posoffset.y)
		control1 = startpos
		control2 = endpos
		if startpos.x > endpos.x
			control1 = vector.add(control1, {x:-5,y:-20})
			control2 = vector.add(control2, {x:5,y:-20})
		else
			control1 = vector.add(control1, {x:5,y:-20})
			control2 = vector.add(control2, {x:-5,y:-20})
		points = {}
		STEPS = 8
		for i=0, STEPS
			progress = i/STEPS
			point = vector.bezier3(
				startpos, control1, control2, endpos, progress
			)
			table.insert(points, point.x)
			table.insert(points, point.y)
		lg.setColor(BLACK)
		lg.line(points)
	
	draw: =>
		@drawarc! if @startindex != nil
		@cursor\draw!


export class BattlePlayerSelectState extends BattleEntitySelectState
	init: =>
		@entities = @parent.players
		@targetType = "always"
		@targetType = @params.targetType if @params.targetType
		super!