function [outv] = f2d(wline,hasstr,fn,inv)
    outv = inv;
    if (hasstr(fn) ~= 0)
        outv = s2d(wline,fn);
    end
end