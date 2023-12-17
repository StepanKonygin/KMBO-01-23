using HorizonSideRobots
r = Robot("10.sit",animate=true)
k = parse(Int, readline())

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2,4))

function big_chess(r::Robot,k::Int)
    moves = go_to_reference_point(r)
    along_chess(r,k,Ost,true)
    go_to_reference_point(r)
    while !isborder(r,Nord)||!isborder(r,Ost)
        along_chess(r,k,Nord,ismarker(r))
        along_down(r,Sud)
        if !isborder(r,Ost)
            move!(r,Ost)
        else
            break
        end
    end
    back_to_the_origins(r,moves)
end
function along_chess(r::Robot,k::Int,side::HorizonSide,marker::Bool)
    while !isborder(r,side)
        for i in 1:k
            if marker
                putmarker!(r)
            end
            if isborder(r,side)
                break
            else
                move!(r,side)
            end
        end
        marker = !marker   
    end
    if marker
        putmarker!(r)
    end
end
function along_down(r::Robot,side::HorizonSide)
    while !isborder(r,side)
        move!(r,side)
    end
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
big_chess(r,k)