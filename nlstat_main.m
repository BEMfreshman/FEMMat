function [disp,ierr] = nlstat_main(model)
%
% nonlinear static analysis function
%

nstsub = model.nstsub;
istsub = model.istsub;

nelem = model.nelem;
ielem = model.ielem;

ngrid = model.ngrid;
nspc  = model.nspc;

spak = sparse(ngrid*6,ngrid*6);
spaf = sparse(ngrid*6,1);

% nonlinear state
nlstat.itime = 0;

nlstat.rtime_last = 0.0;
nlstat.rtime_cur  = 0.0;
nlstat.n_iter = 0;
nlstat.n_subiter = 0;


disp = 0;

for iload = 1:nstsub
    if(istsub(2,iload) ~= 2)
        continue;
    end
    
    loadiid = istsub(3,iload);
    loaduid = istsub(4,iload);
    spciid  = istsub(5,iload);
    
    nlparmid = istsub(6,iload);
    
    maxiter = model.inlparm(3,nlparmid);
    
    step_time = 1.0/maxiter;

    while(nlstat.n_iter <= maxiter)
    
        % incr start
        nlstat.rtime_last = nlstat.rtime_cur;
        nlstat.rtime_cur  = nlstat.rtime_cur + step_time;
        if (nlstat.rtime_cur > 1.0)
            nlstat.rtime_cur = 1.0;
        end
    
        
    
    
    
    end
end

end