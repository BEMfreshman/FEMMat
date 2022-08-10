function [spaf,ierr] = assemblepres(loadiid,loaduid,ielem,iegrid,rgrid,ipelem, ...
                                    rpelem,ipprop,rpprop,ipmat,rpmat,npres0,...
                                    wipres,wippres,wrppres,spaf)

% assemble pressure to f load
ierr = 0;
if (npres0 == 0) 
    return; 
end

if (loadiid > npres0)
    return;
end

uid       = ipres(1,loadiid);
if (uid ~= loaduid)
    return;
end
ip_ippres = wipres(3,loadiid);
ni        = wipres(4,loadiid);

for j = 1:ni
    eid    = wippres(ip_ippres+j-1);
    ietype = ielem(3,eid);

    if (ietype == 3)
        % CQUAD4
        [fel,dofloc,ierr] = quad4f(eid,ielem,iegrid,rgrid,ipelem,rpelem,...
                                ipprop,rpprop,ipmat,rpmat,presid,...
                                wipres,wippres,wrppres);
    else
        ierr = 1;
        return;
    end

    [ltobtrnsm,~] = shellcord(eid,ielem,iegrid,rgrid);

    ltobtrnmtx = ltobtrnsm(1:3,1:3);

    ltob24 = repmat(ltobtrnmtx,8,8);

    feb = ltob24 * fel;

    spaf(dofloc) = spaf(dofloc) + feb;

end

    


end

