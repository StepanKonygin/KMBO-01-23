function f(x)
    
    if x == 1 || x == 2
        return 1
    else 
        return f(x-2)+f(x-1)
    end
end

function fibonac(x)
    data = [1,1]
    for i in 3:x
        push!(data,(data[i-1]+data[i-2]))
    end
    return data[x]
end