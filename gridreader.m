function [model,ierr] = gridreader(line,fid,model)

    model.ptgrid = model.ptgrid + 1;

    len = length(line);

    if (len ~= 72)
        wline = [line,repmat(' ',1,72-len)];
    else
        wline = line;
    end

    id = str2double(wline(9:16));
    
    cp = str2double(wline(17:24));

    x = str2double(wline(25:32));
    y = str2double(wline(33:40));
    z = str2double(wline(41:48));




end