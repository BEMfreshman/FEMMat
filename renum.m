function [model, ierr] = renum(model)

% renum subroutine

ierr = 0;

% quick sort grid with id ascending

[model,ierr] = modelsort(model);
if (ierr ~= 0)
    return;
end

% renum grid id in iegrid
for i = 1:model.liegrid
    model.iegrid(i) = find (model.igrid(1,:) == model.iegrid(i));
end

% renum grid id in spc

igs = model.ipspc(model.ispc(3,:));
igs = reshape([igs,igs+2]',[],1);
for i = 1:length(igs)
    gid = model.ipspc(igs(i));
    if (gid == 0)
        continue;
    end
    iid = find(gid == model.igrid(1,:));
    model.ipspc(igs(i)) = iid;
end


% renum iprop id in ielem
for i = 1:model.nelem
    pt = model.ielem(3,i);
    model.ipelem(pt) = find (model.iprop(1,:) == model.ipelem(pt));
end

% renum mat id in iprop
for i = 1:model.nprop
    iptype = model.iprop(2,i);
    if (iptype == 1) 
        % PSHELL
        pt = model.iprop(3,i);
        for j = 1: 4
            pos = pt + j - 1;
            if (model.ipprop(pos) > 0)
                model.ipprop(pos) = find(model.imat(1,:) == model.ipprop(pos));
            end
        end
    end
end

end

