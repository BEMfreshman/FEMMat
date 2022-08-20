function [dstrse,ierr] = elsstrsincr(disp_prev, disp_cur, b, d)
    % b  strain-disp matrix
    % d  material matrix

    ierr = 0;
    disp_inc = disp_cur - disp_prev;
    
    % ddisp to dstrain
    % strain = b * ddisp;
    
    dstrn = b * disp_inc;
    
    dstrse = d * dstrn;

end