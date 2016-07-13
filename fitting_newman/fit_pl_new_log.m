function [param] = fit_pl_new_log(x, y)
    param = lsqcurvefit(@close_form_pl_new_log, [1 0 -3 2 0], x, log10(y));
end
