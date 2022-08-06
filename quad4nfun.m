function [nfun,dndl,ierr] = quad4nfun(strtype,x)

% x    -- gauint coords (2,n)

% nfun -- shape function (4,n)
% dndl -- derivative of n to xi and yi (4,n*2)
%                         (.,2*i-1) - dndxi(1)
%                         (.,2*i  ) - dndxi(2)

%   4    3
%   1    2


ierr = 0;

[~,n] = size(x);

if (strcmp(strtype,'PLANESTRESS') || strcmp(strtype,'PLANESTRAIN'))

    nfun = zeros(4,n);
    dndl = zeros(4,n * 2);

    for i = 1:n
        xi = x(:,i);
        nfun(1,i) = 0.25 * (1 - xi(1)) * (1 - xi(2));
        nfun(2,i) = 0.25 * (1 + xi(i)) * (1 - xi(2));
        nfun(3,i) = 0.25 * (1 + xi(i)) * (1 + xi(2));
        nfun(4,i) = 0.25 * (1 - xi(i)) * (1 + xi(2));

        dndl(1,2*i-1) = -0.25 * (1-xi(2));
        dndl(2,2*i-1) =  0.25 * (1-xi(2));
        dndl(3,2*i-1) =  0.25 * (1+xi(2));
        dndl(4,2*i-1) = -0.25 * (1+xi(2));

        dndl(1,2*i) = -0.25*(1-xi(1));
        dndl(2,2*i) = -0.25*(1+xi(1));
        dndl(3,2*i) =  0.25*(1+xi(1));
        dndl(4,2*i) =  0.25*(1-xi(1));
    end
else
    ierr = 1;
    return ;
end


end

