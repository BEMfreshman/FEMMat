function [model,ierr] = mats1reader(line,fid,model)
    
    ierr = 0;
    [wline,hasstr] = prepprocesstext(line,72);
    
    if (hasstr(2) == 0) 
        ierr = 1;
        return;
    end

    mid = 0;
    mid = f2d(wline,hasstr,2,mid);
    
    imattype = 101;
    msg = sprintf('Failed in parsing mats1 %d ',mid);
    
    tid = 0;
    tid = f2d(wline,hasstr,3,tid);
    
    itype = 0;    % 0 - NLELAST  1 - PLASTIC
    type = wline(24+1:24+8);
    if (strncmpi(type,'NLELAST',7))
        itype = 0;
    elseif(strncmpi(type,'PLASTIC',7))
        itype = 1;
    end
    
    h = 0.0;
    h = f2d(wline,hasstr,5,h);
    
    yf = 1;
    yf = f2d(wline,hasstr,6,yf);
    
    hr = 1;
    hr = f2d(wline,hasstr,7,hr);
    
    if (hasstr(8) == 0) 
        ierr = 1;
        return;
    end
    
    lit1 = 0.0;
    lit1 = f2d(wline,hasstr,8,lit1);  
    
    imats1 = [mid,imattype,model.ptmats(1),4,model.ptmats(2),1]';
    model.imats(:,model.ncmats) = imats1;
    model.ncmats = model.ncmats + 1;
    
    ipmats = [tid,itype,yf,hr]';
    model.ipmats(model.ptmats(1):model.ptmats(1)+4-1) = ipmats;
    
    rpmats = [h,lit1];
    model.rpmats(model.ptmats(1):model.ptmats(1)+2-1) = rpmats;
    
    model.ptmats(1) = model.ptmats(1) + 4;
    model.ptmats(2) = model.ptmats(2) + 2;
    
end