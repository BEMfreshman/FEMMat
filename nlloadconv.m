function [ler,ierr] = nlloadconv(spar,spaf,u)

    ierr = 0;
    ler = u'*spar / (u'*spaf);
    
end