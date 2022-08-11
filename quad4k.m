function [ke,dofloc,ierr] = quad4k(eiid,ielem,iegrid,rgrid,ipelem,rpelem, ...
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

ip_iegrid = ielem(3,eiid);
ip_ipdata = ielem(4,eiid);
ip_rpdata = ielem(6,eiid);

idprop = ipelem(ip_ipdata);
ip_ipprop = iprop(4,idprop);

% all gi are internal id
gi = zeros(4,1);

for i = 1:4
   gi(i) = iegrid(ip_iegrid + i - 1);
   coords(:,i) = rgrid(:,gi(i));
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
[~,btoltrnsm] = shellcord(eid,ielem,iegrid,rgrid);

lcoords = btoltrnsm(1:3,1:3) * (coords - repmat(btoltrnsm(:,4),1,4));

[D,ierr] = shellsmat(strtype,eiid,ielem,ipelem,rpelem,piid,iprop,ipprop,...
                     rpprop,imat,ipmat,rpmat);
if (ierr ~= 0)
    return
end

[ke,dofloc,ierr] = shellk(strtype,D,gi,lcoords(1:2,:));
if (ierr ~= 0)
    return
end

end