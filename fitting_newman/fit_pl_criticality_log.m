function [param] = fit_pl_criticality_log(x, y)
    param = lsqcurvefit(@close_form_pl_criticality_log, [1 -3 1 1], x, log10(y));
end
