function y = close_form_pl_new(param, x)
    %% y = a * (x-x0)^exponent * o^(b*x)
    a        = param(1);
    x0       = param(2);
    exponent = param(3);
    o        = param(4);
    b        = param(5);

    y = a * ((x-x0).^exponent) .* (o.^(b*x));
end
