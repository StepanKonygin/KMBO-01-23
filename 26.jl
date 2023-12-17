using HorizonSideRobots

inverse(s::HorizonSide) = HorizonSide(mod(Int(s)+2, 4))

mark_maze!(r)=
if !ismarker(r)
    putmarker!(r)
    for s in (Nord, West, Sud, Ost)
        if !isborder(r,s)
            move!(r, s)
            mark_maze!(r)
            move!(r, inverse(s))
        end 
    end
end

r = Robot("26.sit", animate = true) 
mark_maze!(r)
