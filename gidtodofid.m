function [dofid] = gidtodofid(gid)

    dofid = repmat(gid,1,6);
    dofid = (dofid - 1) * 6;

    dofid = dofid + repmat([1:6],6,1);
    dofid = reshape(dofid',[],1);

end