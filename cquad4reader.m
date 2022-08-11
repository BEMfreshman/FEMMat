function [model,ierr] = cquad4reader(line,fid,model)

    [wline,hasstr] = preprocesstext(line,72);

    ierr = 0;

    ietype = 3;

    eid = 0;  
    if (hasstr(2) == 0) 
        ierr = 1;
        disp('Failed in parsing cquad4, eid is empty');
        return;
    end

    sprintf(msg,'Failed in parsing cquad %d ',eid);

%    eid = s2d(wline,2);

    pid = eid;
    if (hasstr(3) ~= 0)
        pid = s2d(wline,3);
    end

    gi = zeros(4,1);

    if (all(hasstr(4:7,1)) == 0) 
        ierr = 1;
        disp([msg, 'gi has empty fields']);
        return;
    end

    for i = 4:7
        gi(i-3) = s2d(wline,i);
    end

    mcid  = 0;
    mcid_flag =0;
    theta = 0.0;
    num8 = s2d(wline,8);
    if (int32(num8) == num8)
        % integer
        mcid = num8;
        mcid_flag = 1;
    else
        theta = num8;
    end

    tflag = 0;

    t = zeros(4,1);
    zoffs = 0.0;

    ptiegrid = model.ptelem(1);
    ptipelem = model.ptelem(2);
    ptrpelem = model.ptelem(3);

    iele = [id,ietype,ptiegrid,ptipelem,4,ptrpelem,6]';

    ptelem = model.ptelem;
    model.ielem(:,ptelem) = iele;
    model.ptelem = model.ptelem + 1;

    model.iegrid(ptiegrid:ptiegrid+4) = gi;
    
    ip = [pid,mcid_flag,mcid,tflag]';
    model.ipelem(ptipelem:ptipelem+4) = ip;

    rp = [theta,zoffs,t]';
    model.rpelem(ptrpelem:ptrpelem+6) = rp;
    
    ptiegrid = ptiegrid + 4;
    ptipelem = ptipelem + 4;
    ptrpelem = ptrpelem + 6;

    model.ptelem = [ptiegrid,ptipelem,ptrpelem]';

end