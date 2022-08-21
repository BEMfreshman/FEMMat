function [strs,ierr] = strn2strs(strn,ldofloc,D)
    
    ierr = 0;
    
    % nr - 6
    % nc - number of point (it could be node point or gauss point)
    [~,nc] = size(strn);
    
    strs = zeros(6,nc);
    
    strs(ldocloc,:) = D * strn(ldofloc,:);
    

end