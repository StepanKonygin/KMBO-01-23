using HorizonSideRobots

inverse(s::HorizonSide) = HorizonSide(mod(Int(s)+2, 4))
r = Robot("20.sit", animate = true)
function move_mark_end!(r, side)
    if isborder(r, side)
        putmarker!(r)
        return 
    end

    move!(r, side)
    move_mark_end!(r, side)
    move!(r, inverse(side))
end
move_mark_end!(r,Sud)