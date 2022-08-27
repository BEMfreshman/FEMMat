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

nfrc = model.nfrc;
npres = model.npres;

spaf = sparse(ngrid*6,1);

spar = sparse(ngrid*6,1);

% nonlinear state
nlstat.itime = 0;

nlstat.rtime_last = 0.0;
nlstat.rtime_cur  = 0.0;

nlstat.n_iter = 0;
nlstat.n_subiter = 0;

% disp 
nlstat.disp_inc_cur = zeros(ngrid*6,1);
nlstat.disp_inc_last_subiter = zeros(ngrid*6,1);
nlstat.disp_last_iter = zeros(ngrid*6,1);

% residual rhs
nlstat.rsd_rhs_cur = zeros(ngrid*6,1);
nlstat.rsd_rhs_cur_last_iter = zeros(ngrid*6,1);

% local var
max_sub_niter = 50;

epsu = 1e-3;
epsp = 1e-3;

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

    nlstat.n_iter = 0;
    nlstat.q = 0.99;
    while(nlstat.n_iter <= maxiter)
    
        % incr start
        nlstat.n_iter = nlstat.n_iter + 1;
        
        cofload_prev = facloads(nlstat.n_iter);
        cofload_cur  = facloads(nlstat.n_iter + 1); % skip first element, it is 0
        
        if (nfrc ~=0)
            [spaf,ierr] = assemblefrc_inc(loadiid,loaduid,model.ifrc,...
                            model.ipfrc,model.rpfrc,model.jfrc,model.nfrc,...
                            model.nfrc0,cofload_prev,cofload_cur,spaf);
        end
        
        if (npres ~= 0)
            
            
        end

        nlstat.n_subiter = 0;
        while(nlstat.n_subiter <= max_sub_niter)
            
            nlstat.n_subiter = nlstat.n_subiter + 1;
            spakt = sparse(ngrid*6,ngrid*6);    % tangent sparse stiffness matrix
            
            gdofloc = [1:6*ngrid]';

            for ie = 1:nelem
                % calculate dstrain on gauss int point of each element
                eid   = ielem(1,ie);
                ietype = ielem(2,ie);
                
                if (ietype == 3)
                    % cquad4
                    
                elseif (ietype == 4)
                    % cqpstn
                    
                    [ket,dofloc,R,ierr] = quad4k_plastic(eid,ietype,...
                                model.ielem,model.iegrid,model.rgrid,...
                                model.ipelem,model.rpelem, model.iprop,...
                                model.ipprop,model.rpprop,model.imat,...
                                model.ipmat,model.rpmat,model.imats,...
                                model.ipmats,model.rpmats,...
                                nlstat.disp_last_iter,nlstat.disp_inc_cur);
                            
                    if (ierr ~= 0)
                        return;
                    end
                    
                    [ltobtrnsm,~] = shellcord(eid,model.ielem,...
                                        model.iegrid,model.rgrid);

                    [spakt,ierr] = assemblek(ket,dofloc,ltobtrnsm,spakt);
                    spar(dofloc)  = spar(dofloc) + R;

                else
                    if (ierr ~= 0)
                        return;
                    end
                end
            end
            
            % spc
            % _rd matrix has been cancelled row and col with all 0
            [spakt_rd,spaf_rd,gdofloc,ierr] = applyspc(spciid,model.ispc,model.ipspc,...
                                model.rpspc,model.nspc,model.jspc,...
                                model.nspc0,spakt,spaf,gdofloc);
            if (ierr ~= 0) 
                return;
            end
            
            spaf(gdofloc) = spaf_rd;  % retrieve back to full matrix

            % solve disp_inc
            % [disp_inc0] = lsqr(spakt,spadf - nlstat.rsd_rhs_cur + spadr,1e-6,500);
            du = lsqr(spakt_rd,spaf_rd + spar(gdofloc) - nlstat.rsd_rhs_cur(gdofloc),...
                                    1e-6,500);
                                
            nlstat.disp_inc_cur(gdofloc) = du;
            disp_cur = nlstat.disp_last_iter + nlstat.disp_inc_cur;

            % nlstat.rsd_rhs_cur_last_subiter = nlstat.rsd_rhs_cur;

            [nlstat.rsd_rhs_cur(gdofloc)] = calresidual(du,spakt_rd,spaf_rd);

            % criterion for convergence
            
            [uer,ler,q_cur,ierr] = nlconvergence('smalldisp',disp_cur(gdofloc),...
                                nlstat.disp_inc_last_subiter(gdofloc),...
                                nlstat.disp_inc_cur(gdofloc),...
                                nlstat.q,spakt_rd,spaf_rd,spar(gdofloc));
            nlstat.q = q_cur;
            if (abs(uer) < epsu && abs(ler) < epsp)
                nlstat.disp_last_iter = disp_cur;
                nlstat.rsd_rhs_cur_last_iter = nlstat.rsd_rhs_cur;
                break;
            else
                % need more sub_iter
                nlstat.disp_inc_last_subiter = nlstat.disp_inc_cur;
                nlstat.rsd_rhs_cur_last_iter = nlstat.rsd_rhs_cur;
            end
        end
    end
end

end