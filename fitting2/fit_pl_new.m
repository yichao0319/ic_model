function [param] = fit_pl_new(x, y)
    param = lsqcurvefit(@close_form_pl_new, [1 0 -3 2 1], x, y);
end
