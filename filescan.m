function [model,ierr] = filescan(filename,model)

    ierr = 0;

    fid = fopen(filename,'r');
    if (fid < 0)
        ierr = 1;
        return;
    end

    while(~feof(fid)) 
        line = fgetl(fid);

        if (strncmpi(line,'BEGIN BULK',10))
            [model,ierr] = bulkscan(fid,model);
            if (ierr ~= 0) 
                return;
            end
        end

    end

    fclose(fid);
end


function [model,ierr] = bulkscan(fid,model)

    ierr = 0;
    while(~feof(fid))
        line = fgetl(fid);
        wline = strtrim(line);
        if (isempty(wline))
            continue;
        elseif (strcmp(wline(1),'$'))
            continue;
        elseif (strncmpi(wline,'END',3)) 
            return;
        elseif (strncmpi(wline(1:4),'GRID',4))
            model.ngrid = model.ngrid+1;
        elseif (strncmpi(wline(1:5),'FORCE',5))
            model.nforce = model.nforce + 1;
        elseif (strncmpi(wline(1:5),'PLOAD1',5) || ...
                strncmpi(wline(1:5),'PLOAD2',5) || ...
                strncmpi(wline(1:5),'PLOAD4',5))
            model.npres = model.npres + 1;
            if (strncmpi(wline(1:5),'PLOAD4',5))
                model.lippres = model.lippres + 4;
                model.lrppres = model.lrppres + 9;
            end
        elseif (strncmpi(wline(1:3),'SPC',3)) 
            model.nspc = model.nspc + 1;
            model.lipspc = model.lipspc + 2;
            model.lrpspc = model.lrpspc + 1;
        elseif (strncmpi(wline(1:4),'MAT1',4))
            model.nmat = model.nmat + 1;
        elseif (strncmpi(line(1:6),'PSHELL',6))
            model.nprop = model.nprop + 1;
        elseif (strncmpi(wline(1:6),'CQUAD4',6))
            model.nelem = model.nelem;

            model.liegrid = model.liegrid + 4;
            model.lipelem = model.lipelem + 4;
            model.lrpelem = model.lrpelem + 6;
        elseif (strncmpi(wline(1:1),'*',1))
            continue;
        else
            ierr = 1;
            return;
        end
    end

    ierr = 1;

end