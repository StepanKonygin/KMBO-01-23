using HorizonSideRobots

function returning!(t,Side)
    t=[]
    k=0
    while isborder(r,Side)
        move!(r,Nord)
        push!(t,Nord)
        k+=1
    end
    move!(r,Side)
    push!(t,Side)
    while isborder(r,Sud)
        move!(r,Side)
        push!(t,Side)
    end
    while k>0
        move!(r,Sud)
        push!(t,Sud)
        k-=1
    end
    return t
end

function come_back!(r)
    history=[]
    f=0
    while f!=1
        while !isborder(r,West)
            move!(r,West)
            push!(history,West)
        end
        n=0
        while !isborder(r,Nord)
            move!(r,Nord)
            n+=1
        end
        if isborder(r,West)
            f=1
            p=n
            for i in 1:p
                move!(r,Sud)
                n-=1
            end
            break
        end
        p=n
        for i in 1:p
            move!(r,Sud)
            n-=1
        end
        tr=returning!(r,West)
        for i in tr
            push!(history,i)
        end
    
    end
    while !isborder(r,Sud)
        move!(r,Sud)
        push!(history,Sud)
    end
    return history

end
function finish!(r,history)
    while !isborder(r,Sud)
        move!(r,Sud)
    end

    while !isborder(r,West)
        move!(r,West)
    end
    for i in reverse(history)
        move!(r,inverse(i))
    end

end

inverse(s::HorizonSide) = HorizonSide(mod(Int(s)+2, 4))
inverse90(s::HorizonSide) = HorizonSide(mod(Int(s)+1, 4))

function along!(stop_condidion::Function, robot, side)
    while !stop_condidion()
        move!(robot, side)
    end
end
function move_num!(stop_condidion::Function, robot, side, num)
    for x in 1:num
        if !stop_condidion()
            move!(robot, side)
        else
            return false
        end
    end
    return !stop_condidion()
end

function numstesp_along!(stop_condidion::Function, robot, side)
    n = 0
    while !stop_condidion()
        move!(robot, side)
        n+=1
    end
    return n
end

function try_move!(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
        return true
    else
        return false
    end
end

function snake!(stop_condition::Function, robot, side1, side2)
	s = side1
	along!(()-> stop_condition() || isborder(robot, s) , robot,s)
	while !stop_condition() && try_move!(robot, side2)
		s = inverse(s)
		along!(()->stop_condition() || isborder(robot, s), robot, s)
	end
end

function shuttle!(stop_condition::Function, robot, start_side)
    k = 1
    s = start_side
    while !stop_condition()
        shag = ceil(k/2)
        flag = move_num!(()->stop_condition(),r, s, shag)
        if flag
            move_num!(r, inverse(s), shag)
        end
        k+=1
        s = inverse(s)
    end

end
function move_num!(robot,side,num_steps; mark = false, rev = false)
    # Двигает робота в заданном направлении на заданное количество клеток
    if mark
        putmarker!(robot)
    end
    c = 0
    for k in 1:num_steps 
        move!(robot, side)
        c+=1
        if mark
            putmarker!(robot)
        end
    end
    if rev
        for α in 1:c
            move!(robot,inverse(side))
        end
    end
end

function spiral!(stop_condition::Function, robot)
    k = 1
    
    side = Nord
    while !stop_condition()
        flag = move_num!(()->stop_condition(),robot, side, Int(ceil(k/2)))
        k+=1
        side = inverse90(side)
    end
end

