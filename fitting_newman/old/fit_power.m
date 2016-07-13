function [pl_curve, L, U, exponent] = fit_power(x, y, L, U, DEBUG)

    l = find(x >= L);
    l = l(1);
    u = find(x <= U);
    u = u(end);

    l_hat = l + min(50, round((u-l)/4));
    rmse = ones(1, l_hat) * Inf;
    for l2 = l_hat:-1:1
        xseg = x(l2:u);
        yseg = y(l2:u);

        [curve1, gof] = fit(xseg, yseg, 'power1');
        %% get log error
        rmse(l2) = cal_log_err(curve1(xseg), yseg);

        if l2 < l_hat-2
            if rmse(l2) > rmse(l2+1) & rmse(l2) > rmse(l2+3)
                break;
            end
        end

        if DEBUG, fprintf('  l2=%d, rmse=%.4f\n', l2, rmse(l2)); end
    end
    [~,ll] = min(rmse);

    rmse = [];
    u_hat = u - min(50, round((u-l)/4));
    miny = min(y);
    idx = find(y == miny);
    u_end = idx(1);
    for u2 = u_hat:u_end
        xseg = x(ll:u2);
        yseg = y(ll:u2);

        [curve2{u2-u_hat+1}, gof] = fit(xseg, yseg, 'power1');
        %% get log error
        rmse(u2-u_hat+1) = cal_log_err(curve2{u2-u_hat+1}(xseg), yseg);

        if u2 > u_hat + 3
            if rmse(u2-u_hat+1) > rmse(u2-u_hat) & rmse(u2-u_hat+1) > rmse(u2-u_hat-2)
                break;
            end
        end

        if DEBUG, fprintf('  u2=%d, rmse=%.4f\n', u2, rmse(u2-u_hat+1)); end
    end
    [~,uu] = min(rmse);
    pl_curve = curve2{uu};
    uu = uu + u_hat - 1;

    L = x(ll);
    U = x(uu);
    exponent = pl_curve.b;


    if DEBUG
        fprintf('  L idx from %d -> %d (max=%d)\n', l, ll, l_hat);
        fprintf('  U idx from %d -> %d (min=%d)\n', u, uu, u_hat);
        fprintf('  exponent = %.4f\n', exponent);
    end


    if DEBUG
        fh = figure(2); clf;
        plot(x, y, 'bo');
        hold on;
        plot(x, pl_curve(x), '-r');
        set(gca, 'xscale', 'log');
        set(gca, 'yscale', 'log');
        set(gca, 'ylim', [min(y(y>0)) max(y)*1.1]);
    end

end