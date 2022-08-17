function [model,ierr] = cqpstnreader(line,fid,model)
    
    [wline,hasstr] = prepprocesstext(line,56); % 4 node cqpstn
    
    ierr = 0;
    
    ietype = 4;
    
    eid = 0;
    if (hasstr(2) == 0)
        ierr = 0;
        disp('Failed in parsing cqpstn, eid is empty');
        return;
    end
    
    eid = f2d(wline,hasstr,2,eid);
    msg = sprintf('Failed in parsing cqpstn %d ',eid);
    
    pid = eid;
    pid = f2d(wline,hasstr,3,pid);
    
    gi = zeros(4,1);
    
    if (all(hasstr(4:7,1)) == 0)
        ierr = 1;
        disp([msg, ' gi has empty fields']);
        return;
    end
    
    for i = 4:7
        gi(i-3) = s2d(wline,i);
    end
    
    ptiegrid = model.ptelem(1);
    ptipelem = model.ptelem(2);
    ptrpelem = model.ptelem(3);
    
    iele = [eid,ietype,ptiegrid,ptipelem,1,ptrpelem,0]';
    
    ncelem = model.ncelem;
    model.ielem(:,ncelem) = iele;
    model.ncelem = model.ncelem + 1;
    
    model.iegrid(ptiegrid:ptiegrid+4-1) = gi;
    
    ip = [pid];
    model.ipelem(ptipelem:ptipelem+1-1) = ip;
    
    ptiegrid = ptiegrid + 4;
    ptipelem = ptipelem + 1;
    ptrpelem = ptrpelem + 0;
    
    model.ptelem = [ptiegrid,ptipelem,ptrpelem]';

end