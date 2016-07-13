function y = phase1_close_form(param, x)
    %% p_hat = y(1) / p / ((1-p)^(1-1));
    %% p = p1_hat*p*(1-p)^(k-1) + (p2_hat)*p*(1-p)^(k-2) + (p3_hat*p*(1-p)^(k-3) +
    %%     (1-p1_hat-p2_hat-p3_hat)*p*(1-p)^(k-4)
    p = param(1);
    p_hat = param(2:end);

    for k = 1:length(p_hat)
        y(k) = p_hat(k) * p;
    end

    l = length(x);
    y(k+1:l) = p_hat(end) * p * ((1-p).^( x(k+1:l)-k));
    y = y';
end
