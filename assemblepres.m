function [spaf,ierr] = assemblepres(ielem,iegrid,rpgrid,ipelem, rpelem,...
                                    ipprop,rpprop,ipmat,rpmat,npres,...
                                    ipres,ippres,rppres,spaf)

% assemble pressure to f load
ierr = 0;
if (npres == 0) 
    return; 
end

for i = 1:npres
    ip_ippres = ipres(3,i);
    ni        = ipres(4,i);

    for j = 1:ni
        eid = ippres(ip_ippres+j-1);
        ietype = ielem(3,eid);

        if (ietype == 3)
            % CQUAD4
            [fel,dofloc,ierr] = quad4f(eid,ielem,iegrid,rpgrid,ipelem,rpelem,...
                                    ipprop,rpprop,ipmat,rpmat,presid,...
                                    ipres,ippres,rppres);
        else
            ierr = 1;
            return;
        end

        [ltobtrnsm,~] = shellcord(eid,ielem,iegrid,rpgrid);

        ltobtrnmtx = ltobtrnsm(1:3,1:3);

        ltob24 = repmat(ltobtrnmtx,8,8);

        feb = ltob24 * fel;

        spaf(dofloc) = spaf(dofloc) + feb;

    end

    
end

end

