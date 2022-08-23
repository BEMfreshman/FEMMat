function [disp,ierr] = nlstat_main(model)
%
% nonlinear static analysis function
%

%  reference book: Chinese nonlinear FEM basis  Peking Unverisity Press.
%  Yin YouQuan 
%  Chapter 1   and   Chapter 3-6

nstsub = model.nstsub;
istsub = model.istsub;

nelem = model.nelem;
ielem = model.ielem;

ngrid = model.ngrid;
nspc  = model.nspc;

spakt = sparse(ngrid*6,ngrid*6);    % tangent sparse stiffness matrix
spaf = sparse(ngrid*6,1);

spadf = sparse(ngrid*6,1);
spadr = sparse(ngrid*6,1);

% nonlinear state
nlstat.itime = 0;

nlstat.rtime_last = 0.0;
nlstat.rtime_cur  = 0.0;

nlstat.n_iter = 0;
nlstat.n_subiter = 0;

% disp 
nlstat.disp_cur = zeros(ngrid*6,1);
nlstat.disp_last_iter = zeros(ngrid*6,1);
nlstat.disp_last_subiter = zeros(ngrid*6,1);


% residual rhs
nlstat.rsd_rhs_cur = zeros(ngrid*6,1);
nlstat.rsd_rhs_cur_last_subiter = zeros(ngrid*6,1);

% local var
max_sub_niter = 50;
coeffload = 1.0;

disp = 0;

for iload = 1:nstsub
    if(istsub(2,iload) ~= 2)
        continue;
    end
    
    loadiid = istsub(3,iload);
    loaduid = istsub(4,iload);
    spciid  = istsub(5,iload);
    
    nlparmid = istsub(6,iload);
    
%    maxiter = model.inlparm(3,nlparmid);
    
    maxiter = 2;
    facloads = linspace(0,1,maxiter+1);

    while(nlstat.n_iter <= maxiter)
    
        % incr start
        nlstat.n_iter = nlstat.n_iter + 1;
        
        cofload_prev = facloads(nlstat.n_iter);
        cofload_cur  = facloads(nlstat.n_iter + 1); % skip first element, it is 0
        
        if (nfrc ~=0)
            [spadf,ierr] = assemblefrc_inc(loadiid,loaduid,model.ifrc,...
                            model.ipfrc,model.rpfrc,model.jfrcmodel.nfrc,...
                            model.nfrc0,cofload_prev,cofload_cur,spadf);
        end
        
        if (npres ~= 0)
            
            
        end

        u_prev = nlstat.disp_last_iter;
        u_now  = nlstat.disp_iter;

        nlstat.n_subiter = 1;
        while(nlstat.n_subiter <= max_sub_niter)
            
            gdofloc = [1:6*ngrid]';
            
            % build k and f
%             for ie = 1:nelem
%                 eiid   = ielem(1,ie);
%                 ietype = ielem(2,ie);
%                 if (ietype == 3)
%                     % cquad4
%                     
%                 elseif (ietype == 4)
%                     % cqpstn
%                     
%                     % todo
%                     [ket,dofloc,ierr] = quad4k_tangent(eiid,ietype,model.ielem,model.iegrid,model.rgrid,...
%                                     model.ipelem,model.rpelem,model.iprop,model.ipprop,...
%                                     model.rpprop,model.imat,model.ipmat,model.rpmat);
%                 else
%                     ierr  = 1;
%                     return;
%                 end
%                 
%                 [ltobtrnsm,~] = shellcord(eiid,model.ielem,model.iegrid,...
%                                       model.rgrid);
%             
%                 [spakt,ierr] = assemblek(ket,dofloc,ltobtrnsm,spakt);
%             end

            u = nlstat.disp_iter;
            if (nlstat.n_subiter == 1)
                du = nlstat.disp_cur - nlstat.disp_last_iter;
            else
                du = nlstat.disp_cur - nlstat.disp_last_subiter;
            end

            nlstat.disp_iter = nlstat.disp_cur;

            for ie = 1:nelem
                % calculate dstrain on gauss int point of each element
                eid   = ielem(1,ie);
                ietype = ielem(2,ie);
                
                if (ietype == 3)
                    % cquad4
                    
                elseif (ietype == 4)
                    % cqpstn
                    
                    [ket,dofloc,dR,ierr] = quad4k_plastic(eid,ietype,...
                                model.ielem,model.iegrid,model.rgrid,...
                                model.ipelem,model.rpelem, model.iprop,...
                                model.pprop,model.rpprop,model.imat,...
                                model.ipmat,model.rpmat,model.imats,...
                                model.ipmats,model.rpmats,u,du);
                            
                    if (ierr ~= 0)
                        return;
                    end

                    [spak,ierr] = assemblek(ket,dofloc,ltobtrnsm,spak);
                    spadr(dofloc)  = spadr(dofloc) + dR;

                else
                    if (ierr ~= 0)
                        return;
                    end
                end
            end

            % solve disp_inc
            % [disp_inc0] = lsqr(spakt,spadf - nlstat.rsd_rhs_cur + spadr,1e-6,500);
            [disp_inc0] = lsqr(spakt,spadf + spadr,1e-6,500);

            du(gdofloc) = disp_inc0;
            nlstat.disp_cur = nlstat.disp_last_subiter + du;

            % nlstat.rsd_rhs_cur_last_subiter = nlstat.rsd_rhs_cur;

            % [nlstat.rsd_rhs_cur] = calresidual(nlstat.disp_cur,spakt,spadf);

            % criterion
        end
    end
end

end