function y = close_form_pl_shift_geom_cutoff(param, x)
    %% y = a * (x-x0)^exponent * o^(b*x)
    a        = param(1);
    x0       = param(2);
    exponent = param(3);
    o        = param(4);

    y = a * ((x-x0).^exponent) .* (o.^(x));
end
