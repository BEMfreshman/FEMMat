function [num] = s2d(wline,fno)
    sta = (fno - 1) * 8 + 1;
    ed  = fno * 8;

    pat = '([0-9.])([-+])([0-9])';
    rep = '$1e$2$3';

    newstr = regexprep(wline(sta:ed),pat,rep);
    num = str2double(newstr);
end