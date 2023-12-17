using HorizonSideRobots

left(side::HorizonSide) = HorizonSide(mod(Int(side)+1, 4))
right(side::HorizonSide) = HorizonSide(mod(Int(side)-1, 4))
inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))

try_move!(robot, side) = 
    if isborder(robot, side)
        return false
    else
        move!(robot, side)
        return true
    end



# К занятию 7 (функции высшего порядка):

along!(stop_condition::Function, robot, side) = 
    while stop_condition() == false && try_move!(robot, side) end
 
function numsteps_along!(stop_condition::Function, robot, side)
    n = 0
    while stop_condition() == false && try_move!(robot, side)
        n += 1
    end
    return n
end

function snake!(stop_condition::Function, robot; start_side, ortogonal_side)
    s = start_side
    along!(stop_condition, robot, s)
    while !stop_condition() && !isborder(robot, ortogonal_side) # && try_move!(robot, ortogonal_side) - так будет лишняя попытка обхода внешней рамки
        move!(robot, ortogonal_side)
        s = inverse(s)
        along!(stop_condition, robot, s)
    end
end

snake!(robot; start_side, ortogonal_side) = 
    snake!(() -> false, robot; start_side, ortogonal_side)

function shatl!(stop_condition::Function, robot; start_side)
    s = start_side
    n = 0
    while stop_condition() == false
        n += 1
        move!(()->stop_condition(), robot, s, n)
        s = inverse(s)
    end
    return (n+1)÷2 # - число шагов от начального положения до конечного
end

function spiral!(stop_condition::Function, robot; start_side = Nord, nextside::Function = left)
    side = start_side
    n = 0
    while stop_condition() == false
        if iseven(n)
            n += 1
        end
        move!(()->stop_condition(), robot, side; num_maxsteps = n)
        side = nextside(side)
        move!(()->stop_condition(), robot, side; num_maxsteps = n)
        side = nextside(side)
    end
end
          
function HorizonSideRobots.move!(stop_condition::Function, robot, side; num_maxsteps::Integer)
    n = 0
    while n < num_maxsteps && stop_condition() == false
        n += 1
        move!(robot, side)
    end
    return n
end

HorizonSideRobots.move!(robot, side, num_steps::Integer) =
    for i in  1:num_steps
        move!(robot, side)
    end

#-------------------------------------
# к занятию 8:

HSR = HorizonSideRobots

abstract type AbstractRobot end

HSR.move!(robot::AbstractRobot, side) = move!(get_baserobot(robot), side)
HSR.isborder(robot::AbstractRobot, side) = isborder(get_baserobot(robot), side)
HSR.putmarker!(robot::AbstractRobot) = putmarker!(get_baserobot(robot))
HSR.ismarker(robot::AbstractRobot) = ismarker(get_baserobot(robot))
HSR.temperature(robot::AbstractRobot) = temperature(get_baserobot(robot))

#----------------------------------------

mutable struct CountmarkersRobot <: AbstractRobot
    robot::Robot
    num_markers::Int64
end
 
get_baserobot(robot::CountmarkersRobot) = robot.robot

function HSR.move!(robot::CountmarkersRobot, side) 
    move!(robot.robot, side)
    if ismarker(robot)
        robot.num_markers += 1
    end
    nothing
end

#---------------------

mutable struct Coordinates
    x::Int
    y::Int
end

function HorizonSideRobots.move!(coord::Coordinates, side::HorizonSide)
    if side == Ost
        coord.x += 1
    elseif side == West
        coord.x -= 1
    elseif side == Nord
        coord.y += 1
    else # side == Sud
        coord.y -= 1
    end
    nothing
end

get(coord::Coordinates) = (coord.x, coord.y)

# #-------------------------------------------
# #=
struct BorderRobot <: AbstractRobot
    robot::Robot
end


# struct BorderRobot <: AbstractRobot
#     robot::Robot
# end

get_baserobot(robot::BorderRobot) = robot.robot

function try_move!(robot::BorderRobot, side)
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
         along!(()->!isborder(robot, back_side), robot, side) 
         move!(robot, back_side, n)
    end
    return true
end


# along!(robot::BorderRobot, side::HorizonSide) = while try_move!(robot, side) end

# along!(stop_condition::Function, robot::BorderRobot, side::HorizonSide) =
#     while !stop_condition() && try_move!(robot, side) end
# #-----------------------------------------------