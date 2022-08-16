function [spak,ierr] = assemblek(kel,dofloc,ltobtrnsm,spak)

    % ke (24,24)
    % ltobtrnsm(3,4);

    ierr = 0;
    
    ltobtrnmtx = ltobtrnsm(1:3,1:3);
    ltob6 = zeros(6,6);
    ltob6(1:3,1:3) = ltobtrnmtx;
    ltob6(4:6,4:6) = ltobtrnmtx;
    
    % ltob24 = repmat(ltobtrnmtx,8,8);

    % keb = ltob24 * kel;
    
    [nrow,~] = size(kel);
    ngrid = nrow / 6;
    
    staidx = linspace(1,nrow+1,ngrid+1)';
    staidx = staidx(1:ngrid);    
    for i = 1:ngrid
        for j = 1:ngrid
            keb(staidx(i):staidx(i)+5,staidx(j):staidx(j)+5) =...
                ltob6 * kel(staidx(i):staidx(i)+5,staidx(j):staidx(j)+5) * ltob6'; 
        end
    end

%     tempx = reshape([1:ngrid*6]',6,[]);
%     tempx4 = repmat(tempx,ngrid,1);
%     xreal = reshape(tempx4,[],1);
%     yreal = repmat([1:ngrid*6]',ngrid,1);
%     
%     dofspan = [xreal,yreal];
    
    

    % x1 = reshape(repmat(dofloc,1,ngrid*6),[],1);
    % x2 = reshape(repmat(dofloc',ngrid*6,1),[],1);
    
    % x = [x1,x2];
    
    % data = reshape(keb,[],1);
    
    spak(dofloc,dofloc) = spak(dofloc,dofloc) + keb;

end

