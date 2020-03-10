require "states/state"

WRAP_PLAYER_CURSOR = false

export class GameBattleState extends State
    new: (@parent) =>
        @players = {nil,nil,nil,nil}
        @selectedSpace = 1

    init: =>
        @players = {
            Paladin!,
            Fighter!,
            nil,
            Mage!,
        }
        for i, player in pairs @players
            player.pos.x = 92+28*i
            player.pos.y = 95

    movePlayerCursor: (dir) => -- this was resursive but I wanted it to error rather than hang
        for i=0, 8
            @selectedSpace += dir
            if WRAP_PLAYER_CURSOR
                @selectedSpace = 4 if @selectedSpace < 1
                @selectedSpace = 1 if @selectedSpace > 4
            else
                @selectedSpace = 1 if @selectedSpace < 1
                @selectedSpace = 4 if @selectedSpace > 4
            return if @selectedPlayer! != nil
        error "MovePlayerCursor is spinning in circles"

    selectedPlayer: () => return @players[@selectedSpace]

    update: =>
        @movePlayerCursor(-1) if input\pressed("left")
        @movePlayerCursor(1)  if input\pressed("right")

    drawMenu: (x,y) =>
        lg.print

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
        selectedX = @selectedPlayer!.pos.x
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
        @drawMenu!
        for player in *@players
            player\draw! if player
        