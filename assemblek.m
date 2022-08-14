function [spak,ierr] = assemblek(kel,dofloc,ltobtrnsm,spak)

    % ke (24,24)
    % ltobtrnsm(3,4);

    ierr = 0;
    
    ltobtrnmtx = ltobtrnsm(1:3,1:3);
    
    ltob24 = repmat(ltobtrnmtx,8,8);

    keb = ltob24 * kel;
    
    x1 = reshape(repmat(dofloc,1,24),[],1);
    x2 = repmat(dofloc,24,1);
    
    % x = [x1,x2];
    
    data = reshape(keb,[],1);
    
    spak(x1,x2) = spak(x1,x2) + data;

end

