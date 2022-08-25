function [rsd_rhs_cur] = calresidual(u,spak,spaf)
    
    rsd_rhs_cur = spak*u - spaf;

end