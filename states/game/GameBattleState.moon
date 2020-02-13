require "states/state"

WRAP_PLAYER_CURSOR = false

export class GameBattleState extends State
    new: (@parent) =>
        @objects = ObjectManager!
        @selectedPlayer = 1

    init: =>
        @players = {
            BattlePlayer({x:120+28*0,y:95}),
            BattlePlayer({x:120+28*1,y:95}),
            BattlePlayer({x:120+28*2,y:95}),
            BattlePlayer({x:120+28*3,y:95}),
        }
        for player in *@players
            @objects\addObject(player)

    movePlayerCursor: (dir) =>
        @selectedPlayer += dir
        if WRAP_PLAYER_CURSOR
            @selectedPlayer = 4 if @selectedPlayer < 1
            @selectedPlayer = 1 if @selectedPlayer > 4
        else
            @selectedPlayer = 1 if @selectedPlayer < 1
            @selectedPlayer = 4 if @selectedPlayer > 4

    selectedPlayer: () => return @players[@selectedPlayer]

    update: =>
        @objects\updateObjects!
        @objects\checkDestroyed!
        @movePlayerCursor(1)

    draw: =>
        lg.setColor(0.28,0.81,0.81,1)
        lg.rectangle("fill",0,0,GAME_WIDTH,GAME_HEIGHT) -- sky
        lg.setColor(0.25,0.63,0.22,1)
        lg.rectangle("fill",0,127,GAME_WIDTH, 53) -- grass
        lg.setColor(1,1,1,1)
        lg.rectangle("fill",116,4,116,50) -- menubox fill
        lg.setColor(0,0,0,1)
        lg.rectangle("line",116,4,116,50) -- menubox line
        lg.setColor(1,1,1,1)
        selectedX = @players[@selectedPlayer].pos.x
        lg.polygon("fill", 
            selectedX + 2,  53,
            selectedX + 12, 91,
            selectedX + 22, 53
        ) -- player cursor fill
        lg.setColor(0,0,0,1)
        lg.line(
            selectedX + 2, 53,
            selectedX + 12, 91,
            selectedX + 22, 53
        ) -- player cursor line
        @objects\drawObjects!
        