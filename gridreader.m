function [model,ierr] = gridreader(line,fid,model)

    [wline,hasstr] = preprocesstext(line,72);

    id = str2double(wline(9:16));
    
    cp = 0;
    if (hasstr(3) == 1)
        cp = str2double(wline(17:24));
    end

    x = zeros(3,1);

    for i = 4:6
        if(hasstr(i) == 1) 
            x(i-3) = str2double(wline((i-1)*8+1:i*8));
        end
    end

    cd = 0;
    if (hasstr(7) == 1)
        cd = str2double(wline(49:56));
    end

    ps = 0;
    seid = 0;

    pt = model.ptgrid;

    model.igrid(:,pt) = [id, cp, cd, ps, seid]';
    model.rgrid(:,pt) = x';

    model.ptgrid = model.ptgrid + 1;

end