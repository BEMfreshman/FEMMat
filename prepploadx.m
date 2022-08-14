function [model,ierr] = prepploadx(model)
    ierr = 0;

    uidx = unique(model.ipres(1,:));

    npres0 = length(uidx);

    jpres = zeros(3,npres0);

    model.npres0  = npres0;

%     model.wippres = zeros(6,npres0);
% 
%     lwippres = 0;
%     lwrppres = 0;
% 
%     for i = 1:model.npres
%         type = model.ipres(2,i);
%         if (type == 2)
%             % pload2
%             lwippres = lwippres + 1;
%             lwrppres = lwrppres + 1;
%         elseif (type == 3)
%             % pload4
%             lwippres = lwippres + 4;
%             lwrppres = lwrppres + 7;
%         end
%     end
% 
%     model.wippres = zeros(lwippres,1);
%     model.wrppres = zeros(lwrppres,1);

    pos = 1;
    for i = 1:npres0
        jpres(1,i) = uidx(i);
        jpres(2,i) = pos;
        jpres(3,i) = sum(uidx(i) == model.ipres(1,:));
    end

%     ptwippres = 1;
%     ptwrppres = 1;
% 
%     for i = 1:npres0
%         uid = uidx(i);
%         pos = jspc(2,i);
%         n   = jspc(3,i);
% 
%         pti = ptwippres;
%         ptr = ptwrppres;
% 
%         ni = 0;
%         nr = 0;
% 
%         for j = pos:pos+n-1
%             type = model.ipres(2,j);
%             ptippres = model.ipres(3,i);
%             ptrppres = model.ipres(5,i);
%             if (type == 2)
%                 % pload2
%             else
%                 % pload4
%                 wippres = model.ippres(ptippres:ptippres+4-1);
%                 wrppres = model.rppres(ptrppres:ptrppres+7-1);
%                 
%                 model.wippres(pti:pti+4-1) = wippres;
%                 model.wrppres(ptr:ptr+7-1) = wrppres;
% 
%                 ni = ni + 4;
%                 nr = nr + 7;
% 
%                 pti = pti + 4;
%                 ptr = ptr + 7;
%                 
%             end
%         end
% 
%         wipres = [uid]
% 
% 
%     end


end