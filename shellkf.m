function [ke,fe,ierr] = shellkf(eiid,ielem,iegrid,rpgrid,D)

% D -  material matrix

order = 2;

[x,w,ierr] = gausint(order);
if (ierr ~= 0) 
    return;
end

ngint = order * order;

xc = zeros(2,ngint);
wc = zeros(ngint,1);

inc = 1;
for i = 1:order
    for j = 1:order
        xc(1,inc) = x(i);
        xc(2,inc) = x(j);
        wc(inc) = w(i) * w(j);
        inc = inc + 1;
    end
end




end

