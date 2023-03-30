function [model,ierr] = prodreader(line,fid,model)
    
    ierr = 0;
    [wline,hasstr] = preprocesstext(line,72);
    
    if (hasstr(2) == 0)
        ierr = 1;
        return;
    end
    
    pid = s2d(wline,2);
    
    iptype = 3;
    msg = sprintf('Failed in parsing prod %d ',pid);
    
    mid = pid;
    
    mid = f2d(wline,hasstr,3,mid);
    
    a = 0.0;
    j = 0.0;
    c = 0.0;
    nsm = 0.0;
    
    if (hasstr(4) == 0 || hasstr(5) == 0) 
        ierr = 1;
        disp(msg);
        disp("A or J is empty");
        return;
    end
    
    a = f2d(wline,hasstr,4,a);
    j = f2d(wline,hasstr,5,j);
    c = f2d(wline,hasstr,6,c);
    nsm = f2d(wline,hasstr,7,nsm);
    
    ptipprop = model.ptprop(1);
    ptrpprop = model.ptprop(2);
    
    iprop = [pid,iptype, ptipprop,1,ptrpprop,4];
    
    model.iprop(:,model.ncprop) = iprop;
    model.ncprop = model.ncprop + 1;
    
    ipprop = [mid];
    rpprop = [a,j,c,nsm]';
    
    model.ipprop(model.ptprop(1):model.ptprop(1)+1-1) = ipprop;
    model.rpprop(model.ptprop(2):model.ptprop(2)+4-1) = rpprop;
    
    model.ptprop(1) = model.ptprop(1) + 1;
    model.ptprop(2) = model.ptprop(2) + 4;
    

end