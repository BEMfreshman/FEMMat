function [ke,dofloc,R,ierr] = shellk_plastic(strtype,D,gi,lcoords,tid,mats1type,...
                                            yf,hr,h,lit1,btoltrnsm,u,du)


order = 2;

[x,w,ierr] = gausint(order);
if (ierr ~= 0) 
    return;
end

ngint = order * order;

xc = zeros(2,ngint);
wc = zeros(ngint,1);

inc = 1;
for i = 1:order
    for jac = 1:order
        xc(1,inc) = x(i);
        xc(2,inc) = x(jac);
        wc(inc) = w(i) * w(jac);
        inc = inc + 1;
    end
end


[~,dndl,ierr] = quad4nfun(strtype,xc);
if (ierr ~=0)
    return;
end

vldocloc = [1,2,4]';

[strn,ierr] = quad4_strn_int(strtype,gi,lcoords(1:2,:),btoltrnsm,vldocloc,order,u);
if (ierr ~=0)
    return;
end

[strs,~] = strn2strs(strn,vldocloc,D);

[dstrn,ierr] = quad4_strn_int(strtype,gi,lcoords(1:2,:),btoltrnsm,vldocloc,order,du);
if (ierr ~=0)
    return;
end

[dstrs_trial,~] = strn2strs(dstrn,vldocloc,D);

strs_trial = strs + dstrs_trial; % (6,ngint)

ks  = zeros(8,8);
dRs = zeros(8,1);

for i = 1:ngint
    [i1,i2,i3,j1,j2,j3,ierr] = strsIJ(strs_trial(:,i));
    if (ierr ~=0)
        return;
    end

    if (yf == 1)
        % vos Mises Yield function criterion
        F1 = j2 - lit1 ^ 2;
    else
        ierr = 1;
        return;
    end

    if (F1 > 0)
        error('plastic mode, has not been completed');
    end

    strs_real_int = strs_trial(:,i);
    dstrs = strs_trial(:,i) - strs_real_int;

    [depm,ierr] = dep(yf,D,vldocloc,strs_real_int);

    % jacobian matrix and its invert
    dndli = dndl(:,2*i-1:2*i)';
    %    xct   = xc';

    jac = dndli * lcoords(1:2,:)'; % [2 * 4] * [4 * 2]

    detj = det(jac);

    invj = zeros(2);
    invj(1,1) =  jac(2,2);
    invj(1,2) = -jac(1,2);
    invj(2,1) = -jac(2,1);
    invj(2,2) =  jac(1,1);

    invj = invj / detj;

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

        ks  = ks + b' * depm * b * wc(i) * detj;

        dRs = dRs + b' * dstrs(vldocloc) * wc(i) * detj;
    elseif (strcmp(strtype,'THINPLATE'))
        ierr = 1;
        return;
    else
        ierr = 1;
        return;
    end
end

[dofloc] = gidtodofid(gi);

ke = zeros(24,24);
R = zeros(24,1);

ldofloc = [1,2,7,8,13,14,19,20];

ke(ldofloc,ldofloc) = ks;
R(ldofloc) = dRs;

end