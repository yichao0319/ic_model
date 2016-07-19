function [param] = fit_pl_criticality(x, y)
    param = lsqcurvefit(@close_form_pl_criticality, [1 -3 1 1], x, y);
end
