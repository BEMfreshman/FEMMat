function [model,ierr] = filescan(filename)

    ierr = 0;

    fid = fopen(filename,'r');
    if (fid < 0)
        ierr = 1;
        return;
    end

    while(~feof(fid)) 
        line = getline(fid);

        if (strncmpi(line,'BEGIN BULK',10))
            [model,ierr] = bulkscan(fid);
            if (ierr ~= 0) 
                return;
            end
        end

    end

    fclose(fid);
end


function [model,ierr] = bulkscan(fid)

    line = getline(fid);
    ierr = 0;
    while(~feof(fid))
        if (strncmpi(line,'END',3)) 
            return;
        elseif (strncmpi(line(1:4),'GRID',4))
            model.ngrid = model.ngrid+1;
        elseif (strncmpi(line(1:5),'FORCE',5))
            model.nforce = model.nforce + 1;
        elseif (strncmpi(line(1:5),'PLOAD1',5) || ...
                strncmpi(line(1:5),'PLOAD2',5) || ...
                strncmpi(line(1:5),'PLOAD4',5))
            model.npres = model.npres + 1;
            if (strncmpi(line(1:5),'PLOAD4',5))
                model.lippres = model.lippres + 4;
                model.lrppres = model.lrppres + 9;
            end
        elseif (strnmcpi(line(1:3),'SPC',3)) 
            model.nspc = model.nspc + 1;
        elseif (strnmcpi(line(1:4),'MAT1',4))
            model.nmat = model.nmat + 1;
        elseif (strncmpi(line(1:6),'PSHELL',6))
            model.nprop = model.nprop + 1;
        elseif (strncmpi(line(1:6),'CQUAD4',6))
            model.nelem = model.nelem;

            model.liegrid = model.liegrid + 4;
            model.lipelem = model.lipelem + 4;
            model.lrpelem = model.lrpelem + 6;
        else
            ierr = 1;
            return;
        end
    end

    ierr = 1;

end