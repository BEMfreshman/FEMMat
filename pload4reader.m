function [model,ierr] = pload4reader(line,fid,model)

    [wline,hasstr] = preprocesstext(line,72);

    if (hasstr(2) == 0 || hasstr(3) == 0)
        ierr = 1;
        disp('Failed in pload4 reader');
        return;
    end

    sid = s2d(wline,2);
    eid = s2d(wline,3);

    iprestype = 3;

    sprintf(msg,'Failed in parsing pload4 %d ',sid);

    if (hasstr(4) == 0) 
        ierr = 1;
        disp([msg,', p1 is empty']);
        return;
    end

    p1 = s2d(wline,4);
    p = repmat(p1,4,1);

    for i = 5:7
        if (hasstr(i) ~= 0)
            p(i - 3) = s2d(wline,i);
        end
    end

    g1 = 0;
    g34 = 0;

    if (hasstr(8) ~= 0)
        g1 = s2d(wline,8);
    end

    if (hasstr(9) ~= 0)
        g34 = s2d(wline,9);
    end

    line = getline(fid);

    keyword = line(1:8);
    kw = strtrim(keyword);
    if (strcmp(kw,'*')~=0)
       ierr = 1;
       disp([msg,', continuation line is empty']);
       return; 
    end

    [wline,hasstr] = preprocesstext(line,56);

    if (all(hasstr(3:5)) == 0) 
        ierr = 0;
        disp([msg,', there is one blank at least in N1 N2 N3']);
        return;
    end

    n = zeros(3,1);
    for i = 3:5
        n(i - 2) = s2d(wline,i);
    end

    sorl = 0.0;
    ldir = 0.0;

    ptippres = model.ptpres(1);
    ptrppres = model.ptpres(2);

    ip = [sid,iprestype,ptippres,4,ptrppres,9]';

    ippres = [eid,g1,g34,cid]';   % 4
    rppres = [p',n',sorl,ldir];   % 9

    model.ipres(:,model.ptpres) = ip;
    model.ptpres = model.prpres + 1;

    model.ippres(ptippres:ptippres+4) = ippres;
    model.rppres(ptrppres:ptrppres+9) = rppres;

    model.ptpres(1) = model.ptpres(1) + 4;
    model.ptpres(2) = model.ptpres(2) + 9;

    
end