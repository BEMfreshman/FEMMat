
function [uer,ler,ierr] = nlconvergence(disptype,u_cur,du_last,du_cur,spak,spaf,...
                            spar)
    ierr = 0;
    [uer,~] = nldispconv(disptype,u_cur,du_last,du_cur,spak);
    [ler,~] = nlloadconv(spar,spaf,u_cur);        
    
    
end