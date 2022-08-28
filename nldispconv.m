function [uer,q,ierr] = nldispconv(disptype,n_subiter,u_prev,u_inc,...
                                    u_cor,q_last,spak)
    
    ierr = 0;
    u_inc_norm = norm(u_inc);
    u_cor_norm  = norm(u_cor);
    
    u = u_prev + u_inc;
    
    if (n_subiter ~= 1)
        q = (u_cor_norm/u_inc_norm) * 2/3 + q_last/3;
    else
        q = q_last;
    end
    
    if (strncmpi(disptype,'smalldisp',9))
        k = q / (1-q);
    else
        k = 1;
    end
    
    uer = norm(u_cor.*spdiags(spak,1))/...
        norm(u.*spdiags(spak,1)) * k;

end