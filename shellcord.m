function [trnsm] = shellcord(eid,ielem,iegrid,rpgrid)
% trnsm (3,4)
% trnsm (1:3,1:3) - rotational transformation mtx
% trnsm (1:3,4)   - orginal point

% {x}b = {x}0 + [T]{x}l   ==> global  =  origin + trnsm * local
% T * T' = T' * T = I;

ip_iegrid = ielem(4,eid);

coords = zeros(3,4);

for i = 1:4
    gi = iegrid(ip_iegrid + i - 1);
    coords(:,i) = rpgrid(:,gi);
end

trnsm = zeros(3,4);

% the first point is the original point
% the 1st and 2nd point to define x axis
% the 3rd point locate in x-y plane

trnsm(:,4) = coords(:,1);


vecx = coords(:,2) - coords(:,1);
vecx = normalize(vecx);

fakey = coords(:,3) - coords(:,1);
fakey = normalize(fakey);

vecz = cross(vecx,fakey);
vecz = normalize(vecz);

vecy = cross(vecx,vecz);
vecy = normalize(vecy);

trnsm(:,1) = vecx;
trnsm(:,2) = vecy;
trnsm(:,3) = vecz;




end

