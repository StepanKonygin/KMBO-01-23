using HorizonSideRobots
include("librobot.jl")

include("funct.jl")

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))



function recursion_move(r, side)
    if !isborder(r,side)
        if ismarker(r)
            return Nothing
        end
        move!(r, side)
        recursion_move(r,side)
    else 
        try_move!(r,side)
        if ismarker(r)
            return Nothing
        else 
            recursion_move(r,side)
        end
    end
end

mutable struct CordBorderRobot <: AbstractRobot
    robot::Robot
    x::Int
    y::Int
end
get_baserobot(robot::CordBorderRobot) = robot.robot
get(coord::CordBorderRobot) = (coord.x, coord.y)

function HorizonSideRobots.move!(robot::CordBorderRobot, side::HorizonSide)
    move!(robot.robot,side)
    if side == Ost
        robot.x += 1
    elseif side == West
        robot.x -= 1
    elseif side == Nord
        robot.y += 1
    else  side == Sud
        robot.y -= 1
    end
    
    nothing
end


function try_move!(robot::CordBorderRobot, side)
    ortogonal_side = left(side)
    back_side = inverse(ortogonal_side)
    n=0
    while isborder(robot, side)==true && isborder(robot, ortogonal_side) == false
        move!(robot, ortogonal_side)
        n += 1
        
    end
    if isborder(robot,side)==true
         move!(robot, back_side, n)
         return false
    end
    move!(robot, side)
    if n > 0 # продолжается обход
         along!(()->!isborder(robot, back_side), robot::CordBorderRobot, side) 
         move!(robot, back_side, n)
    end
    return true
end

along!(robot::CordBorderRobot, side::HorizonSide) = while try_move!(robot, side) end

along!(stop_condition::Function, robot::CordBorderRobot, side::HorizonSide) =
    while !stop_condition() && try_move!(robot, side) end

robot = Robot("21.sit", animate = true)
r=CordBorderRobot(robot,0,0)


recursion_move(r,West)