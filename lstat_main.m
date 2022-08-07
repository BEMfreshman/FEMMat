function [disp,ierr] = lstat_main(model)
%
% linear static analysis function
%

nstsub = model.nstsub;
istsub = model.istsub;

nelem = model.nelem;
ielem = model.ielem;

ngrid = model.ngrid;

for iload = 1:nstsub
    if (istsub(3,1) ~= 1) 
        % skip nonlinear
        continue
    end
    
    % build stiffness matrix
    for ie = 1: nelem
        eiid   = ielem(1,ie);
        euid   = ielem(2,ie);
        ietype = ielem(3,ie);
        if (ietype == 3)
            % quad4
            [ke,ierr] = quad4(eiid,model.ielem,model.iegrid,model.rpgrid,...
                              model.ipelem,model.rpelem,model.ipprop,...
                              model.rpprop,model.ipmat,model.rpmat);
            if (ierr ~=0) 
                return; 
            end
                
            
        end
        
    end
    
end

ierr = 0;
end

