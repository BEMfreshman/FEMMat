function [ke,dofloc,ierr] = shellk(strtype,D,gi,elcoord)

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


[~,dndl] = quad4nfun(strtype,xc);

ks = zeros(8,8);

for i = 1:ngint

    % jacobian matrix and its invert
    dndli = dndl(:,2*i-1:2*i)';
%    xct   = xc';

    j = dndli * elcoord'; % [2 * 4] * [4 * 2]

    detj = det(j);

    invj = zeros(2);
    invj(1,1) =  j(2,2);
    invj(1,2) = -j(1,2);
    invj(2,1) = -j(2,1);
    invj(2,2) =  j(1,1);

    invj = invj / detj;

    % strain-disp matrix b
    
    if (strcmp(strtype,'PLANESTRESS') || strcmp(strtype,'PLANESTRAIN'))
        b = zeros(3,8);
        
        
        for j = 1 : 4
            dndg = invj * dndli(i,:)';

            subb = zeros(3,2);
            subb(1,1) = dndg(1,1);
            subb(2,2) = dndg(2,1);
            subb(3,1) = dndg(2,1);
            subb(3,2) = dndg(1,1);

            b(3,2*i-1:2*i) = subb;
        end
        
        ks  = ks + b' * D * b * wc(i) * detj;
    elseif (strcmp(strtype,'THINPLATE'))
        ierr = 1;
        return;
    else
        ierr = 1;
        return;
    end
    
end

% ks is ready
% calculate dof id

[dofloc] = gidtodofid(gi);

ke = zeros(24,24);

ldofloc = [1,2,7,8,13,14,19,20];

ke(ldocfloc,ldofloc) = ks;

end

