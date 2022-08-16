function [disp,ierr] = lstat_main(model)
%
% linear static analysis function
%

nstsub = model.nstsub;
istsub = model.istsub;

nelem = model.nelem;
ielem = model.ielem;

ngrid   = model.ngrid;
nfrc = model.nfrc;
npres  = model.npres;
nspc    = model.nspc;

spak = sparse(ngrid*6,ngrid*6);
spaf = sparse(ngrid*6,1);
gdofloc = [1:ngrid*6]';

disp = 0;

for iload = 1:nstsub
    if (istsub(2,iload) ~= 1) 
        % skip nonlinear
        continue
    end

    loadiid = istsub(3,iload);
    loaduid = istsub(4,iload);
    spciid  = istsub(5,iload);
    
    % build stiffness matrix
    for ie = 1: nelem
        eiid   = ielem(1,ie);
        ietype = ielem(2,ie);
        if (ietype == 3)
            % quad4
            % kel (24,24)
            [kel,dofloc,ierr] = quad4k(eiid,ietype,model.ielem,model.iegrid,model.rgrid,...
                                    model.ipelem,model.rpelem,model.iprop,model.ipprop,...
                                    model.rpprop,model.imat,model.ipmat,model.rpmat);
            if (ierr ~=0) 
                return; 
            end
               
            [ltobtrnsm,~] = shellcord(eiid,model.ielem,model.iegrid,...
                                      model.rgrid);
            
            [spak,ierr] = assemblek(kel,dofloc,ltobtrnsm,spak);
            
            if (ierr ~=0)
                return;
            end
        else
            ierr = 1;
            return;
        end
    end
    
    
    % build f vector
    
    % 1. deal with force cards
    if (nfrc ~= 0)
        [spaf,ierr] = assemblefrc(loadiid,loaduid,model.ifrc,model.ipfrc,model.rpfrc,...
                            model.jfrc,model.nfrc,model.nfrc0,spaf);
        
    end
    
    % 2. deal with press cards
    if (npres ~= 0)

        [spaf,ierr] = assemblepres(loadiid,loaduid,model.ielem,model.iegrid,model.rgrid,...
                            model.ipelem, model.rpelem,model.iprop,model.ipprop,model.rpprop,...
                            model.ipmat,model.rpmat,model.npres,model.ipres,...
                            model.ippres,model.rppres, spaf);
        if (ierr ~= 0)
            return;
        end
    end


    % spc
    [spak,spaf,gdofloc,ierr] = applyspc(spciid,model.ispc,model.ipspc,...
                                model.rpspc,model.nspc,model.jspc,...
                                model.nspc0,spak,spaf,gdofloc);
    if (ierr ~= 0) 
        return;
    end
    % solve
    
    [disp0] = lsqr(spak,spaf,1e-6,500);
    
    
    disp = zeros(ngrid*6,1);
    disp(gdofloc) = disp0;
    
    disp = reshape(disp,6,[])';
    
end

ierr = 0;
end

