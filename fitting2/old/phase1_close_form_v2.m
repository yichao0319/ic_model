function y = phase1_close_form_v2(param, x)
    %% p_hat = y(1) / p / ((1-p)^(1-1));
    %% p = p1_hat*p*(1-p)^(k-1) + (p2_hat)*p*(1-p)^(k-2) + (p3_hat*p*(1-p)^(k-3) +
    %%     (1-p1_hat-p2_hat-p3_hat)*p*(1-p)^(k-4)
    p = param(1);
    p_hat = param(2);

    y(1) = p_hat * p;

    l = length(x);
    y(2:l) = (1-p_hat) * p * ((1-p).^( x(2:l)-2));
    y = y';
end
