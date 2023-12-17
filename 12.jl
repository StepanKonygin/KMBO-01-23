using HorizonSideRobots
r = Robot("12.sit", animate=true) 

function advanced_hor_borders_count(r)
    moves = go_to_reference_point(r)
    if ! isborder(r, Nord)
        move!(r, Nord)
    else
        return 0
    end
    m = snake(r)
    back_to_the_origins(r,moves)
    return m
end

function go_to_reference_point(r::Robot)::Array
    moves = []
    while !isborder(r,West)||!isborder(r,Sud)
        if !isborder(r,West)
            push!(moves,Int(West))
            move!(r,West)
        end
        if !isborder(r,Sud)
            push!(moves,Int(Sud))
            move!(r,Sud)
        end
    end
    return moves
end

function back_to_the_origins(r::Robot,moves::Array)
    go_to_reference_point(r)
    for i in 0:length(moves)-1
        move!(r,inverse(HorizonSide(moves[length(moves)-i])))
    end
end

function snake(r)
    n = 0
    s = Ost
    while !isborder(r,Nord)
        x = borders_count(r, s)
        move!(r, Nord)
        s = inverse(s)
        n += x
    end
    n += borders_count(r, s)
    return n
end

function borders_count(r, s)
    x = 0
    g = 0
    f = 0
    n = 0
    while ! isborder(r, s)
        n = g
        g = f
        if isborder(r, Sud)
            f = 1
        else
            f = 0
        end
        if  (f == 0) & (g == 0)
            x += n  
        end
        move!(r, s)
    end
    if (f == 1) || (g == 1)
        x += 1
    end
    return x
end
function inverse(s)
    return HorizonSide(mod(Int(s) + 2,4))
end
k = advanced_hor_borders_count(r)
print(k)