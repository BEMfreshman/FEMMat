function [i1,i2,i3,j1,j2,j3,ierr] = strsIJ(strs)
    
    ierr = 0;
    if (length(strs) ~= 6)
        ierr = 1;
        return;
    end
    
    i1 = sum(strs(1:3));
    i2 = -(strs(1)*strs(2)+strs(2)*strs(3)+strs(1)*strs(3))+strs(4)*strs(4)+...
        strs(5)*strs(5)+strs(6)*strs(6);
    i3 = strs(1)*strs(2)*strs(3)+2*strs(4)*strs(5)*strs(6)-strs(1)*strs(5)*strs(5)-...
        strs(2)*strs(6)*strs(6)-strs(3)*strs(4)*strs(4);
    
    j1 = 0;
    j2 = 1/6*((strs(1)-strs(2))^2+(strs(2)-strs(3))^2+(strs(1)-strs(3))^2+...
        6*(strs(4)*strs(4)+strs(5)*strs(5)+strs(6)*strs(6)));
   
    simgam = i1/3;
    
    sx = strs(1) - simgam;
    sy = strs(2) - simgam;
    sz = strs(3) - simgam;
    sxy = strs(4);
    syz = strs(5);
    sxz = strs(6);
    
    j3 = sx*sy*sz+2*sxy*syz*sxz - sx*syz^2-sy*sxz^2-sz*sxy^2;


end