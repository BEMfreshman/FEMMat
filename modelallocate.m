function [model,ierr] = modelallocate(model)

    ierr = 0;
    model.igrid = zeros(5,model.ngrid);
    model.rgrid = zeros(3,model.ngrid);

    model.idelem = zeros(2,model.nelem);
    model.ielem  = zeros(7,model.nelem);
    model.iegrid = zeros(model.liegrid,1);
    model.ipelem = zeros(model.lipelem,1);
    model.rpelem = zeros(model.lrpelem,1);

    model.iprop = zeros(7,model.nprop);
    model.ipprop = zeros(model.lipprop,1);
    model.rpprop = zeros(model.lrpprop,1);

    model.imat = zeros(6,model.nmat);
    model.ipmat = zeros(model.lipmat,1);
    model.rpmat = zeros(model.lrpmat,1);

    model.iforce = zeros(7,model.nforce);
    model.ipfrc  = zeros(model.lipfrc,1);
    model.rpfrc  = zeros(model.lrpfrc,1);

    model.ispc   = zeros(6,model.nspc);
    model.ipspc  = zeros(model.lipspc,1);
    model.rpspc  = zeros(model.lrpspc,1);

    % the sub

end