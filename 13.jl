using HorizonSideRobots

r = Robot("13.sit",animate=true)
inverse(side::HorizonSide)::HorizonSide = HorizonSide(mod(Int(side)+2, 4))
function parity(a::Int,b::Int)
    return (a+b)%2 == 0
end
function chess_fill(r::Robot)
    num_hor = count_steps(r,West)
    num_ver = count_steps(r,Sud)
    chetnost  = parity(num_hor,num_ver)
    snake!(r,chetnost)
    to_start(r,num_ver,num_hor)
end
function snake!(r::Robot,parity::Bool,(move_side, next_row_side)::NTuple{2,HorizonSide} =(Ost,Nord))
    chess_marking(r,move_side,next_row_side,parity)
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


function chess_marking(r::Robot,move_side::HorizonSide,next_row_side::HorizonSide, parity::Bool)
    direction = move_side
    while !isborder(r,move_side)||!isborder(r,next_row_side) 
        mark_row(r,direction,parity)
        if isborder(r,move_side)&&isborder(r,next_row_side)
            break
        else
            move!(r,next_row_side)
            direction=inverse(direction)
        end
    end
end
function mark_row(r::Robot,side::HorizonSide,parity::Bool)
    f = parity
    while !isborder(r,side)
        if parity
            putmarker!(r)
            move!(r,side)
            parity = !parity
        else
            move!(r,side)
            parity = !parity
        end
    end
    if parity
        putmarker!(r)
    end
end
chess_fill(r)
