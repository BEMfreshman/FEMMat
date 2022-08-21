function [strs,ierr] = quad4_strs_int(strtype,eiid,ielem,iegrid,rgrid,...
                                    vldocloc,D,disp)

    ierr = 0;
    
    [strn,ierr] = quad4_strn_int(strtype,eiid,ielem,iegrid,rgrid,vldocloc,disp);
    if (ierr ~=0)
        return;
    end
    
    [strs,ierr] = strn2strs(strn,vldocloc,D);

end