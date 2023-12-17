using HorizonSideRobots
r = Robot("4.sit",animate=true)
function mark_oblique_cross(r::Robot)
    for side in ((Nord,West),(Nord,Ost),(Sud,West),(Sud,Ost))
        num_step = 0
        while !multi_isborder(r,side)
            num_step += mark_and_numsteps(r,side)
        end
        putmarker!(r)
        go_back(r,side,num_step)
    end
end

function go_back(r::Robot,sides::Tuple,num_step)
    for i in 1:num_step
        for side in sides
            move!(r,inverse(side))
        end
    end
end
function mark_and_numsteps(r::Robot,sides::Tuple)
    num_steps = 0
    putmarker!(r)
    for side in sides
        move!(r,side)
        num_steps += 1
    end
    return num_steps//2
end
function multi_isborder(r::Robot,sides::Tuple)
    sideY, sideX = sides
    if isborder(r,sideY)||isborder(r,sideX)
        return true
    else
        return false
    end
end
inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2,4))
mark_oblique_cross(r)