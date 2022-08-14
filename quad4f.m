function [fel,ldofloc,ierr] = quad4f(eid,ielem,iegrid,rgrid,ipelem,rpelem,...
                                    iprop,ipprop,rpprop,ipmat,rpmat,presid,...
                                    ipres,ippres,rppres)
   
ierr = 0;

coords = zeros(3,4);

ip_iegrid = ielem(3,eid);
ip_ipdata = ielem(4,eid);
ip_rpdata = ielem(6,eid);

idprop = ipelem(ip_ipdata);
ip_ipprop = iprop(3,idprop);

% all gi are internal id
gi = zeros(4,1);

for i = 1:4
   gi(i) = iegrid(ip_iegrid + i - 1);
   coords(:,i) = rgrid(:,gi(i));
end


imcid  = ipelem(ip_ipdata + 1); 

% only mid1 would be considered now  8-6
idmat1 = ipprop(ip_ipprop);
idmat2 = ipprop(ip_ipprop+1);
idmat3 = ipprop(ip_ipprop+2);
idmat4 = ipprop(ip_ipprop+3);

if (idmat1 ~=0 && (idmat2 == 0 || idmat2 == -1) && idmat3 == 0 && idmat4 == 0)
    % PLANE STRESS OR PLANE STRAIN
    
    if (idmat2 == -1) 
        strtype = 'PLANESTRAIN';
    else
        strtype = 'PLANESTRESS';
    end
    
elseif (idmat1 ~=0 && idmat2 ~=0 && idmat3 ==0 && idmat4 == 0)
    % THINPLATE or MINDLINPLATE
    
end

% % build shell coordinate system, however this trnsm is used to 
% % trans coord in element cord system to basic system
% [~,btoltrnsm] = shellcord(eid,ielem,iegrid,rgrid);
% 
% lcoords = btoltrnsm(1:3,1:3) * (coords - repmat(btoltrnsm(:,4),1,4));

iprestype = ipres(2,presid);
ip_ippres = ipres(3,presid);
ip_rppres = ipres(5,presid);

if (iprestype == 1 )
    % PLOAD1
    ierr = 1;
    return;
elseif (iprestype == 2) 
    % PLOAD2
    % to do 
    pres = rppres(ip_rppres);
    [fel,ierr] = shellf(strtype,eid,ielem,iegrid,rgrid,pres);
    if (ierr ~= 0)
        return;
    end
    
elseif (iprestype == 3)
    % PLOAD4
    cid = ippres(ip_ippres + 3);

    p = rppres(ip_ippres:ip_ippres+3);
    n = rppres(ip_ippres+4:ip_ipres+6);

    [fel,ierr] = shellfint(strtype,eid,ielem,iegrid,rgrid,cid,p,n);
    if (ierr ~= 0)
        return;
    end
end




end