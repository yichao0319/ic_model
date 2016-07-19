function y = close_form_mc_internal_p1(param, x)
    L      = param(1);
    lambda = param(2);
    eta    = param(3);
    f      = param(4);

    % term1 = lambda*(L-f) + 2*f*(lambda+eta);
    % term2 = lambda*(L-f) + 2*f*(lambda+eta) + L*(lambda+eta);
    % p = term1 / term2;

    term1 = lambda*(L-f) + 2*f*(lambda+eta);
    term2 = (lambda+eta);
    exponent = term1 / term2;

    p = exponent / (exponent + L);

    y = p*(1-p).^(x);
end
