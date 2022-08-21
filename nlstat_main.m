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
        
        while(nlstat.n_subiter <= max_sub_niter)
            
            gdofloc = [1:6*ngrid]';
            
            % build k and f
            for ie = 1:nelem
                eiid   = ielem(1,ie);
                ietype = ielem(2,ie);
                if (ietype == 3)
                    % cquad4
                    
                elseif (ietype == 4)
                    % cqpstn
                    
                    % todo
                    [ket,dofloc,ierr] = quad4k_tangent(eiid,ietype,model.ielem,model.iegrid,model.rgrid,...
                                    model.ipelem,model.rpelem,model.iprop,model.ipprop,...
                                    model.rpprop,model.imat,model.ipmat,model.rpmat);
                else
                    ierr  = 1;
                    return;
                end
                
                [ltobtrnsm,~] = shellcord(eiid,model.ielem,model.iegrid,...
                                      model.rgrid);
            
                [spakt,ierr] = assemblek(ket,dofloc,ltobtrnsm,spakt);
            end
            
            % solve disp_inc
            [disp_inc0] = lsqr(spakt,spadf,1e-6,500);
            
            du = zeros(ngrid*6,1);
            du(gdofloc) = disp_inc0;
            
            nlstat.disp_cur = nlstat.disp_last_subiter + du;
            
            for ie = 1:nelem
                % calculate dstrain on gauss int point of each element
                eiid   = ielem(1,ie);
                ietype = ielem(2,ie);
                
                ptipelem = ielem(4,ie);
                pid = iprop(ptipelem);   % internal prop id
                
                [D,ierr] = shellsmat(strtype,eid,ietype,model.ielem,...
                     model.ipelem,model.rpelem,pid,model.iprop,...
                     model.ipprop,model.rpprop,model.imat,...,
                     model.ipmat,model.rpmat);
                 
                if (ietype == 3)
                    % cquad4
                    
                elseif (ietype == 4)
                    % cqpstn
                    
                    % get id of mat1 and mats1
                    
                    ip_ipprop = iprop(3,pid);
                    mid     = ipprop(ip_ipprop);
                    
                    imattype  = imat(2,mid);
                    ip_ipmat  = imat(3,mid);
                    
                    if (imattype == 1) 
                        % mat1
                        msid = ipmat(ip_ipmat); 
                    else
                        ierr = 1;
                        return;
                    end
                    
                    if (msid == 0)
                        % no mats1 material
                        disp('no mats1 was found');
                        ierr = 1;
                        return;
                    end
                    
                    % key mats1 parameter
                    ip_ipmats = model.imats(3,msid);
                    ip_rpmats = model.imats(5,msid);
                    
                    h    = model.rpmats(ip_rpmats);
                    lit1 = model.rpmats(ip_rpmats+1);
                    
                    
                    
                    
                    % calulate strn due to disp
                    
                    vldocloc = [1,2,4]';
                    strs = quad4_strs_int(strtype,eiid,model.ielem,...
                                            model.iegrid,model.rgrid,...
                                            vldocloc,D,disp);
                    
                    % calulate trial dstrs
                    
                    [dstrn,ierr] = quad4_strn_int(strtype,eiid,model.ielem,...
                                            model.iegrid,model.rgrid,vldocloc,...
                                            du);  
                    if (ierr ~= 0)
                        return;
                    end
                    
                    [dstrs_trial,ierr] = strn2strs(dstrn,vldocloc,D);

                    strs_trial = strs + dstrs_trial; % (6,ngint)

                    % calculte I1 J2 J3 and theta
                    
                    [~,ngint] = siz(strs_trial);
                    
                    for i = 1:ngint
                        [i1,i2,i3,j1,j2,j3,ierr] = strsIJ(strs_trial(:,i));
                        if (ierr ~=0)
                            return;
                        end
                        
                        
                    end
                    
                    
                else
                    
                end
                
                
                
            end

        end
    end
end

end