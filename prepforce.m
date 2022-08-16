function [model,ierr] = prepforce(model)
    ierr = 0;

    uidx = unique(model.ifrc(1,:));

    nfrc0 = length(uidx);
    model.nfrc0 = nfrc0;

    jfrc = zeros(3,nfrc0);

    pos = 1;
    for i = 1:nfrc0
        jfrc(1,i) = uidx(i);
        jfrc(2,i) = pos;
        jfrc(3,i) = sum(uidx(i) == model.ifrc(1,:));

        pos = pos + jfrc(3,i);
    end
    
    model.jfrc = jfrc;

end