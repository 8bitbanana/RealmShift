require "states/state"
require "utils_vector"
Inspect = require "lib/Inspect"

export class BattleCutsceneState extends State
    new: (@parent, @args) =>
        @callback = callback
        @done = false
        @currentTime = 0

    init: =>
        @totalTime = 60

    incTime: =>
        if @currentTime >= @totalTime
            @parent\cutsceneCallback @args.index
            @done = true
        @currentTime += 1
        

export class BCPlayerAttackState extends BattleCutsceneState
    new: (...) =>
        super ...

    init: =>
        @totalTime = 30
        @attacked = false

    update: =>
        @incTime!
        return if @done
        if @currentTime > 15 and not @attacked
            @attacked = true
            @parent\cutsceneAttackCallback!


export class BCMoveState extends BattleCutsceneState
    new: (...) =>
        super ...

    init: =>
        @totalTime = 25
        @playerA = @parent.currentTurn
        @playerB = @parent.players[@args.index]
        assert @playerA != @playerB
        @posA = @playerA.pos
        if @playerB
            @posB = @playerB.pos
        else
            @posB = @parent\getPlayerIndexPos(@args.index)

    update: =>
        @incTime!
        return if @done
        progress = @currentTime / @totalTime
        @playerA.pos = vector.lerp(@posA, @posB, progress)
        if @playerB != nil
            @playerB.pos = vector.lerp(@posB, @posA, progress)
        
