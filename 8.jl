using HorizonSideRobots
r = Robot("8.sit",animate=true)
inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2,4))
function find_the_marker(r::Robot)
    n = 1
    while !ismarker(r)
        n += spiral(r,n)
    end
end
function spiral(r::Robot,n::Int)
    step(r,Nord,n)
    step(r,Ost,n)
    step(r,Sud,n+1)
    step(r,West,n+1)
    return 2
end
function step(r::Robot,side::HorizonSide,n::Int)
    if ismarker(r)
        return nothing
    else
        for i in 1:n 
            if ismarker(r)
                break
            else
                move!(r,side)
            end
        end
    end
end
find_the_marker(r)