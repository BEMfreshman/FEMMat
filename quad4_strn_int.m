function [strn,ierr] = quad4_strn_int(strtype,gi,btoltrnsm,...
                            vldocloc,order,disp)

    % calculate strain on gauss int point according to disp
    
    ierr = 0;
    if (order == 0)
        ierr = 1;
        return;
    end

    % build disp (6*4)
    
    % gi = iegrid(ip_iegrid:ip_iegrid+4-1);
    dofloc = gidtodofid(gi);
    
    disp64 = reshape(disp(dofloc),[],4);

    ngint = order * order;
    
    strn = zeros(6,ngint);
    
    [x,~,ierr] = gausint(order);
    if (ierr ~= 0)
        return;
    end

    xc = zeros(2,ngint);
    
    for i = 1:order
        for jac = 1:order
            xc(1,inc) = x(i);
            xc(2,inc) = x(jac);
        end
    end

    [~,dndl,ierr] = quad4nfun(strtype,xc);
    if (ierr ~=0)
        return;
    end
    
    % [~,btoltrnsm] = shellcord(eid,ielem,iegrid,rgrid);
    
    trsmtx = zeros(6,6);
    trsmtx(1:3,1:3) = btoltrnsm(1:3,1:3);
    trsmtx(4:6,4:6) = btoltrnsm(1:3,1:3);
    
    for i = 1:ngint
        
        dndli = dndl(:,2*i-1:2*i)';  % size is (4,1)
        
        % strain-disp matrix b
        if (strcmp(strtype,'PLANESTRESS') || strcmp(strtype,'PLANESTRAIN'))
            b = zeros(3,8);

            for j = 1 : 4
                dndg = invj * dndli(:,j);

                subb = zeros(3,2);
                subb(1,1) = dndg(1,1);
                subb(2,2) = dndg(2,1);
                subb(3,1) = dndg(2,1);
                subb(3,2) = dndg(1,1);

                b(:,2*j-1:2*j) = subb;
            end
            
            dispint = disp64*dndli;
            dispintlcl = trsmtx * dispint;

            ldofloc = [1,2,7,8,13,14,19,20];

            disp01 = reshape(dispintlcl,[],1);

            disp81 = disp01(ldofloc);  % [x1,y1,x1,y2,...,x4,y4]'
            
            strnint = b * disp81;   % [stnX,stnY,stnXY]';    
            
            strn(vldocloc,i) = strnint;
            
        else
            ierr = 1;
            return;
        end
        
        
    end

end