function [depm,ierr] = dep(yf,D,vldocloc,strs)
    
    % associated flow-rule would be considered here

    ierr = 0;

    if (yf ~=1)   % not mise
        ierr = 1;
        return;
    end

    [dfds,ierr] = dfdsigma(yf,strs);
    if (ierr ~= 0)
        return;
    end

    depm = D * dfds(vldocloc) * dfds(vldocloc)' * D / ...
        (dfds(vldocloc)' * D * dfds(vldocloc));

end