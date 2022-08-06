function [ske,f,ierr] = quad4(uid,iid,ielem,iegrid,rpgrid,ipelem,rpelem, ...
                              ipprop,rpporp,ipmat,rpmat)

%%
% format of ipelem for quad4
%            (1,.) - pid
%            (2,.) - mcid
%            (3,.) - tflag


% format of ipprop for pshell
%            (1,.) - mid1
%            (2,.) - mid2
%            (3,.) - mid3
%            (4,.) - mid4
%%
                          
ierr= 0;

coords = zeros(3,4);

ip_iegrid = ielem(4,iid);
ip_ipdata = ielem(5,iid);
ip_rpdata = ielem(7,iid);

idprop = ipelem(ip_ipdata);
ip_ipprop = iprop(4,idprop);

% all gi are internal id
gi = zeros(4,1);

for i = 1, 4;
   gi(i) = iegrid(ip_iegrid + i - 1);
   coords(:,i) = rpgrid(:,gi(i));
end


imcid  = ipelem(ip_ipdata + 1); 

% only mid1 would be considered now  8-6
imat1 = ipprop(ip_ipprop);








end