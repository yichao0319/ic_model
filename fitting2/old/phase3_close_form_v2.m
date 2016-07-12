function [prob] = phase3_close_form_v2(k, L, U, gamma)
    term1 = gamma/(gamma+U);
    term2 = ((U/(gamma+U)).^(k-U-1));
    term3 = U/L;
    term41 = factorial(U-1) / factorial(L-1);
    term42 = factorial(U+L) / factorial(L+L);
    term5 = (L/(gamma+L))^L;
    prob = term1 * term2 * term3 * term41/term42 * term5;
end