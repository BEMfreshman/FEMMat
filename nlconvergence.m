
function [uer,ler,q_cur,ierr] = nlconvergence(disptype,u_cur,du_last,du_cur,...
                            q_last,spak,spaf,spar)
    ierr = 0;
    [uer,q_cur,~] = nldispconv(disptype,u_cur,du_last,du_cur,q_last,spak);
    [ler,~] = nlloadconv(spar,spaf,u_cur);        
    
    
end