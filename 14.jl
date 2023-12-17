using HorizonSideRobots
robot = Robot("14B.sit",animate=true)
inverse(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)+2, 4))
left(side::HorizonSide) = HorizonSide(mod(Int(side)+1, 4))

function parity(a::Int,b::Int)
    return (a+b)%2 == 0
end

function main(robot::Robot)
    direction = Ost
    num_hor = count_steps(robot,West)
    num_ver = count_steps(robot,Sud)
    chetnost  = parity(num_hor,num_ver)
    while !isborder(robot,Nord)||!isborder(robot,Ost) 
        along(robot,direction,chetnost)
        if isborder(robot,Nord)&&isborder(robot,Ost)
            break
        else
            move!(robot,Nord)
            direction=inverse(direction)
        end
    end
    to_start(robot,num_ver,num_hor)
end
function count_steps(r::Robot,side::HorizonSide)::Int
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
function obhod(robot::Robot, side)
    ortogonal_side = left(side)
    back_side = inverse(ortogonal_side)
    n=0
    while isborder(robot, side)==true && isborder(robot, ortogonal_side) == false
        move!(robot, ortogonal_side)
        n += 1
    end
    if isborder(robot,side)==true
        for i in 1:n
            move!(robot, back_side)
        end
        return false,0
    end
    move!(robot, side)
    if n > 0 # продолжается обход
        k = along!(()->!isborder(robot, back_side), robot, side) 
        for i in 1:n
            move!(robot, back_side)
        end
    end
    return true,k
end
function try_move!(robot,side)
    if isborder(robot,side)
        return false
    else
        move!(robot,side)
        return true
    end
end
function along!(stop_condition::Function, robot, side)
    k = 0
    while stop_condition() == false && try_move!(robot, side) 
        k += 1
    end
    return k 
end
function along(robot::Robot, side::HorizonSide,parity::Bool)
    while true
        a,b = try_move(robot,side,parity)
        if a
            if b > 0
                parity = parity && (b+1)%2==0
            else
                parity = !parity
            end
        else
            break
        end
    end
end

function try_move(robot, side,parity) 
    if isborder(robot, side)
        if parity
            putmarker!(robot)
        end
        return obhod(robot,side)
    else
       if parity
            putmarker!(robot)
        end
        move!(robot, side)
        return true, 0
    end
end
main(robot)
