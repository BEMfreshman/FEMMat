function [model,ierr] = readfem(filename)
% read OS solver deck
%

ierr = 0;

% first time scan

[model,ierr] = filescan(filename);
if (ierr ~= 0)
    return;
end

% pre-allocate
[model,ierr] = modelallcoate(model);


% second time real read

[model,ierr] = fileread(filename);
if (ierr ~= 0)
    return;
end

end

