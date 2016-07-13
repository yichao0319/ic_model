function [param] = fit_pl_cutoff_log(x, y)
    param = lsqcurvefit(@close_form_pl_cutoff_log, [1 -3 0], x, log10(y));
end
