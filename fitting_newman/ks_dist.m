function [err] = ks_dist(x, y)
    err = max(abs(cumsum(x)-cumsum(y)));
end
