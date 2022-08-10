function [model,ierr] = fileread(filename)

    ierr = 0;

    fid = fopen(filename,'r');
    if (fid < 0)
        ierr = 1;
        return;
    end

    while(~feof(fid))
        line = getline(fid);

        if (strncmpi(line,'BEGIN BULK',10))
            [model,ierr] = bulkread(fid);
            if (ierr ~= 0)
                return;
            end
        end
    end

    fclose(fid);

end


function [model,ierr] = bulkread(fid)

    ierr = 0;

    line = getline(fid);

    while(~feof(fid)) 
        if (strncmpi(line,'END',3))
            return;
        elseif (strncmpi(line(1:4),'GRID',4))

        else
            ierr = 1;
            return;
        end


    end
end