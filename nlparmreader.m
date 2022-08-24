function [model,ierr] = nlparmreader(line,fid,model)
    
    [wline,hasstr] = preprocesstext(line,72);
    
    ierr = 0;
    
    if (hasstr(2) == 0)
        ierr = 1;
        disp('Failed in parsing nlparm, id is empty');
        return;
    end
    
    id = 0;
    id = f2d(wline,hasstr,2,id);
    msg = sprintf('Failed in parsing nlparm %d ',id);
    
    if (hasstr(3) == 0)
        ierr = 1;
        disp([msg,', ninc is empty']);
        return;
    end
    
    ninc = 0;
    ninc = f2d(wline,hasstr,3,ninc);
    
    dt = 0.0;
    dt = f2d(wline,hasstr,4,dt);
    
    if (hasstr(7) == 0)
        ierr = 1;
        disp([msg,', maxiter is empty']);
        return;
    end
    
    maxiter = 25;
    maxiter = f2d(wline,hasstr,7,maxiter);
    
    %  1  1  1  1  1  1 
    %  u  p  w  v  n  a
    
    conv = strtrim(wline(56+1:56+8));
    iconv = 0;
    
    for i = 1:length(conv)
        if (strncmpi(conv(i),'u',1))
            iconv = iconv + 100000;
        elseif(strncmpi(conv(i),'p',1))
            iconv = iconv + 10000;
        elseif(strncmpi(conv(i),'w',1))
            iconv = iconv + 1000;
        elseif(strncmpi(conv(i),'v',1))
            iconv = iconv +100;
        elseif(strncmpi(conv(i),'n',1))
            iconv = iconv + 10;
        elseif(strncmpi(conv(i),'a',1))
            iconv = iconv + 1;
        else
            ierr = 1;
            return;
        end
    end

    inlparm = [id,ninc,maxiter,iconv]';
    
    model.inlparm(:,model.ncnlparm) = inlparm;
    model.ncnlparm = model.ncnlparm + 1;

end