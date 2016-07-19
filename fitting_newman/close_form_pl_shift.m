function y = close_form_pl_shift(param, x)
    %% y = a * (x-x0)^exponent
    a        = param(1);
    x0       = param(2);
    exponent = param(3);

    y = a * ((x-x0).^exponent);
end
