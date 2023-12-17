using HorizonSideRobots
r = Robot("6.sit",animate=true)
inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2,4))
function perimeter_with_obstacles(r::Robot)
    moves_to_origins = go_to_reference_point(r)
    marking(r)
    back_to_the_origins(r,moves_to_origins)
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
    for i in 0:length(moves)-1
        move!(r,inverse(HorizonSide(moves[length(moves)-i])))
    end
end
function marking(r::Robot)
    for side in (Nord, Ost, Sud, West)
        putmarkers!(r,side)
    end
end
putmarkers!(r::Robot,side::HorizonSide) = 
    while isborder(r,side)==false 
        move!(r,side)
        putmarker!(r)
    end
perimeter_with_obstacles(r)