using HorizonSideRobots
r = Robot("5.sit",animate=true) 

function double_perimetr(r::Robot)
    num_x, num_y = go_to_reference_point(r)
    mark_large_perimert(r)
    find_rectangle(r)
    mark_small_perimetr(r)
    go_to_reference_point(r)
    back_to_the_origins(r,num_x,num_y)
end
function go_to_reference_point(r::Robot)
    num_x = num_y = 0
    while !isborder(r,West)||!isborder(r,Sud)
        num_x += try_move(r,West)
        num_y += try_move(r,Sud)
    end
    return num_x, num_y
end
function try_move(r::Robot,side::HorizonSide)
    num_step = 0
    while !isborder(r,side)
        move!(r,side)
        num_step += 1
    end
    return num_step
end
function mark_large_perimert(r::Robot)
    for side in (Ost,Nord,West,Sud)
        mark_row(r,side)
    end
end
function mark_row(r::Robot,side::HorizonSide)
    while !isborder(r,side)
        putmarker!(r)
        move!(r,side)
    end
end
function find_rectangle(r::Robot)
    direction = Ost
    while !find_in_row!(r,direction)
        move!(r,Nord)
        direction = inverse(direction)
    end
end 
function find_in_row!(robot::Robot,side::HorizonSide)
    while !isborder(r, Nord) && !isborder(r,side)
        move!(r,side)
    end
    return isborder(r,Nord)
end
function move_row(r::Robot,side::HorizonSide)
    while !isborder(r,side)
        move!(r,side)
    end
end
function mark_small_perimetr(r::Robot)
    for side in (Ost,Nord,West,Sud)
        border =HorizonSide(mod(Int(side)+1,4))
        while isborder(r,border)
            putmarker!(r)
            move!(r,side)
        end
        putmarker!(r)
        move!(r,border)
    end
end
function back_to_the_origins(r::Robot,num_x::Int,num_y::Int)
    if go_to_back(r,num_x,num_y,true) == false
        go_to_reference_point(r)
        go_to_back(r,num_x,num_y,false)
    end
end
function go_to_back(r::Robot,num_x::Int, num_y::Int,f::Bool)
    flag = true
    if f
        for i in 1:num_x
            if !isborder(r,Ost)
                move!(r,Ost)
            else
                flag = false
                break
            end
        end
        if flag == false
            return flag
        else
            for i in 1:num_y
                if !isborder(r,Nord)
                    move!(r,Nord)
                else
                    flag = false
                    break
                end
            end 
        end
        return flag
    else
        for i in 1:num_y
            move!(r,Nord)
        end 
        for i in 1:num_x    
            move!(r,Ost)
        end
    end
end
inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2,4))
double_perimetr(r)


