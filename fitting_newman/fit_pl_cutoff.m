%% fit_pl_cutoff: function description
function [param] = fit_pl_cutoff(x, y)
    param = lsqcurvefit(@close_form_pl_cutoff, [1 -3 1], x, y);
end