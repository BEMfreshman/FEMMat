%% model data

% model pointer
model.ptgrid = 0;
model.ptelem = 0;
model.ptprop = 0;
model.ptmat = 0;
model.ptforce = 0;
model.ptpres = 0;
model.ptspc = 0;


model.igrid  = [];   % igrid(5,ngrid)
model.rgrid  = [];   % rgrid(3,ngrid)


model.idelem = [];   % (2,nelem) (1,.) - usrid
                     %           (2,.) - iid
model.ielem  = [];
model.iegrid = [];   % 1-dim
model.ipelem = [];   % 1-dim
model.rpelem = [];   % 1-dim

model.liegrid = 0;
model.lipelem = 0;
model.lrpelem = 0;

model.iprop = [];    % iprop(7,nprop)
                     % 1 - id, 2 - usrid, 3 - iptype, 4 - pointer to ipprop
                     % 5 - nipprop, 6 - pointer rpprop, 7 - nrpprop
model.ipprop = [];
model.rpprop = [];

model.lipprop = 0;
model.lrpprop = 0;

model.imat  = [];
model.ipmat = [];
model.rpmat = [];

model.lipmat = 0;
model.lrpmat = 0;

model.iforce = [];   % iforce(7,nfrc)
model.ipfrc  = [];
model.rpfrc  = [];

model.lipfrc = 0;
model.lrpfrc = 0;

model.ipres  = [];   % ipres(7,npres)
model.ippres = [];
model.rppres = [];

model.wipres  = [];
model.wippres = [];
model.wrppres = [];

model.ispc   = [];
model.ipspc  = [];
model.rpspc  = [];

model.wispc  = [];
model.wipspc = [];
model.wrpspc = [];

model.inlprm  = [];
model.ipnlprm = [];
model.rpnlprm = [];

% isubtype
% 1 - STAT
% 2 - NLSTAT

model.isub   = [];
model.rsub   = [];

model.istsub = [];  
model.rstsub = [];

model.nsub   = 0;
model.nstsub = 0;
model.nnlstt = 0;

model.ngrid = 0;
model.nelem = 0;
model.nmat  = 0;
model.nprop = 0;

model.nforce  = 0;
model.nforce0 = 0;

model.npres  = 0;
model.npres0 = 0;

model.nspc  = 0;
model.nspc0 = 0;

% local var
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

%% prep
[ierr] = prep(model);
if (ierr ~= 0)
    error('fail in prep');
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

















