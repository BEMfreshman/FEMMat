function [model,ierr] = pplanereader(line,fid,model)
    
    ierr = 0;
    [wline,hasstr] = preprocesstext(line,32);
    
    if (hasstr(2) == 0)
        ierr =1;
        return;
    end
    
    pid = s2d(wline,2);
    
    iptype = 2;
    
    msg = sprintf('Failed in parsing pplane %d ',pid);
    
    mid = pid;
    mid = f2d(wline,hasstr,3,mid);
    
    t = 0.0;
    t = f2d(wline,hasstr,4,t);
    
    ptipprop = model.ptprop(1);
    ptrpprop = model.ptprop(2);
    
    iprop = [pid,iptype,ptipprop,1,ptrpprop,1]';
    model.iprop(:,model.ncprop) = iprop;
    model.ncprop = model.ncprop + 1;
    
    ipprop = mid;
    rpprop = t;
    
    model.ipprop(model.ptprop(1):model.ptprop(1)+1-1) = ipprop;
    model.rpprop(model.ptprop(2):model.ptprop(2)+1-1) = rpprop;

    model.ptprop(1) = model.ptprop(1) + 1;
    model.ptprop(2) = model.ptprop(2) + 1;

end