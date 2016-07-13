function [zeta] = riemann_zeta(alpha)
    zeta = 0;
    thresh = 1e-20;
    for n = [1:99999]
        term1 = (n^(-alpha));
        zeta = zeta + term1;

        if abs(term1) < thresh
            break;
        end

        % if mod(n, 1000) == 0
        %     fprintf('  n=%d, zeta=%g\n', n, zeta);
        % end
    end

    % fprintf('  n=%d, zeta=%g\n', n, zeta);
end