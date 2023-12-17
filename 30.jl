using HorizonSideRobots
include("librobot.jl")

include("funct.jl")

inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))

mutable struct CordBorderRobot <: AbstractRobot
    robot::Robot
    x::Int
    y::Int
end
robot = Robot("26.sit", animate = true)
r=CordBorderRobot(robot,0,0)
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
    if (abs(robot.x)+abs(robot.y))%2==0
        putmarker!(robot.robot)
    end
    nothing
end


function ifstart(robot)
    if robot.x==0 && robot.y == 0
        return true
    else
        return false
    end
end

mark_maze!(r)=
if !ismarker(r)
    X,Y = get(r)
    if (abs(X)+abs(Y))%2==0 
         putmarker!(r)
    end
    for s in (Nord, West, Sud, Ost)
        if !isborder(r,s)
            HorizonSideRobots.move!(r, s)
            mark_maze!(r)
            HorizonSideRobots.move!(r, inverse(s))
        end 
    end
end
mark_maze!(r)