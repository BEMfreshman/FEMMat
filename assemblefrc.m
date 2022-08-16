function [spaf,ierr] = assemblefrc(loadid,loaduid,ifrc,ipfrc,rpfrc,...
                                jfrc,nfrc,nfrc0,spaf)

ierr = 0;
if (nfrc0 == 0)
    return;
end

if (loadid > nfrc0)
    ierr = 1;
    disp('loadid is bigger than nfrc0');
    return;
end

iid = jfrc(loadid,1);
if (iid ~= loaduid)
    return;
end

pos = jfrc(2,iid);
n   = jfrc(3,iid);

for i = 1:n

    ptifrc   = pos + i - 1;
    ifrctype = ifrc(2,ptifrc);
    ip_ifrc  = ifrc(3,ptifrc);
    ip_rfrc  = ifrc(5,ptifrc);

    if (ifrctype == 1)
        % FORCE
        g   = ipfrc(ip_ifrc);
        cid = ipfrc(ip_ifrc + 1);

        f   = rpfrc(ip_rfrc);
        n   = rpfrc(ip_rfrc+1:ip_rfrc+3);

        [spaf,ierr] = frcongrid(g,cid,f,n,spaf);
    else
        ierr = 1;
        return;
    end

end

end
