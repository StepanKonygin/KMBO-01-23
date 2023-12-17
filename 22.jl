using HorizonSideRobots

include("funct.jl")


r = Robot("22.sit", animate = true)


function double_dist!(r,side)
    if isborder(r, side)
        return 
    end
    move!(r, side)
    double_dist!(r, side)
    move!(r, inverse(side))
    move!(r, inverse(side))

end


double_dist!(r,Sud)