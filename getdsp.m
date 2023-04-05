function [disp] = getdsp(u,gi)

    dofloc = gidtodofid(gi);
    
    disp64 = reshape(u(dofloc),[],4);
    
    disp = reshape(disp64,[],1);
    

end