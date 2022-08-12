function [model,ierr] = pshellreader(line,fid,model)

    [wline,hasstr] = preprocesstext(line,72);

    if (hasstr(2) == 0) 
        ierr = 1;
    end

    pid = s2d(wline,2);

    sprintf(msg,'Failed in parsing pshell %d ',pid);

    mid = zeros(4,1);

    mid(1) = f2d(wline,hasstr,3,mid(1));

    t = 0.0;
    t = f2d(wline,hasstr,4,t);

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
    
end