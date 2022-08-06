%% model data

model.igrid  = [];   % igrid(3,ngrid)
model.ipgrid = [];
model.rpgrid = [];   % rgrid(3,ngrid)

model.ielem  = [];   % ielem(8,numel)
                     % 1 - id  2 - usrid  3 - ietype  4 - pointer to iegrid
                     % 5 - pointer to ipdata  6 - nipdata
                     % 7 - pointer to rpdata  8 - nrpdata
model.iegrid = [];   % 1-dim
model.ipdata = [];   % 1-dim
model.rpdata = [];   % 1-dim

model.iprop = [];    % iprop(7,nprop)
                     % 1 - id, 2 - usrid, 3 - iptype, 4 - pointer to ipprop
                     % 5 - nipprop, 6 - pointer rpprop, 7 - nrpprop
model.ipprop = [];
model.rpprop = [];

model.imat  = [];    % imat(7,nmat)
                     % 1 - id, 2 - usrid, 3 - iptype, 4 - pointer to ipmat
                     % 5 - nipmat, 6 - pointer rpmat, 7 - nrpmat
model.ipmat = [];
model.rpmat = [];

model.iforce = [];   % iforce(3,nfrc)
model.ipfrc  = [];
model.rpfrc  = [];

model.ispc   = [];
model.ipspc  = [];
model.rpspc  = [];

model.inlprm  = [];
model.ipnlprm = [];
model.rpnlprm = [];

% isubtype
% 1 - STAT
% 2 - NLSTAT

model.isub   = [];   % isub(7,nsub)
model.ipsub  = [];
model.rpsub  = [];

model.istsub = [];  % static sub isub
                     % 1 - id   2 -  usr id
                     % 3 - type (LINEAR or NLSTAT)
                     % 4 - pointer to ipstsub  5 - nipstsub
                     % 6 - pointer to rpstsub  7 - nrpstsub
model.ipstsub = [];  
model.rpstsub = [];

model.nsub   = 0;
model.nstsub = 0;
model.nnlstt = 0;

model.ngrid = 0;
model.nelem = 0;
model.nmat  = 0;
model.nprop = 0;
model.nforce = 0;
model.nspc = 0;

% local var
ierr   = 0;
nstt   = model.nstsub;   % number of static analysis (include linear and nonlinear)
nnlstt = model.nnlstt;   % number of nonlinear static analysis

%% pre-process
filename = "";

[model,~,ierr] = readfem(filename);
if (ierr ~=0 ) 
    error('fail in read fem');
end
%% renum
[~,~,ierr] = renum(model);
if (ierr ~=0)
    error('fail in renum');
end

%% solver

if (nstt - nnlstt ~= 0)
   % linear static 
   [~,~,ierr] = lstat_main(model);
else
   % non-linear static
    
end

if (ierr ~= 0)
    error('fail in solver')
end

















