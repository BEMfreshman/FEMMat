function [fel,ldofloc,ierr] = quad4f(eid,ielem,iegrid,rpgrid,ipelem,rpelem,...
                                    ipprop,rpprop,ipmat,rpmat,presid,...
                                    wipres,wippres,wrppres)
   
ierr = 0;

coords = zeros(3,4);

ip_iegrid = ielem(4,eiid);
ip_ipdata = ielem(5,eiid);
ip_rpdata = ielem(7,eiid);

idprop = ipelem(ip_ipdata);
ip_ipprop = iprop(4,idprop);

% all gi are internal id
gi = zeros(4,1);

for i = 1:4
   gi(i) = iegrid(ip_iegrid + i - 1);
   coords(:,i) = rpgrid(:,gi(i));
end


imcid  = ipelem(ip_ipdata + 1); 

% only mid1 would be considered now  8-6
imat1 = ipprop(ip_ipprop);
imat2 = ipprop(ip_ipprop+1);
imat3 = ipprop(ip_ipprop+2);
imat4 = ipprop(ip_ipprop+3);

if (imat1 ~=0 && (imat2 == 0 || imat2 == -1) && imat3 == 0 && imat4 == 0)
    % PLANE STRESS OR PLANE STRAIN
    
    if (imat2 == -1) 
        strtype = 'PLANESTRAIN';
    else
        strtype = 'PLANESTRESS';
    end
    
elseif (imat1 ~=0 && imat2 ~=0 && imat3 ==0 && imat4 == 0)
    % THINPLATE or MINDLINPLATE
    
end

% build shell coordinate system, however this trnsm is used to 
% trans coord in element cord system to basic system
[~,btoltrnsm] = shellcord(eid,ielem,iegrid,rpgrid);

lcoords = btoltrnsm(1:3,1:3) * (coords - repmat(btoltrnsm(:,4),1,4));


iprestype = wipres(2,presid);
ip_ippres = wipres(3,presid);
ip_rppres = wipres(5,presid);

if (iprestype == 1 )
    % PLOAD1
    ierr = 1;
    return;
elseif (iprestype == 2) 
    % PLOAD2

    pres = wrppres(ip_rppres);
    [fel,ldofloc,ierr] = shellf(strtype,eid,ielem,iegrid,rpgrid,pres);
    
elseif (iprestype == 3)
    % PLOAD4
    ierr = 1;
    return;
end




end