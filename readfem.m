function [model,ierr] = readfem(filename,model)
% read OS solver deck
%

ierr = 0;

% first time scan

[model,ierr] = filescan(filename,model);
if (ierr ~= 0)
    return;
end

% pre-allocate
[model,ierr] = modelallocate(model);


% second time real read

[model,ierr] = fileread(filename,model);
if (ierr ~= 0)
    return;
end

end

