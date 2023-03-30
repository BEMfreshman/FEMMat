function [model, ierr] = crodreader(line, fid, model)
    [wline, hasstr] = preprocesstext(line,72);
    
    ierr = 0;
    
    ietype = 1;
    
    eid = 0;
    
    if (hasstr(2) == 0)
        ierr = 1;
        disp("Failed in parsing crod, eid is empty");
        return;
    end
    
    eid = f2d(wline,hasstr,2,eid);
    msg = sprintf('Failed in parsing crod %d ',eid);
    
    pid = eid;
    if (hasstr(3) ~= 0)
        pid = s2d(wline,3);
    end
    
    gi = zeros(2,1);
    
    if (all(hasstr(4:5,1)) == 0) 
        ierr = 1;
        disp([msg, 'gi has empty fields']);
        return;
    end
    
    for i = 4:5
        gi(i-3) = s2d(wline,i);
    end
    
    ptiegrid = model.ptelem(1);
    ptipelem = model.ptelem(2);
    ptrpelem = model.ptelem(3);
    
    iele = [eid,ietype,ptiegrid,ptipelem,1,ptrpelem,0]';
    
    ncelem = model.ncelem;
    model.ielem(:,ncelem) = iele;
    model.ncelem = model.ncelem + 1;
    
    model.iegrid(ptiegrid:ptiegrid+2-1) = gi;
    
    ip = [pid];
    model.ipelem(ptipelem:ptipelem+1-1) = ip;
    
    ptiegrid = ptiegrid + 2;
    ptipelem = ptipelem + 1;
    ptrpelem = ptrpelem + 0;
    
    model.ptelem = [ptiegrid,ptipelem,ptrpelem]';

end