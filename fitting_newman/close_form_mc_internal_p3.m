function y = close_form_mc_internal_p3(param, x)
    %% term1 = lambda*(L-f) + 2*f*(lambda+eta)
    %% term2 = lambda*(L-f) + 2*f*(lambda+eta) + U*(lambda+eta)
    %% y = term1 / term2

    L      = param(1);
    U      = param(2);
    lambda = param(3);
    eta    = param(4);
    f      = param(5);

    % term1 = lambda*(L-f) + 2*f*(lambda+eta);
    % term2 = lambda*(L-f) + 2*f*(lambda+eta) + U*(lambda+eta);
    % p = term1 / term2;

    % y = p*(1-p).^(x);

    term1 = lambda*(L-f) + 2*f*(lambda+eta);
    term2 = (lambda+eta);
    exponent = term1 / term2;

    p = exponent / (exponent + U);

    y = zeros(size(x));
    for xi = 1:length(x)
        xx = x(xi);

        term1 = prod(1:(U-1)) / (prod(1:(L-1)));
        term2 = gamma(U+exponent+1) / gamma(L+exponent+1);
        term3 = (L/(exponent+L))^L;

        y(xi) = p * ((1-p)^(xx-U-1)) * U / L * term1 / term2 * term3;
    end

end
