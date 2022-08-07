function [ke,ierr] = quad4(eiid,ielem,iegrid,rpgrid,ipelem,rpelem, ...
                              ipprop,rpprop,ipmat,rpmat)

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
[ltobtrnsm] = shellcord(eid,ielem,iegrid,rpgrid);

btoltrnsm = zeros(3,4);
btoltrnsm(1:3,1:3) = ltobtrnsm(1:3,1:3)';
btoltrnsm(:,4) = ltobtrnsm(:,4);

lcoords = btoltrnsm(1:3,1:3) * (coords - repmat(btoltrnsm(:,4),1,4));

[D,ierr] = shellsmat(strtype,eiid,ielem,ipelem,rpelem,piid,iprop,ipprop,...
                     rpprop,imat,ipmat,rpmat);
if (ierr ~= 0)
    return
end

[ke,ierr] = shellk(strtype,D,lcoords(1:2,:));
if (ierr ~= 0)
    return
end




end