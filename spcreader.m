function [model,ierr] = spcreader(line, fid, model)

    [wline,hasstr] = preprocesstext(line,64);

    ierr = 0;

    if(hasstr(2)==0)
        ierr = 1;
        return;
    end

    sid = s2d(wline,2);
    ispctype = 1;

    msg = sprintf('Failed in parsing spc %d ',sid);

    if (hasstr(3) == 0) 
        ierr = 1;
        disp([msg,', g1 is empty']);
        return;
    end

    g1 = s2d(wline,3);

    c1 = 0;
    d1 = 0;

    if (hasstr(4) ~= 0)
        c1 = s2d(wline,4);
    end

    if (hasstr(5) ~= 0)
        d1 = s2d(wline,5);
    end

    ispc = sid;
    ipspc = [g1,c1]';
    rpspc = d1;

    ptipspc = model.ptspc(1);
    ptrpspc = model.ptspc(2);

    model.ispc(:,model.ncspc) = [ispc,ispctype,ptipspc,2,ptrpspc,1]';
    model.ipspc(ptipspc:ptipspc + 2 - 1) = ipspc;
    model.rpspc(ptrpspc:ptrpspc + 1 - 1) = rpspc;

    model.ncspc = model.ncspc+1;

    model.ptspc(1) = model.ptspc(1) + 2;
    model.ptspc(2) = model.ptspc(2) + 1;

end