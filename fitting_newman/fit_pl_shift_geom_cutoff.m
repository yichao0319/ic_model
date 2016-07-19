function [param] = fit_pl_shift_geom_cutoff(x, y)
    param = lsqcurvefit(@close_form_pl_shift_geom_cutoff, [1 0 -3 1], x, y);
end
