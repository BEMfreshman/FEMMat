function [disp,ierr] = lstat_main(model)
%
% linear static analysis function
%

nstsub = model.nstsub;
istsub = model.istsub;

nelem = model.nelem;
ielem = model.ielem;

ngrid  = model.ngrid;
nforce = model.nforce;
npres  = model.npres;
nspc   = model.nspc;

spak = sparse(ngrid*6,ngrid*6);
spaf = sparse(ngrid*6,1);

for iload = 1:nstsub
    if (istsub(2,iload) ~= 1) 
        % skip nonlinear
        continue
    end
    
    % build stiffness matrix
    for ie = 1: nelem
        eiid   = ielem(1,ie);
        ietype = ielem(3,ie);
        if (ietype == 3)
            % quad4
            % kel (24,24)
            [kel,dofloc,ierr] = quad4k(eiid,model.ielem,model.iegrid,model.rpgrid,...
                                    model.ipelem,model.rpelem,model.ipprop,...
                                    model.rpprop,model.ipmat,model.rpmat);
            if (ierr ~=0) 
                return; 
            end
               
            [ltobtrnsm,~] = shellcord(eiid,model.ielem,model.iegrid,...
                                      model.rpgrid);
            
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
    if (nforce ~= 0)
        
        
    end
    
    % 2. deal with press cards
    if (npres ~= 0)

        [spaf,ierr] = assemblepres(model.ielem,model.iegrid,model.rpgrid,...
                            model.ipelem, model.rpelem,model.ipprop,model.rpprop,...
                            model.ipmat,model.rpmat,model.npres,model.ipres,...
                            model.ippres,model.rppres, spaf);
        if (ierr ~= 0)
            return;
        end
    end


    % spc
    
    % solve
    
end

ierr = 0;
end

