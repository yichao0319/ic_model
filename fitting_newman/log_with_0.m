function [logy] = log_with_0(y)
    idx1 = find(y <= 0);
    idx2 = find(y > 0);

    logy = y;
    logy(idx1) = 0;
    logy(idx2) = log(y(idx2));
end