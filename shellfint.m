function [fe,dofloc,ierr] = shellfint(strtype,eid,ielem,iegrid,rgrid,cid,p,n)

% cid and n are not used in this subroutine 8-13

ietype    = ielem(2,eid);
ip_iegrid = ielem(3,eid);

if(ietype == 3)
    % cquad4
    gi = zeros(4,1);
    coords = zeros(3,4);

    for i = 1: 4
        gi(i) = iegrid(ip_iegrid + i - 1);
        coords(:,i) = rgrid(:,gi(i));
    end
else
    ierr = 1;
    return;
end

% generate gauss points

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

[nfun,dndl,ierr] = quad4nfun(strtype,xc);
% nfun(4,n)
if (ierr ~= 0)
    return;
end

[~,btoltrnsm] = shellcord(eid,ielem,iegrid,rgrid);

lcoords = btoltrnsm(1:3,1:3) * (coords - repmat(btoltrnsm(:,4),1,4));
elcoord = lcoords(1:2,:);  % elcoord in ele coordinate

fe = zeros(24,1);

fs = zeros(4,1);   % z axis of 4 point

for i = 1:ngint
    
    dndli = dndl(:,2*i-1:2*i)';
    
    j = dndli * elcoord';
    detj = det(j);

    pres = p' * nfun(:,i);

    fs = fs + nfun(:,i) * pres * wc(i) * detj;
end

ldofloc = [3,9,15,21];
fe(ldofloc) = fs;

dofloc = gidtodofid(gi);


end