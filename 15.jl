using HorizonSideRobots
include("librobot.jl")

include("funct.jl")

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))

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
    if abs(robot.x)==abs(robot.y)
        putmarker!(robot.robot)
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


function snake!(stop_condition::Function, robot::CordBorderRobot; start_side, ortogonal_side)
    s = start_side
    along!(stop_condition, robot::CordBorderRobot, s)
    while !stop_condition() && try_move!(robot, ortogonal_side)
        s = inverse(s)
        along!(stop_condition, robot::CordBorderRobot, s)
    end
end

function ifstart(robot)
    if robot.x==0 && robot.y == 0
        return true
    else
        return false
    end
end

function oblique_cross(robot::CordBorderRobot)
    
    come_back!(robot)
    snake!(()->false,robot;start_side=Ost,ortogonal_side=Nord)
    snake!(()->ifstart(robot), robot; start_side=West, ortogonal_side=Sud)
    
end

robot = Robot("15.sit", animate = true)
r=CordBorderRobot(robot,0,0)

oblique_cross(r)
