function [D, ierr] = shellsmat(eiid,ielem,ipelem,rpelem,piid,iprop,ipprop,rpprop,imat,ipmat,rpmat)
%SHELLSMAT is used to calculate material matrix D

ip_ipelem = ielem(5,eiid);
ip_rpelem = ielem(7,eiid);

iptype    = iprop(3,piid);
ip_ipprop = iprop(4,piid);
rp_ipprop = iprop(6,piid);

tflag = ipelem(ip_ipelem + 3);
t1 = 0;
t2 = 0;
t3 = 0;
t4 = 0;

if (tflag ~= 0) 
    t1 = rpelem(ip_rpelem + 2);
    t2 = rpelem(ip_rpelem + 3);
    t3 = rpelem(ip_rpelem + 4);
    t4 = rpelem(ip_rpelem + 5);
end

tinpshell = rpprop(rp_ipprop);




imat1 = ipprop(ip_ipprop);

imattype = imat(3,imat1);

E   = rpmat(imat1);
G   = rpmat(imat1 + 1);
NU  = rpmat(imat1 + 2);
RHO = rpmat(imat1 + 3);

ierr = 0;

if (imattype == 1)
    % MAT1
    % Wang XuCheng "Finite Element Method" P382
    
    D = zeros(6,6);
end

end

