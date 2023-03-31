function [kel,dofloc,ierr] = rodk(eid,ietype,model)
%%
% format of ipelem for rod
%             (1,) - pid

% format of ipprop for prod
%             (1,) - mid

%%

ierr = 0;

ielem  = model.ielem;
iprop  = model.iprop;
ipelem = model.ipelem;
iegrid = model.iegrid;
rpmat  = model.rpmat;
rpprop = model.rpprop;


rgrid = model.rgrid;

ip_iegrid = ielem(3,eid);
ip_ipdata = ielem(4,eid);
ip_rpdata = ielem(6,eid);

pid = ipelem(ip_ipdata);
ip_ipprop = iprop(3,pid);
rp_ipprop = iprop(5,pid);

mid = iprop(ip_ipprop);
kel = zeros(12,12);

% coords
coords = zeros(3,2);
gi = zeros(2,1);

for i = 1 : 2
    gi(i) = iegrid(ip_iegrid + i - 1);
    coords(:,i) = rgrid(:,gi(i));
end

dis = norm(coords(:,1) - coords(:,2),2);

% mat prop
E = rpmat(mid);

% eleprop 
A = rpprop(rp_ipprop);

cons = E * A / dis;

kel(1,1) =  cons;
kel(1,7) = -cons;
kel(7,1) = -cons;
kel(7,7) =  cons;

[dofloc] = gidtodofid(gi);

end