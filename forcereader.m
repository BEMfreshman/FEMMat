function [model,ierr] = forcereader(line,fid, model)
    
    [wline,hasstr] = preprocesstext(line,64);

    ierr = 0;

    if (hasstr(2) == 0) 
        ierr = 1;
        disp('Failed in force reader');
        return;
    end

    ifrctype = 1;

    sid = 0;
    sid = f2d(wline,hasstr,2,sid);

    msg = sprintf('Failed in parsing force %d ',sid);

    if (hasstr(3) == 0)
        ierr = 1;
        disp([msg,', g is empty']);
        return;
    end
    
    g = 0;
    g = f2d(wline,hasstr,3,g);

    cid = 0;
    cid = f2d(wline,hasstr,4,cid);

    f = 0.0;
    n = zeros(3,1);

    f = f2d(wline,hasstr,5,f);

    for i = 6:8
        n(i-5) = f2d(wline,hasstr,i,n(i-5));
    end

    ptipfrc = model.ptfrc(1);
    ptrpfrc = model.ptfrc(2);

    ip = [sid,ifrctype,ptipfrc,2,ptrpfrc,4]';

    ipfrc = [g,cid]';
    rpfrc = [f;n];

    model.ifrc(:,model.ncfrc) = ip;
    model.ncfrc = model.ncfrc + 1;

    model.ipfrc(ptipfrc:ptipfrc+2-1) = ipfrc;
    model.rpfrc(ptrpfrc:ptrpfrc+4-1) = rpfrc;

    model.ptfrc(1) = model.ptfrc(1) + 2;
    model.ptfrc(2) = model.ptfrc(2) + 4;

end