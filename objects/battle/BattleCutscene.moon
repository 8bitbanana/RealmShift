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

export class BattleCutscene
    new: (@args) =>
        @root = nil
        @started = false
        @done = false
        @tts_max = 0
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

-- currentTurn attacks player/enemy at @args.index
export class CutsceneAttack extends BattleCutscene
    new: (...) =>
        super ...
        @ttl_max = 10

    sceneUpdate: =>
        if @ttl == 8
            damage = @root\currentTurn!\attack(@root\inactiveEntities![@args.index], @args.damage)
            pos = @root\inactiveEntities![@args.index]\getCursorPos!
            particle = BattleDamageNumber(pos, damage)
            @root.aniObjs\addObject(particle)
        -- Fancy slash graphics to go here

    sceneFinish: =>

-- currentTurn (player) shoves forwards as far as it can in @args.dir direction
-- Other players are shoved in the opposite direction to make room
-- Todo - convert to work on enemies
export class CutsceneShove extends BattleCutscene
    new: (...) =>
        super ...
        @ttl = 25
        @moves = {}

    sceneStart: =>
        assert(@root.turndata.type == "player")
        oldindex = @root.turndata.index
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
                    break
            if index == @root.turndata.index
                @root.turndata.index = newindex
            newPlayers[newindex] = @root.players[index]
        @root.players = newPlayers
        @root\calculatePlayerPos!
        
-- Swaps players at @args.firstindex and @args.secondindex
export class CutsceneSwap extends BattleCutscene
    new: (...) =>
        super ...
        @ttl = 25

    sceneStart: =>
        @playerA = @root.players[@args.firstindex]
        @playerB = @root.players[@args.secondindex]
        assert @args.firstindex != @args.secondindex
        if @playerA
            @posA = @playerA.pos
        else
            @posA = @root\getPlayerIndexPos(@args.firstindex)
        if @playerB
            @posB = @playerB.pos
        else
            @posB = @root\getPlayerIndexPos(@args.secondindex)

    sceneUpdate: =>
        if @playerA != nil
            @playerA.pos = vector.lerp(@posA, @posB, @progress!)
        if @playerB != nil
            @playerB.pos = vector.lerp(@posB, @posA, @progress!)

    sceneFinish: =>
        @root.players[@args.firstindex], @root.players[@args.secondindex] = @root.players[@args.secondindex], @root.players[@args.firstindex]
        @root.turndata.index = @args.secondindex if @root.turndata.index == @args.firstindex
        @root.turndata.index = @args.firstindex if @root.turndata.index == @args.secondindex
        @root\calculatePlayerPos!