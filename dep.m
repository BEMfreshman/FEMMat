function [depm,ierr] = dep(yf,D,vldocloc,strs,elaflg)
    
    % associated flow-rule would be considered here

    ierr = 0;

    if (yf ~=1)   % not mise
        ierr = 1;
        return;
    end
    
    if (elaflg == 1)
        depm = D;
        return;
    end

    [dfds,ierr] = dfdsigma(yf,strs);
    if (ierr ~= 0)
        return;
    end

    divd = dfds(vldocloc)' * D * dfds(vldocloc);
    if (divd == 0)
        depm = D;
    else
        depm = D * dfds(vldocloc) * dfds(vldocloc)' * D / ...
            (dfds(vldocloc)' * D * dfds(vldocloc));
    end

end