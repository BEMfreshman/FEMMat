function [model,ierr] = modelallocate(model)

    ierr = 0;
    model.igrid = zeros(5,model.ngrid);
    model.rgrid = zeros(3,model.ngrid);

    model.idelem = zeros(2,model.nelem);
    model.ielem  = zeros(7,model.nelem);
    model.iegrid = zeros(model.liegrid,1);
    model.ipelem = zeros(model.lipelem,1);
    model.rpelem = zeros(model.lrpelem,1);

    model.iprop = zeros(6,model.nprop);
    model.ipprop = zeros(model.lipprop,1);
    model.rpprop = zeros(model.lrpprop,1);

    model.imat = zeros(6,model.nmat);
    model.ipmat = zeros(model.lipmat,1);
    model.rpmat = zeros(model.lrpmat,1);

    model.ifrc   = zeros(6,model.nfrc);
    model.ipfrc  = zeros(model.lipfrc,1);
    model.rpfrc  = zeros(model.lrpfrc,1);

    model.ipres = zeros(6,model.npres);
    model.ippres = zeros(model.lippres,1);
    model.rppres = zeros(model.lrppres,1);

    model.ispc   = zeros(6,model.nspc);
    model.ipspc  = zeros(model.lipspc,1);
    model.rpspc  = zeros(model.lrpspc,1);
    
    model.inlparm = zeros(4,model.nnlparm);

    % the sub

end