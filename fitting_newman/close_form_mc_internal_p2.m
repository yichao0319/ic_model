function y = close_form_mc_internal_p2(param, x)
    %% term1 = lambda*(L-f) + 2*f*(lambda+eta)
    %% term2 = (lambda+eta)
    %% gamma = term1 / term2
    %% y = x^(-gamma)

    L      = param(1);
    lambda = param(2);
    eta    = param(3);
    f      = param(4);

    term1 = lambda*(L-f) + 2*f*(lambda+eta);
    term2 = (lambda+eta);
    exponent = term1 / term2;

    % y = x.^(-exponent);
    y = zeros(size(x));
    for xi = 1:length(x)
        xx = x(xi);

        term1 = prod(1:(xx-1)) / (prod(1:(L-1)));
        term2 = gamma(xx+exponent+1) / gamma(L+exponent+1);
        term3 = (L/(exponent+L))^L;

        y(xi) = exponent / L * term1 / term2 * term3;
    end
end
