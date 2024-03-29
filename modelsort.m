function [model,ierr] = modelsort(model)
    ierr = 0;

    %% sort grid with id ascending

    igrid = model.igrid;
    rgrid = model.rgrid;

    [~,inx] = sort(igrid(1,:));

    model.igrid = igrid(:,inx);
    model.rgrid = rgrid(:,inx);

    %% sort ielem
    % build model.idelem
    
    nelem = model.nelem;
    model.idelem(1,:) = model.ielem(1,:);
    model.idelem(2,:) = 1:nelem;          % pointer to ielem

    % firstly, sort it depend on ietype
    iets = model.ielem(2,:);

    [~,inx] = sort(iets);
    model.idelem = model.idelem(:,inx);

    cnt = 1;
    for i = 1: model.neletype
        model.jelem(1,i) = i;
        model.jelem(2,i) = cnt;
        model.jelem(3,i) = sum(iets == i);
        cnt = cnt + model.jelem(3,i);
    end

    % then sort within every type of elem by id ascending

    for i = 1:model.neletype
        pos    = model.jelem(2,i);
        n      = model.jelem(3,i);
        if (n == 0)
            continue;
        end
        [~,inx] = sort(model.idelem(1,pos:pos+n-1));
        model.idelem(:,pos:pos+n-1) = model.idelem(:,inx);
    end

    %% sort prop
    [~,inx] = sort(model.iprop(1,:));
    model.iprop = model.iprop(:,inx);

    %% sort mat
    if (model.nmat ~= 0)
        [~,inx] = sort(model.imat(1,:));
        model.imat = model.imat(:,inx);
    end
    
    %% sort mats
    if (model.nmats ~= 0)
        [~,inx] = sort(model.imats(1,:));
        model.imats = model.imats(:,inx);
    end
    
    %% sort frc
    [~,inx] = sort(model.ifrc(1,:));
    model.ifrc = model.ifrc(:,inx);

    %% sort pres
    [~,inx] = sort(model.ipres(1,:));
    model.ipres = model.ipres(:,inx);
    
    %% sort spc
    [~,inx] = sort(model.ispc(1,:));
    model.ispc = model.ispc(:,inx);


end