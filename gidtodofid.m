function [dofid] = gidtodofid(gid)

    dofid = repmat(gid,1,6);
    dofid = (dofid - 1) * 6;

    [nrow,~] = size(dofid);
    dofid = dofid + repmat([1:6],nrow,1);
    dofid = reshape(dofid',[],1);

end