function [model,ierr] = mat1reader(line,fid,model)

    ierr = 0;
    [wline,hasstr] = preprocesstext(line,72);

    if (hasstr(2) == 0) 
        ierr = 1;
        return;
    end

    mid = 0;
    mid = f2d(wline,hasstr,2,mid);

    imattype = 1;
    msg = sprintf('Failed in parsing mat1 %d ',mid);

    E = 0;
    G = 0;
    Nu = 0;
    RHO = 0;
    A = 0;
    TREF = 0;
    GE = 0;

    E = f2d(wline,hasstr,3,E);
    G = f2d(wline,hasstr,3,G);
    Nu = f2d(wline,hasstr,3,Nu);
    RHO = f2d(wline,hasstr,3,RHO);
    A = f2d(wline,hasstr,3,A);

    imat = [mid,imattype,model.ptmat(1),0,model.ptmat(2),7];
    model.imat(:,model.ncmat) = imat;
    model.ncmat = model.ncmat + 1;

    rpmat = [E,G,Nu,RHO,A,TREF,GE]';
    model.rpmat(model.ptmat(2):model.ptmat(2)+7-1) = rpmat;

    model.ptmat(2) = model.ptmat(2) + 7;

end