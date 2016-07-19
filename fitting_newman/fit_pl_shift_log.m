function [param] = fit_pl_shift_log(x, y)
    param = lsqcurvefit(@close_form_pl_shift_log, [1 0 -3], x, log10(y));
end
