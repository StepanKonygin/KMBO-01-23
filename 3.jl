using HorizonSideRobots
r = Robot("3.sit",animate=true)
function fill(r::Robot)
    num_hor = count_steps(r,West)
    num_ver = count_steps(r,Sud)
    direction = Ost
    while isborder(r,Nord)==false||isborder(r,Ost)==false
        mark_row(r,direction)
        if isborder(r,Nord)&&isborder(r,Ost)
            break
        else
            move!(r,Nord)
            direction=inverse(direction)
        end
    end
    to_start(r,num_ver,num_hor)
end
function count_steps(r::Robot,side::HorizonSide)
    num_steps=0
    while isborder(r,side)==false
        num_steps+=1
        move!(r,side)
    end
    return num_steps
end
function to_start(r::Robot,ver::Int64,hor::Int64)
    while isborder(r,Sud)==false
        move!(r,Sud)
    end
    while isborder(r,West)==false
        move!(r,West)
    end
    for i in 1:ver
        move!(r,Nord)
    end
    for i in 1:hor
        move!(r,Ost)
    end
end
function mark_row(r::Robot,side::HorizonSide)
    while !isborder(r,side)
        putmarker!(r)
        move!(r,side)
    end
    putmarker!(r)
end
inverse(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)+2, 4))
fill(r)