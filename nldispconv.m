function [uer,ierr] = nldispconv(disptype,u,du_last,du_cur,spak)
    
    ierr = 0;
    du_last_norm = norm(du_last);
    du_cur_norm  = norm(du_cur);
    
    if (du_last_norm == 0)
        q = 1;
    else 
        q = du_cur_norm/du_last_norm;
    end
    
    if (strncmpi(disptype,'smalldisp',9))
        if (q==1)
            k = 1;
        else
            k = q / (1-q);
        end
    else
        k = 1;
    end
    
    uer = norm(du_cur.*spdiags(spak,1))/norm(u.*spdiags(spak,1)) * k;

end