function [dfdi1,dfdj2,dfdj3,ierr] = dfdij(yf,i1,j2,j3,theta,fi)
    
    % yf - 1 :  Mises
    
    ierr = 0;
    if (yf ~= 1)
        ierr = 1;
        return;
    end
    
    if (yf == 1)
        dfdi1 = 0;
        if (j2 ~= 0)
            dfdj2 = 1 / (2*sqrt(j2));
        else
            dfdj2 = 0;
        end
        dfdj3 = 0;
    end

end