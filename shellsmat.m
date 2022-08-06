function [D, ierr] = shellsmat(idprop,iprop,ipdata,rpdata,imat,ipmat,rpmat)
%SHELLSMAT is used to calculate material matrix D

iptype   = iprop(3,idprop);
ip_iprop = iprop(4,idprop);

imat1 = ipprop(ip_prop);

imattype = imat(3,imat1);

E   = rpmat(imat1);
G   = rpmat(imat1 + 1);
NU  = rpmat(imat1 + 2);
RHO = rpmat(imat + 3);

if (imattype == 1)
    % MAT1
    
end

end

