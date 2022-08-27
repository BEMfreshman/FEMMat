function [uer,q,ierr] = nldispconv(disptype,u,du_last,du_cur,q_last,spak)
    
    ierr = 0;
    du_last_norm = norm(du_last);
    du_cur_norm  = norm(du_cur);
    
    if (du_last_norm ~= 0)
        q = (du_cur_norm/du_last_norm) * 2/3 + q_last/3;
    else
        q = q_last;
    end
    
    if (strncmpi(disptype,'smalldisp',9))
        k = q / (1-q);
    else
        k = 1;
    end
    
    uer = norm(du_cur.*spdiags(spak,1))/norm(u.*spdiags(spak,1)) * k;

end