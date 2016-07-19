function y = phase1_close_form_v3(param, x)
    %% p_hat = y(1) / p / ((1-p)^(1-1));
    p = param(1);
    p_hat = param(2);

    l = length(x);
    y = p_hat * p * ((1-p).^(x-1));
end
