function [num] = s2d(wline,fno)
    sta = (fno - 1) * 8 + 1;
    ed  = fno * 8;

    num = str2double(wline(sta:ed));
end