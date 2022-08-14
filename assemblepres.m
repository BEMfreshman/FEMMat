function [spaf,ierr] = assemblepres(loadiid,loaduid,ielem,iegrid,rgrid,ipelem, ...
                                    rpelem,iprop,ipprop,rpprop,ipmat,rpmat,npres,...
                                    ipres,ippres,rppres,spaf)

% assemble pressure to f load
ierr = 0;
if (npres == 0) 
    return; 
end

if (loadiid > npres)
    return;
end

iid       = ipres(1,loadiid);
if (iid ~= loaduid)
    return;
end

iprestype = ipres(2,loadiid);
ip_ippres = ipres(3,loadiid);
ni        = ipres(4,loadiid);

if (iprestype == 3)
    eid    = ippres(ip_ippres);
    ietype = ielem(2,eid);

    if (ietype == 3)
        % CQUAD4
        [fel,dofloc,ierr] = quad4f(eid,ielem,iegrid,rgrid,ipelem,rpelem,...
                                iprop,ipprop,rpprop,ipmat,rpmat,iid,...
                                ipres,ippres,rppres);
    else
        ierr = 1;
        return;
    end

    [ltobtrnsm,~] = shellcord(eid,ielem,iegrid,rgrid);

    ltobtrnmtx = ltobtrnsm(1:3,1:3);

    ltob24 = repmat(ltobtrnmtx,8,8);

    feb = ltob24 * fel;

    spaf(dofloc) = spaf(dofloc) + feb;
else
    ierr = 1;
    return;
end

    


end

