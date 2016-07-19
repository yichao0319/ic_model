function y = close_form_pl_criticality(param, x)
    %% y = a * x^exponent * b^x * e^(z*sqrt(x))
    a        = param(1);
    exponent = param(2);
    b        = param(3);
    z        = param(4);

    y = a * (x.^exponent) .* (b.^x) .* (exp(z.*sqrt(x)));
end
