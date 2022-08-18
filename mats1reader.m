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
    
    imats1 = [mid,imattype,model.ptmat(1),4,model.ptmat(2),1]';
    model.imat(:,model.ncmat) = imats1;
    model.ncmat = model.ncmat + 1;
    
    ipmat = [tid,itype,yf,hr]';
    model.ipmat(model.ptmat(1):model.ptmat(1)+4-1) = ipmat;
    
    rpmat = h;
    model.rpmat(model.ptmat(1):model.ptmat(1)+1-1) = rpmat;
    
    model.ptmat(1) = model.ptmat(1) + 4;
    model.ptmat(2) = model.ptmat(2) + 1;
    
end