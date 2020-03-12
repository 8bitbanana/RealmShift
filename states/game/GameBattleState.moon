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


    init: =>
        -- BattlePlayer position is the bottom-left of the sprite
        @state = BattleMenuState(@)
        @players = {
            Paladin(@, {x:120,y:127}), -- player x is 92+28*i
            Fighter(@, {x:148,y:127}),
            nil,
            Mage(@, {x:204,y:127}),
        }
        @enemies = {
            BattleEnemy(@, {x:10,y:127})
        }

        @getNextInitiative true
    
    -- This probably shouldn't be this complex
    getNextInitiative: (apply=false)=>
        nextup = nil
        nextupSpeed = -999
        nextup_all = nil
        nextup_allSpeed = -999

        currentTurnSpeed = 999
        currentTurnSpeed = @currentTurn.stats.speed if @currentTurn != nil

        for player in *@players
            continue if player == nil
            if player.stats.speed > nextupSpeed and player.stats.speed < currentTurnSpeed
                nextup = player
                nextupSpeed = player.stats.speed
            if player.stats.speed > nextup_allSpeed
                nextup_all = player
                nextup_allSpeed = player.stats.speed
        for enemy in *@enemies
            continue if enemy == nil
            if enemy.stats.speed > nextupSpeed and enemy.stats.speed < currentTurnSpeed
                nextup = enemy
                nextupSpeed = enemy.stats.speed
            if enemy.stats.speed > nextup_allSpeed
                nextup_all = enemy
                nextup_allSpeed = enemy.stats.speed
        if nextup == nil
            @currentTurn = nextup_all if apply
            return nextup_all
        else
            @currentTurn = nextup if apply
            return nextup

    attackAction: () =>
        @currentTurn\attack(@enemies[1])

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
        @state\draw!
        for player in *@players
            player\draw! if player
        for enemy in *@enemies
            enemy\draw! if enemy
        @aniObjs\drawObjects!