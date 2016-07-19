function [param] = fit_pl_shift(x, y)
    param = lsqcurvefit(@close_form_pl_shift, [1 0 -3], x, y);
end
