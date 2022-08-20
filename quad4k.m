function [ke,dofloc,ierr] = quad4k(eid,ietype,ielem,iegrid,rgrid,ipelem,rpelem, ...
                              iprop,ipprop,rpprop,imat,ipmat,rpmat)

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

ip_iegrid = ielem(3,eid);
ip_ipdata = ielem(4,eid);
ip_rpdata = ielem(6,eid);

pid = ipelem(ip_ipdata);
ip_ipprop = iprop(3,pid);

% all gi are internal id
gi = zeros(4,1);

for i = 1:4
   gi(i) = iegrid(ip_iegrid + i - 1);
   coords(:,i) = rgrid(:,gi(i));
end

iptype = iprop(2,pid);
if (iptype == 1) then
    
    % PSHELL

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
    
elseif (iptype == 2)
    strtype = 'PLANESTRAIN';
else
    ierr = 1;
    return;
end

% build shell coordinate system, however this trnsm is used to 
% trans coord in element cord system to basic system
[~,btoltrnsm] = shellcord(eid,ielem,iegrid,rgrid);

lcoords = btoltrnsm(1:3,1:3) * (coords - repmat(btoltrnsm(:,4),1,4));

[D,ierr] = shellsmat(strtype,eid,ietype,ielem,ipelem,rpelem,pid,iprop,ipprop,...
                     rpprop,imat,ipmat,rpmat);
if (ierr ~= 0)
    return
end

[ke,dofloc,ierr] = shellk(strtype,D,gi,lcoords(1:2,:));
if (ierr ~= 0)
    return
end

end