function [model,ierr] = pshellreader(line,fid,model)

    ierr = 0;
    [wline,hasstr] = preprocesstext(line,72);

    if (hasstr(2) == 0) 
        ierr = 1;
        return;
    end

    pid = s2d(wline,2);

    iptype = 1;

    msg = sprintf('Failed in parsing pshell %d ',pid);

    mid = zeros(4,1);

    mid(1) = f2d(wline,hasstr,3,mid(1));

    t = 0.0;
    t = f2d(wline,hasstr,4,t);
    tflag = 0;
    if (hasstr(4) ~= 0)
        tflag = 1;
    end

    mid(2) = f2d(wline,hasstr,5,mid(2));

    i12t3 = 1.0;
    i12t3 = f2d(wline,hasstr,6,i12t3);

    mid(3) = 0;
    mid(3) = f2d(wline,hasstr,7,mid(3));

    tst = 0.83333;
    tst = f2d(wline,hasstr,8,tst);

    nsm = 0.0;
    nsm = f2d(wline,hasstr,9,nsm);

    z1 = 0;
    z2 = 0;

    ptipprop = model.ptprop(1);
    ptrpprop = model.ptprop(2);

    iprop = [pid,iptype,ptipprop,5,ptrpprop,6]';
    model.iprop(:,model.ncprop) = iprop;
    model.ncprop = model.ncprop + 1;

    ipprop = [mid;tflag];
    rpprop = [t,i12t3,tst,nsm,z1,z2]';

    model.ipprop(model.ptprop(1):model.ptprop(1)+5-1) = ipprop;
    model.rpprop(model.ptprop(2):model.ptprop(2)+6-1) = rpprop;

    model.ptprop(1) = model.ptprop(1) + 5;
    model.ptprop(2) = model.ptprop(2) + 6;
end