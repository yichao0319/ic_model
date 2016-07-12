function y = close_form_pl_cutoff(param, x)
    %% y = a * x^exponent * e^(b*x)
    a = param(1);
    exponent = param(2);
    b = param(3);

    y = a * (x.^exponent) .* exp(b*x);
end
