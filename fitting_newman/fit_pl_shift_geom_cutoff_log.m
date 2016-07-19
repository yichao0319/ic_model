function [param] = fit_pl_shift_geom_cutoff_log(x, y)
    param = lsqcurvefit(@close_form_pl_shift_geom_cutoff_log, [1 0 -3 1], x, log10(y));
end
