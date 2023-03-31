function [spak,spaf,gdofloc,ierr] = applyspc(spcid,ispc,ipspc,rpspc,nspc,jspc,...
                                    nspc0,spak,spaf,gdofloc)

    ierr = 0;
    
    pos = jspc(2,spcid);
    n   = jspc(3,spcid);
    
    for i = 1:n
        ptispc  = pos + i - 1;
        ptipspc = ispc(3,ptispc);
        ptrpspc = ispc(5,ptispc);
        
        g1 = ipspc(ptipspc);
        c1 = ipspc(ptipspc + 1);
        
        g2 = ipspc(ptipspc + 2);
        c2 = ipspc(ptipspc + 3);
        
        d1 = rpspc(ptrpspc);
        d2 = rpspc(ptrpspc + 1);
        
        for j = 1:2
            if (j == 1)
                g = g1;
                c = c1;
                disp = d1;
            else
                g = g2;
                c = c2;
                disp = d2;
            end
            
            if (g == 0) 
                continue;
            end
            
            sta_dof = 6 * (g - 1);
            di = repmat(c,6,1);
            dofs = floor(mod(di,10.^[6:-1:1]')./10.^[5:-1:0]');
            dofs(dofs == 0) = [];
            
            dofs  = dofs + sta_dof;

            ndof = length(dofs);

            for k = 1: ndof
                dof = dofs(k);

                spaf = spaf - disp * spak(:,dof);
                spaf(dof) = 0;
                spak(:,dof) = 0;
                spak(dof,:) = 0;
            end
            
            % more codes are needed here to delete rows/cols when
            % its dof has been fixed
        end
    end

    % delete all zero row and col in spak
    % delete on 2023-3-30
%     gdofloc(~any(spak,2)) = [];
%     spaf(~any(spak,2))    = [];
%     spak(~any(spak,2),:)  = [];
%     spak(:,~any(spak,1))  = [];

end