function [wline,hasstr] = preprocesstext(line,maxlen)

    if (mod(maxlen,8)~=0)
        return;
    end

    len = length(line);

    if (len == maxlen)
        wline = line;
    else
        wline = [line,repmat(' ',1,maxlen - len)];
    end

    nf = maxlen / 8;

    hasstr = zeros(nf,1);

    sta = linspace(1,8*(nf-1)+1,nf)';
    ed  = sta + 7;

    for i = 1:nf
        hasstr(i) = ~isempty(strtrim(wline(sta(i):ed(i))));
    end

end