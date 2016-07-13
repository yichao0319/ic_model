function y = phase3_close_form(param, x)
    %% p = c * p * (1-p)^(k-1)
    p = param(1);
    c = param(2);

    y = c * p * ((1-p).^(x-1));
    % y = y';
end
