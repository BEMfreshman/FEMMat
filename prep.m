function [model,ierr] = prep(model)
    ierr = 0;

    % deal with force ploadx and spc

    [model,ierr] = prepspc(model);
    if (ierr ~= 0) 
        return;
    end

%     [model,ierr] = prepforce(model);
%     if (ierr ~= 0)
%         return;
%     end

    [model,ierr] = prepploadx(model);
    if (ierr ~= 0)
        return;
    end

end