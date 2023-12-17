using HorizonSideRobots
r = Robot("2.sit",animate=true)
function perimetr(r::Robot)
    num_vert = count_steps(r,Sud)
    num_hor = count_steps(r,West)
    marking(r)
    go_back(r,Nord,num_vert)
    go_back(r,Ost,num_hor)
end
putmarkers!(r::Robot,side::HorizonSide) = 
    while isborder(r,side)==false 
        move!(r,side)
        putmarker!(r)
    end
function marking(r::Robot)
    for side in (Nord, Ost, Sud, West)
        putmarkers!(r,side)
    end
end
function count_steps(r::Robot, side::HorizonSide)
    num_steps = 0
    while isborder(r,side) == false
        move!(r,side)
        num_steps += 1
    end
    return num_steps
end

function go_back(r::Robot,side::HorizonSide,num_steps::Int)
    for i in 1:num_steps
        move!(r,side)
    end
end
putmarkers!(r::Robot,side::HorizonSide) = 
    while isborder(r,side)==false 
        move!(r,side)
        putmarker!(r)
    end
inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4)) 

perimetr(r)



