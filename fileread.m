function [model,ierr] = fileread(filename,model)

    ierr = 0;

    fid = fopen(filename,'r');
    if (fid < 0)
        ierr = 1;
        return;
    end

    while(~feof(fid))
        line = fgetl(fid);

        if (strncmpi(line,'BEGIN BULK',10))
            [model,ierr] = bulkread(fid,model);
            if (ierr ~= 0)
                return;
            end
        end
    end

    fclose(fid);

end


function [model,ierr] = bulkread(fid,model)

    ierr = 0;
    while(~feof(fid)) 
        line = fgetl(fid);
        wline = strtrim(line);
        if (isempty(wline)) 
            continue;
        elseif (strcmp(wline(1),'$'))
            continue;
        elseif (strncmpi(line,'END',3))
            return;
        elseif (strncmpi(line(1:4),'GRID',4))
            [model,ierr] = gridreader(wline,fid,model);

            % ELEMENT
        elseif (strncmpi(line(1:6),'CQUAD4',6))
            [model,ierr] = cquad4reader(wline,fid,model);
        elseif (strncmpi(line(1:6),'CQPSTN',6))
            [model,ierr] = cqpstnreader(wline,fid,model);
        elseif (strncmpi(line(1:4),'CROD',4))
            [model,ierr] = crodreader(wline,fid,model);
            
            % PROP
        elseif (strncmpi(line(1:6),'PSHELL',6))
            [model,ierr] = pshellreader(wline,fid,model);
        elseif (strncmpi(line(1:6),'PPLANE',6))
            [model,ierr] = pplanereader(wline,fid,model);
        elseif (strncmpi(line(1:4),'PROD',4))
            [model,ierr] = prodreader(wline,fid,model);

            % MAT
        elseif (strncmpi(line(1:4),'MAT1',4))
            [model,ierr] = mat1reader(wline,fid,model);
        
        elseif (strncmpi(line(1:5),'MATS1',5))
            [model,ierr] = mats1reader(wline,fid,model);
            
            % PLOAD
        elseif (strncmpi(line(1:6),'PLOAD4',6))
            [model,ierr] = pload4reader(wline,fid,model);
            
            % FORCE
        elseif (strncmpi(line(1:5),'FORCE',5))
            [model,ierr] = forcereader(wline,fid,model);
            
            % SPC
        elseif (strncmpi(line(1:3),'SPC',3))
            [model,ierr] = spcreader(wline,fid,model);
            
        elseif (strncmpi(line(1:6),'NLPARM',6))
            [model,ierr] = nlparmreader(wline,fid,model);
        else
            ierr = 1;
            return;
        end

        if (ierr == 1)
            return;
        end
    end
end