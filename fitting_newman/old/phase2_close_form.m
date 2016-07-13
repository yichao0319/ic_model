function y = phase2_close_form(param, x)
    %% p = a * x ^ exponent
    a = param(1);
    exponent = param(2);

    y = a * (x.^exponent);
    % y = y';
end
