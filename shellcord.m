function [ltobtrnsm,btoltrnsm] = shellcord(eid,ielem,iegrid,rgrid)
% ltobtrnsm (3,4)
% ltobtrnsm (1:3,1:3) - rotational transformation mtx
% ltobtrnsm (1:3,4)   - orginal point

% {x}b = {x}0 + [ltobtrnsm]{x}l   ==> basic  =  origin + trnsm * local
% ltobtrnsm * ltobtrnsm' = ltobtrnsm' * ltobtrnsm = I;

ip_iegrid = ielem(3,eid);

coords = zeros(3,4);

for i = 1:4
    gi = iegrid(ip_iegrid + i - 1);
    coords(:,i) = rgrid(:,gi);
end

ltobtrnsm = zeros(3,4);

% the first point is the original point
% the 1st and 2nd point to define x axis
% the 3rd point locate in x-y plane

ltobtrnsm(:,4) = coords(:,1);


vecx = coords(:,2) - coords(:,1);
vecx = vecx / norm(vecx);

fakey = coords(:,3) - coords(:,1);
fakey = fakey / norm(fakey);

vecz = cross(vecx,fakey);
vecz = vecz / norm(vecz);

vecy = cross(vecz,vecx);
vecy = vecy / norm(vecy);

ltobtrnsm(:,1) = vecx;
ltobtrnsm(:,2) = vecy;
ltobtrnsm(:,3) = vecz;


btoltrnsm = zeros(3,4);
btoltrnsm(1:3,1:3) = ltobtrnsm(1:3,1:3)';
btoltrnsm(:,4) = ltobtrnsm(:,4);

end

