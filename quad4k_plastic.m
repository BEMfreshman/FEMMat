function [ke,dofloc,r_cur,ierr] = quad4k_plastic(eid,ietype,ielem,iegrid,rgrid,ipelem,rpelem, ...
                              iprop,ipprop,rpprop,imat,ipmat,rpmat,...
                              imats,ipmats,rpmats,n_subiter,u,du)
    % build tangent stiffness matrix
    % reference Ying Youquan book 3-6-25 for its meaning
    % Book Name <Nonlinear Finite Element Method fundament> 
    % (This is a Chinese book)
     
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
    if (iptype == 1)
        
        ierr = 1;    % 8-23 skip PSHELL for plastic analysis
        return;

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
        
        % PPLANE
        strtype = 'PLANESTRAIN';
        
        ip_ipprop = iprop(3,pid);
        mid     = ipprop(ip_ipprop);

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
        
        % build shell coordinate system, however this trnsm is used to 
        % trans coord in element cord system to basic system
        [~,btoltrnsm] = shellcord(eid,ielem,iegrid,rgrid);

        lcoords = btoltrnsm(1:3,1:3) * (coords - repmat(btoltrnsm(:,4),1,4));

        [D,ierr] = shellsmat(strtype,eid,ietype,ielem,ipelem,rpelem,pid,iprop,ipprop,...
                              rpprop,imat,ipmat,rpmat);
        if (ierr ~= 0)
            return
        end

        [ke,dofloc,r_cur,ierr] = shellk_plastic(strtype,D,gi,lcoords,tid,...
                            mats1type,yf,hr,h,lit1,btoltrnsm,n_subiter,u,du);
        if (ierr ~= 0)
            return
        end
    else
        ierr = 1;
        return;
    end

    
end