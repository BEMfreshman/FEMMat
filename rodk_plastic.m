function [ke,dofloc,r_cur,ierr] = rodk_plastic(eid,ietype,model,nlstat)
%% variable
%  model:
%    rgrid
%    ielem  iegrid  ipelem rpelem
%    iprop  ipprop  rpprop
%    imat rpmat imats ipmats rpmast
%    
%  nlstat:
%    n_subiter
%    disp_last_time_step
%    disp_cur_last_iter
%    disp_cur

%%
    ierr = 0;
    negrid = 3;

    cu = nlstat.disp_cur;
    ou = nlstat.disp_cur_last_iter;
    u  = nlstat.disp_last_time_step;

    rgrid = model.rgrid;
    ielem = model.ielem;
    ipelem = model.ipelem;
    iprop = model.iprop;
    rpmat = model.rpmat;

    negrid = model.negrid;
    
    coords = zeros(negrid,2);
    
    ip_iegrid = ielem(3,eid);
    ip_ipdata = ielem(4,eid);
    ip_rpdata = ielem(6,eid);

    pid = ipelem(ip_ipdata);
    ip_ipprop = iprop(3,pid);
    
    gi = zeros(negrid,1);

    for i = 1:negrid
       gi(i) = iegrid(ip_iegrid + i - 1);
       coords(:,i) = rgrid(:,gi(i));
    end
    
    iptype = iprop(2,pid);
    if (iptyep ~= 3)
        ierr = 1;
        return;
    end
    
    ip_ipprop = iprop(3,mid);
    mid       = ipprop(ip_ipprop);

    imattype  = imat(2,mid);
    ip_ipmat  = imat(3,mid);

    if (imattype == 1) 
        % mat1
        msid = ipmat(ip_ipmat); 
    else
        ierr = 1;
        return;
    end

    if (msid == 0)
        % no mats1 material
        disp('no mats1 was found');
        ierr = 1;
        return;
    end

    % key mats1 parameter
    ip_ipmats = imats(3,msid);
    ip_rpmats = imats(5,msid);

    tid       = ipmats(ip_ipmats);
    mats1type = ipmats(ip_ipmats+1);
    yf        = ipmats(ip_ipmats+2);
    hr        = ipmats(ip_ipmats+3);

    h    = rpmats(ip_rpmats);
    lit1 = rpmats(ip_rpmats+1);

    [~,btoltrnsm] = linecord(eiid,ielem,iegrid,...
                                 rgrid);

    lcoords = btoltrnsm(1:3,1:3) * ...
        (coords - repmat(btoltrnsm(:,negrid),1,negrid));
        
    
    % rod dir vector
    dir = coord(:,2) - coord(:,1);
    
    rodlen = norm(dir,2);

    dir = dir / rodlen;  % normalize

    oue = getdsp(ou,gi);
    ue  = getdsp(u,gi);

    oue2 = reshape(oue,[],2);   % [x,y,z;rx;ry;rz];

    strn = oue2 * dir;   % [xyz_strn; rxryrz_strn];
                         % basically, rotation/torsion have not been
                         % consider here, only strn(1) would be used.

    %% trial stress and real stress
    E = rpmat(mid);
    strs_trial = E * strn(1);
    
    if (h == 1)
        % iso hardening 
        
        if_yield = (strs_trial - lit1 > 0.0);
        
        if (if_yield)
            
        else
            
        end
        
    else
        ierr = 1;
        disp('only iso hardening is supported');
        return;
    end
    
end