function [disp,ierr] = lstat_main(model)
%
% linear static analysis function
%

nstsub = model.nstsub;
istsub = model.istsub;

nelem = model.nelem;
ielem = model.ielem;

for iload = 1, nstsub
    if (istsub(3,1) ~= 1) 
        % skip nonlinear
        continue
    end
    
    
    for ie = 1, nelem
        ietype = ielem(3,ie);
        if (ietype == 3)
            % quad4
            
        end
        
    end
    
end

ierr = 0;
end

