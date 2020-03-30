Inspect = require("lib/Inspect")

export class BattleTurnState extends State
    new: (@parent, @args) =>

    init: () =>
        @ttl = @args.ttl
        @done = false

    update: () =>
        @ttl -= 1 if not @done
        if @ttl <= 0 and not @done
            @done = true
            @parent\turnEnd!

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

export class BattleCutscene
    new: (@args) =>
        @root = nil
        @started = false
        @done = false
        @tts_max = 10
        @ttl_max = 10

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

    update: ()=>
        if @started
            @ttl-=1
            if @ttl == 0
                @sceneFinish!
                @done = true
            if not @done
                @sceneUpdate!
        else
            @tts -=1
            if @tts <= 0
                @started = true 
                @sceneStart!

export class CutsceneAttack extends BattleCutscene
    new: (...) =>
        super ...
        @ttl = 8

    sceneUpdate: =>
        -- Fancy slash graphics to go here

    sceneFinish: =>
        @root.currentTurn\attack(@root.enemies[@args.index])

export class CutsceneSwap extends BattleCutscene
    new: (...) =>
        super ...
        @ttl = 25

    sceneStart: =>
        @playerA = @root.currentTurn
        @playerB = @root.players[@args.index]
        assert @playerA != @playerB
        @posA = @playerA.pos
        if @playerB
            @posB = @playerB.pos
        else
            @posB = @root\getPlayerIndexPos(@args.index)

    sceneUpdate: =>
        @playerA.pos = vector.lerp(@posA, @posB, @progress!)
        if @playerB != nil
            @playerB.pos = vector.lerp(@posB, @posA, @progress!)

    sceneFinish: =>
        @root.players[@root.currentTurnIndex.index], @root.players[@args.index] = @root.players[@args.index], @root.players[@root.currentTurnIndex.index]
        @root.currentTurnIndex.index = index
        @root\calculatePlayerPos!