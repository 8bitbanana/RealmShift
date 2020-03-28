require "states/state"
Inspect = require "lib/inspect"

WRAP_PLAYER_CURSOR = false

export class GameBattleState extends State
    new: (@parent) =>
        @players = {nil,nil,nil,nil}
        @enemies = {nil}
        @selectedSpace = 1

        @state = nil

        @aniObjs = ObjectManager!
        @currentTurn = nil
        @currentTurnIndex = {type:nil,index:0}

        @selectionCallback = ()->
        @cutsceneCallback = ()->
        @unselectable = {}


    init: =>
        -- BattlePlayer position is the bottom-left of the sprite
        @state = BattleMenuState(@)
        @players = {
            Paladin(@, {x:120,y:127}), -- player x is 92+28*i
            Fighter(@, {x:148,y:127}),
            nil,
            Mage(@, {x:204,y:127}),
        }
        @calculatePlayerPos!

        @enemies = {
            BattleEnemy(@, {x:10,y:127})
            BattleEnemy(@, {x:50,y:127})
        }

        @getNextInitiative true
    
    calculatePlayerPos: =>
        for i, player in pairs @players
            player.pos = @getPlayerIndexPos i

    getPlayerIndexPos: (i) =>
        return {
            x: 92+28*i
            y: 127
        }

    turnEnd: () =>
        @getNextInitiative true
        switch @currentTurnIndex.type
            when "player"
                @state\changeState(BattleMenuState)
            when "enemy"
                @enemyTurn!
            else
                if @currentTurnIndex.type == nil
                    error "currentTurnIndex.type is nil"
                else
                    error "Invalid currentTurnIndex.type " .. @currentTurnIndex.type

    getNextInitiative: (apply=false)=>
        nextup = nil
        nextupSpeed = -999
        nextupIndex = {type:nil, index:0}
        nextup_all = nil
        nextup_allSpeed = -999
        nextup_allIndex = {type:nil, index:0}

        currentTurnSpeed = 999
        currentTurnSpeed = @currentTurn.stats.speed if @currentTurn != nil

        for index, player in pairs @players
            continue if player == nil
            if player.stats.speed > nextupSpeed and player.stats.speed < currentTurnSpeed
                nextup = player
                nextupSpeed = player.stats.speed
                nextupIndex = {type:"player", index:index}
            if player.stats.speed > nextup_allSpeed
                nextup_all = player
                nextup_allSpeed = player.stats.speed
                nextup_allIndex = {type:"player", index:index}
        for index, enemy in pairs @enemies
            continue if enemy == nil
            if enemy.stats.speed > nextupSpeed and enemy.stats.speed < currentTurnSpeed
                nextup = enemy
                nextupSpeed = enemy.stats.speed
                nextupIndex = {type:"enemy", index:index}
            if enemy.stats.speed > nextup_allSpeed
                nextup_all = enemy
                nextup_allSpeed = enemy.stats.speed
                nextup_allIndex = {type:"enemy", index:index}
        if nextup == nil
            @currentTurn = nextup_all if apply
            @currentTurnIndex = nextup_allIndex if apply
            return nextup_all
        else
            @currentTurn = nextup if apply
            @currentTurnIndex = nextupIndex if apply
            return nextup

    
    attackAction: () =>
        @selectionCallback = (index) =>
            @cutsceneAttackCallback = () =>
                @currentTurn\attack(@enemies[index])
            @cutsceneCallback = () =>
                @turnEnd!
            @state\changeState(BCPlayerAttackState)
        @state\changeState(BattleEnemySelectState)

    enemyTurn: () =>
        -- Pick what the enemy is going to do and set up a
        -- BattleCutsceneState to show animations
        -- For now just skip the turn
        print "Enemy turn unimplimented - skip"
        @turnEnd!

    moveAction: () =>
        @selectionCallback = (index) =>
            currentSpace = @currentTurnIndex.index
            assert currentSpace != nil
            assert index <= 4
            @cutsceneCallback = () =>
                @players[@currentTurnIndex.index], @players[index] = @players[index], @players[@currentTurnIndex.index]
                @calculatePlayerPos!
                @turnEnd!
            @state\changeState(BCMoveState, {index:index})
        @state\changeState(BattleSpaceSelectState)

    selectedPlayer: () => return @players[@selectedSpace]

    update: =>
        @state\update!
        @aniObjs\updateObjects!
        @aniObjs\checkDestroyed!

    draw: =>
        lg.setColor(0.28,0.81,0.81,1)
        lg.rectangle("fill",0,0,GAME_WIDTH,GAME_HEIGHT) -- sky
        lg.setColor(0.25,0.63,0.22,1)
        lg.rectangle("fill",0,127,GAME_WIDTH, 53) -- grass
        for player in *@players
            player\draw! if player
        for enemy in *@enemies
            enemy\draw! if enemy
        @state\draw!
        @aniObjs\drawObjects!