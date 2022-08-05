function [disp,ierr] = lstat_main(model)
%
% linear static analysis function
%

nstsub = model.nstsub;
istsub = model.istsub;

for iload = 1, nstsub
    if (istsub(3,1) ~= 1) 
        continue
    end
    
    

ierr = 0;
end

