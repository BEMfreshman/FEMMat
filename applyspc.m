function [spak,spaf,gdofloc,ierr] = applyspc(spcid,wispc,wipspc,wrpspc,...
                                    spak,spaf,gdofloc)

    ierr = 0;
    ngrid = wispc(4,spcid);

    iti = wipspc(2,spcid);
    itr = wipspc(3,spcid);
    for i = 1:ngrid
        gi = wipspc(iti);
        iti = iti + 1;
        ci = wipspc(iti);
        iti = iti + 1;

        disp = wrpspc(itr);
        itr = itr + 1;

        sta_dof = 6 * (gi - 1);

        di = repmat(ci,6,1);
        dofs = floor(mod(di,10.^[6:-1:1]'./10.^[5:-1:0]'));
        dofs(dofs == 0) = [];

        dofs  = dofs + sta_dof;

        ndof = length(dofs);

        gdofloc (gdofoc == dofs) = [];
        for j = 1: ndof
            dof = dofs(j);

            spaf = spaf - disp * spak(:,dof);
            spaf(dof) = 0;
            spak(:,dof) = 0;
            spak(dof,:) = 0;
        end
    end

    % delete all zero row and col in spak
    gdofloc(~any(spak,2)) = [];
    spaf(~any(spak,2))    = [];
    spak(~any(spak,2),:)  = [];
    spak(:,~any(spak,1))  = [];

end