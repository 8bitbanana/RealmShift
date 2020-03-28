export vector = {}

vector.up = {x:0,y:-1}
vector.down = {x:0,y:1}
vector.left = {x:-1,y:0}
vector.right = {x:1,y:0}

vector.bezier2 = (start, control, finish, progress) ->
    -- heard you like lerps so I added more lerps to your lerps
    sc_mid = vector.lerp(start, control, progress)
    cf_mid = vector.lerp(control, finish, progress)
    return vector.lerp(sc_mid, cf_mid, progress)
vector.bezier3 = (start, control1, control2, finish, progress) ->
    -- heard you like lerp-lerps so I added more lerp-lerps to your lerp-lerps
    sc_mid = vector.lerp(start, control1, progress)
    cd_mid = vector.lerp(control1, control2, progress)
    df_mid = vector.lerp(control2, finish, progress)
    sc_cd_mid = vector.lerp(sc_mid, cd_mid, progress)
    cd_df_mid = vector.lerp(cd_mid, df_mid, progress)
    return vector.lerp(sc_cd_mid, cd_df_mid, progress)

vector.add = (a,b) ->
    return {x:a.x+b.x,y:a.y+b.y}
vector.sub = (a,b) ->
    return {x:a.x-b.x,y:a.y-b.y}
vector.mult = (a,b) ->
    switch type(b)
        when "number"
            return {x:a.x*b,y:a.y*b}
        when "table"
            return {x:a.x*b.x,y:a.y*b.y}
        else
            error("Invalid type")
vector.div = (a,b) ->
    switch type(b)
        when "number"
            return {x:a.x/b,y:a.y/b}
        when "table"
            return {x:a.x/b.x,y:a.y/b.y}
        else
            error("Invalid type")
vector.midpoint = (a,b) ->
    return {x:(a.x+b.x)/2,y:(a.y+b.y)/2}
vector.lerp = (a, b, progress) ->
    return {
        x:a.x*progress + b.x*(1-progress)
        y:a.y*progress + b.y*(1-progress)
    }