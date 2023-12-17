using HorizonSideRobots
r = Robot("7.sit",animate=true)
inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2,4))

function find_the_gap(r::Robot)
    direction = Ost
    n = 1
    while isborder(r,Nord)
        back_and_forth(r,direction,n)
        n += 1
        direction = inverse(direction)
    end
end
function back_and_forth(r::Robot,side::HorizonSide,n)
    for i in 1:n
        if isborder(r,Nord)
            move!(r,side)
        else 
            break
        end
    end
end
find_the_gap(r)
