function [spak] = assmblek(kel,dofloc,ltobtrnsm)

    % ke (24,24)
    % ltobtrnsm(3,4);
    
    ltobtrnmtx = ltobtrnsm(1:3,1:3);
    
    ltob24 = repmat(ltobtrnmtx,8,8);

    keb = ltob24 * kel;
    
    

end

