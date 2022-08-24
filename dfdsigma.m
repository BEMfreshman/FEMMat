function [dfds,ierr] = dfdsigma(yf,strs)
    % dfds  (6 * 1)

    ierr = 0;
    if (yf ~= 1)
        ierr = 1;
        return;
    end
    
    [i1,i2,i3,j1,j2,j3,ierr] = strsIJ(strs);
        
    simgam = i1/3;

    sx = strs(1) - simgam;
    sy = strs(2) - simgam;
    sz = strs(3) - simgam;
    sxy = strs(4);
    syz = strs(5);
    sxz = strs(6);
    
    di1dsigma = [1 1 1 0 0 0]';
        
    dj2dsigma = [sx sy sz 2*sxy 2*syz 2*sxz]';
    
    dj3dsigma = [j2/3+sy*sz - syz^2, j2/3+sx*sz-sxz^2, j2/3+sx*sy-sxy^2,...
            2*(syz*sxz - sz*sxy),2*(sxy*syz - sx*syz),2*(sxy*syz-sy*sxz)]';

    if (yf == 1) 
        theta = 0;
        fi = 0;
        [dfdi1,dfdj2,dfdj3,ierr] = dfdij(yf,i1,j2,j3,theta,fi);
        if (ierr ~= 0)
            return;
        end
        
        dfds = dfdi1*di1dsigma + dfdj2*dj2dsigma + dfdj3*dj3dsigma;
    end

end