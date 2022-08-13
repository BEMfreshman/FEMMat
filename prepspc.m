function [model,ierr] = prepspc(model)
    ierr = 0;

    uidx = unique(model.ispc(1,:));

    nspc0 = length(uidx);

    jspc = zeros(3,nspc0);

    model.nspc0  = nspc0;
%     model.wispc  = zeros(4,nspc0);
%     model.wipspc = zeros(2*nspc0);
%     model.wrpspc = zeros(nspc0);

    pos = 1;
    for i = 1: nspc0
        jspc(1,i) = uidx(i);
        jspc(2,i) = pos;
        jspc(3,i) = sum(uidx(i) == model.ispc(1,:));
    end

%     ptwipspc = 1;
%     ptwrpspc = 1;
%     for i = 1:nspc0
%         uid = uidx(i);
%         pos = jspc(2,i);
%         n   = jspc(3,i);
%         gi = model.ipspc(model.ispc(3,pos:pos+n-1));
%         ci = model.ipspc(model.ispc(3,pos:pos+n-1)+1);
%         di = model.rpspc(model.ispc(5,pos:pos+n-1));
% 
%         wispc = [uid,ptwipspc,ptwrpspc,n];
%         wipspc = reshape([gi,ci]',[],1);
%         wrpspc = di;
% 
%         model.wispc(:,i) = wispc;
%         model.wipspc(ptwipspc:ptwipspc+n*2-1) = wipspc;
%         model.wrpspc(ptwrpspc:ptwrpspc+n-1) = wrpspc;
% 
%         ptwipspc = ptwipspc + n * 2;
%         ptwrpspc = ptwrpspc + n;
% 
% 
%     end

end