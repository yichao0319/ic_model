function [zeta] = hurwitz_zeta(alpha, x_min)
    zeta = 0;
    thresh = 1e-20;
    for n = [0:99999]
        term1 = ((n+x_min)^(-alpha));
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
