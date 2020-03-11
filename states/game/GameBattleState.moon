require "states/state"

WRAP_PLAYER_CURSOR = false

export class GameBattleState extends State
    new: (@parent) =>
        @players = {nil,nil,nil,nil}
        @enemies = {}
        @selectedSpace = 1

        @state = BattleMenuState(@)

        @aniObjs = ObjectManager!

        @currentInitiative = 99

    init: =>
        @players = {
            Paladin!,
            Fighter!,
            nil,
            Mage!,
        }
        @enemy = BattleEnemy!
        for i, player in pairs @players
            player.pos.x = 92+28*i
            player.pos.y = 127 -- position is bottom left of sprite
        @enemy.pos.x = 10
        @enemy.pos.y = 127

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
        @state\update!
        --@movePlayerCursor(-1) if input\pressed("left")
        --@movePlayerCursor(1)  if input\pressed("right")
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
        @enemy\draw!
        @aniObjs\drawObjects!