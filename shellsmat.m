function [D, ierr] = shellsmat(strtype,eiid,ielem,ipelem,rpelem,piid,...
                                iprop,ipprop,rpprop,imat,ipmat,rpmat)
%SHELLSMAT is used to calculate material matrix D

ip_ipelem = ielem(5,eiid);
ip_rpelem = ielem(7,eiid);

% iptype    = iprop(3,piid);
ip_ipprop = iprop(4,piid);
rp_ipprop = iprop(6,piid);

if (ietype == 3)
    % quad4
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

    hast = ipprop(ip_ipprop + 4);
    tinpshell = rpprop(rp_ipprop);

    if (hast ~= 0) 
        t1 = t1 * tinpshell;
        t2 = t2 * tinpshell;
        t3 = t3 * tinpshell;
        t4 = t4 * tinpshell;
    end

    athick = t1 + t2 + t3 + t4;
    athick = athick / 4.0;
elseif (ietype == 2)
    % tria3
    
end

imat1 = ipprop(ip_ipprop);

imattype = imat(2,imat1);

E   = rpmat(imat1);
G   = rpmat(imat1 + 1);
Nu  = rpmat(imat1 + 2);
% RHO = rpmat(imat1 + 3);

ierr = 0;

if (imattype == 1)
    % MAT1
    
    if (strcmp(strtype,'PLANESTRESS'))
        D = eye(3,3);
        coeff = E / (1 - Nu* Nu);
        
        D(1,2) = Nu;
        D(2,1) = Nu;
        
        D(3,3) = (1-Nu) / 2.0;
        
        D = coeff * D;
    elseif (strcmp (strtype,'PLANESTRAIN'))
        D = eye(3,3);
        coeff = E * (1 - Nu)/ ((1 - 2 * Nu) * (1 + Nu));
        
        D(1,2) = Nu / (1 - Nu);
        D(2,1) = Nu / (1 - Nu);
        
        D(3,3) = (1 - 2 * Nu) / (2 * (1 - Nu));
        
        D = coeff * D;
    elseif (strcmp(strtype,'THINPLATE'))
        D = eys(3,3);
        coeff = E * athick^3 / (12*(1-Nu^2));
        
        D(1,2) = Nu;
        D(2,1) = Nu;
        
        D(3,3) = (1 - Nu) / 2.0;
        
        D = coeff * D;
        
    elseif(strcmp(strtype,'MINDLINPLATE'))
        
        
    elseif (strcmp(strtype,'THINSHELL'))
    
    
    % Wang XuCheng "Finite Element Method" P382
    
        D = eye(6,6);
        coeff = E * athick / (1 - Nu * Nu);


        D(1,2) = Nu;
        D(2,1) = Nu;

        D(3,3) = (1- Nu) / 2;

        D(4,4) = athick * athick / 12;
        D(4,5) = athick * athick * Nu / 12;

        D(5,4) = athick * athick * Nu / 12;
        D(5,5) = athick * athick / 12;

        D(6,6) = athick * athick * (1 - Nu) / 24;

        D = coeff * D;
        
    elseif (strcmp(strtype,'MINDLINSHELL')) 
        
    else
        ierr = 1;
    end
    
end

end

