function [ler,ierr] = nlloadconv(spar,spaf,u_prev,uinc)

    ierr = 0;
    u = u_prev + uinc;
    ler = u'*spar / (u'*spaf);
    
end