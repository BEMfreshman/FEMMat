function [spaf,ierr] = frcongrid(g,cid,f,ni,spaf)

ierr = 0;

if (cid == 0)

    fe = zeros(6,1);
    dofloc = gidtodofid(g);

    ftemp = f * ni;

    fe(1:3) = ftemp;

    spaf(dofloc) = fe;

else
    ierr = 1;
    return;
end
end