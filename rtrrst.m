function [rst,ierr] = rtrrst(ngdofloc)
    
    ierr = 0;
    rst = zeros(ngdofloc,1);
    
    path = './wslsolver/rst.txt';
    
    fid = fopen(path,'r');
    if (fid < 0)
        ierr = 1;
        return;
    end
    
    rst = fscanf(fid,'%f');
    
    fclose(fid);

end