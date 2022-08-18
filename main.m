%% model data

clear;
clc;

% model global constant
model.neletype = 3;

% model pointer
model.ncgrid = 1;
model.ncelem = 1;
model.ncprop = 1;
model.ncmat = 1;
model.ncfrc = 1;
model.ncpres = 1;
model.ncspc = 1;
model.ncnlparm = 1;

model.igrid  = [];   % igrid(5,ngrid)
model.rgrid  = [];   % rgrid(3,ngrid)


model.idelem = [];   % (2,nelem) (1,.) - usrid
                     %           (2,.) - iid

model.jelem  = zeros(3,model.neletype);  % (3,neletype)
                                         %        (1,.) - ietype
                                         %        (2,.) - sta pos in idelem
                                         %        (3,.) - num of ietype

model.ielem  = [];
model.iegrid = [];   % 1-dim
model.ipelem = [];   % 1-dim
model.rpelem = [];   % 1-dim

model.ptelem = zeros(3,1) + 1;  % pt to iegrid, to ipelem , to rpelem

model.liegrid = 0;
model.lipelem = 0;
model.lrpelem = 0;

model.ptprop = zeros(2,1) + 1; % pt to ipprop, to rpprop

model.iprop  = [];    
model.ipprop = [];
model.rpprop = [];

model.lipprop = 0;
model.lrpprop = 0;

model.ptmat = zeros(2,1) + 1; % pt to ipmat, pt to rpmat

model.imat  = [];
model.ipmat = [];
model.rpmat = [];

model.lipmat = 0;
model.lrpmat = 0;

model.ptfrc = zeros(2,1) + 1;

model.jfrc = [];    % (3,nfrc0)
                    %       (1,.) - id
                    %       (2,.) - sta pos of col in ipfrc
                    %       (3,.) - num

model.ifrc = [];   % iforce(7,nfrc)
model.ipfrc  = [];
model.rpfrc  = [];

model.lipfrc = 0;
model.lrpfrc = 0;

model.ptpres = zeros(2,1) + 1;  % pt to ippres, to rppres

model.jpres = []; % (3,npres0)
                  %       (1,.) - id
                  %       (2,.) - sta pos of col in ipres
                  %       (3,.) - num

model.ipres  = [];   % ipres(7,npres)
model.ippres = [];
model.rppres = [];

model.lippres = 0;
model.lrppres = 0;
% 
% model.wipres  = [];  % those 3 array would be allocated in prep subroutine
% model.wippres = [];
% model.wrppres = [];

model.ptspc = zeros(2,1) + 1;  % pt to ipspc, to rpspc

model.jspc = [];  % (3,nspc0)
                  %        (1,.) - id
                  %        (2,.) - sta pos of col in ispc
                  %        (3,.) - num

model.ispc   = [];
model.ipspc  = [];
model.rpspc  = [];

model.lipspc = 0;
model.lrpspc = 0;

% model.wispc  = []; % those 3 array would be allocated in prep subroutine
% model.wipspc = [];
% model.wrpspc = [];

model.inlprm  = [];

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

model.nfrc  = 0;
model.nfrc0 = 0;

model.npres  = 0;
model.npres0 = 0;

model.nspc  = 0;
model.nspc0 = 0;

model.nnlparm = 0;

% local var
nstt   = model.nstsub;   % number of static analysis (include linear and nonlinear)
nnlstt = model.nnlstt;   % number of nonlinear static analysis

% hard code for static analysis
% nstt = 1;
% nnlstt = 0;
% 
% model.nstsub = 1;
% model.istsub = zeros(5,nstt);
% model.istsub(1,1) = 1;
% model.istsub(2,1) = 1;
% model.istsub(3,1) = 1;
% model.istsub(4,1) = 1;
% model.istsub(5,1) = 1;


% hard code for nonlinear static analysis
nstt = 0;
nnlstt = 1;

nsttot = nstt + nnlstt;

model.nstsub = 1;
model.istsub = zeros(5,nsttot);
model.istsub(1,1) = 1;
model.istsub(2,1) = 2;
model.istsub(3,1) = 1;
model.istsub(4,1) = 1;
model.istsub(5,1) = 1;
model.istsub(6,1) = 1;



%% pre-process
%filename = "test/48model.fem";
%filename = 'test/50elem_plane.bdf';
filename = 'test/simpleNL.bdf';

[model,ierr] = readfem(filename,model);
if (ierr ~=0 ) 
    error('fail in read fem');
end

%% sort

[model,ierr] = modelsort(model);
if(ierr ~= 0)
    error('fail in sort');
end

%% renum
[model,ierr] = renum(model);
if (ierr ~=0)
    error('fail in renum');
end

%% prep
[model,ierr] = prep(model);
if (ierr ~= 0)
    error('fail in prep');
end

%% solver

if (nstt - nnlstt ~= 0)
   % linear static 
   [disp,ierr] = lstat_main(model);
else
   % non-linear static
   [disp,ierr] = nlstat_main(model);
end

if (ierr ~= 0)
    error('fail in solver')
end


%% visualization

% plot x

xmax = max(model.rgrid(1,:));
xmin = min(model.rgrid(1,:));

ymax = max(model.rgrid(2,:));
ymin = min(model.rgrid(2,:));

zmax = max(model.rgrid(3,:));
zmin = min(model.rgrid(3,:));

disx = disp(:,1);

if (xmax-xmin == 0 || ymax-ymin == 0 || zmax - zmin == 0)
    if (zmax-zmin == 0)
        d1max = xmax;
        d1min = xmin;
        d1 = model.rgrid(1,:);
        
        d2max = ymax;
        d2min = ymin;
        d2 = model.rgrid(2,:);
    else
        ierr = 1;
        return;
    end
    
    [xmg,ymg] = meshgrid(d1min:d1max,d2min:d2max);
    
    [X,Y,V] = griddata(d1,d2,disx,xmg,ymg,'v4');

    hold on;
    contourf(X,Y,V,30);
    
    shading flat;
    axis equal;
    
    colorbar;
    
else
    xs = linspace(xmin,xmax);
    ys = linspace(ymin,ymax);
    zs = linspace(zmin,zmax);

    [X,Y,Z] = meshgrid(xs,ys,zs);

    V = griddata(model.rgrid(1,:)',model.rgrid(2,:)',model.rgrid(3,:)',...
        dispx,X,Y,Z);

    isosurface(X,Y,Z,V);
end










