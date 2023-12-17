using HorizonSideRobots
r = Robot("1.sit",animate=true)

function mark_kross!(r::Robot)
    for side in (Nord,West,Sud,Ost) 
        putmarkers!(r,side)
        move_by_markers(r,inverse(side))
    end
    putmarker!(r)
end
putmarkers!(r::Robot,side::HorizonSide) = 
    while isborder(r,side)==false 
        move!(r,side)
        putmarker!(r)
    end
move_by_markers(r::Robot,side::HorizonSide) = 
    while ismarker(r)==true 
        move!(r,side) 
    end
inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4)) 

mark_kross!(r)