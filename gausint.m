function [x,w,ierr] = gausint(order)

ierr = 0;

if (order == 0)
    ierr = 1;
    return;
end

x = zeros(order,1);
w = zeros(order,1);

if (order == 2)
    
    x(1) = -0.577350269189626;
    x(2) = 0.577350269189626;
    
    w(1) = 1.0;
    w(2) = 1.0;
elseif (order == 3)
    
    x(1) = -0.774596669241483;
    x(2) = 0.774596669241483;
    x(3) = 0.0;
    
    w(1) = 0.555555555555556;
    w(2) = 0.555555555555556;
    w(3) = 0.888888888888889;
else
    ierr = 1;
end


end

