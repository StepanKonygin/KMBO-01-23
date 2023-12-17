using HorizonSideRobots
r = Robot("6b.sit",animate=true)
inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2,4))
function perimetr_with_obstacles(r::Robot)
    moves_to_origins = go_to_reference_point(r)
    x = length([i for i in moves_to_origins if i == 1])+1
    y = length([i for i in moves_to_origins if i == 2])+1
    marking(r,x,y)
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
function marking(r::Robot,x::Int,y::Int)
    coordinates = [1,1]
    values = [1,1,-1,-1]
    sides = [Nord, Ost, Sud, West]
    for i in [1,2,3,4]
        while !isborder(r,sides[i])
            if coordinates[1] == x || coordinates[2] == y
                putmarker!(r)
            end
            coordinates[(i)%2+1] += values[i]
            move!(r,sides[i])
        end
    end
end
putmarkers!(r::Robot,side::HorizonSide) = 
    while isborder(r,side)==false 
        move!(r,side)
        putmarker!(r)
    end
perimetr_with_obstacles(r)