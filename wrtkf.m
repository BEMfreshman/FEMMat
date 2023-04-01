function [ierr] = wrtkf(spak,spaf,ndof)

    ierr = 0;
    
    fid = fopen('./wslsolver/mat.txt','w');
    if (fid < 0)
        ierr = 1;
    end
    
    fprintf(fid,"%d\n",ndof);
    
    nonz = nnz(spak);
    fprintf(fid,"%d\n",nonz);
    
    [ir,ic,val] = find(spak);
    
    for i = 1: length(ir)
        fprintf(fid,"%d %d %f\n",ir(i),ic(i),val(i));
    end
    
    nonz = nnz(spaf);
    fprintf(fid,"%d\n",nonz);
    
    [ir,~,val] = find(spaf);
    
    for i = 1: length(ir)
        fprintf(fid,"%d %f\n",ir(i),val(i));
    end
    
    fclose(fid);

end