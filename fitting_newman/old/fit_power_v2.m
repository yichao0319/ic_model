function [L, U, a, exponent] = fit_power_v2(x, y, L, U, exponent, DEBUG)

    l = find(x >= L);
    l = l(1);
    u = find(x <= U);
    u = u(end);

    l_hat = l + min(50, round((u-l)/4));
    for l2 = 1:l_hat
        xseg = x(l2:u);
        yseg = y(l2:u);

        param = lsqcurvefit(@phase2_close_form_log, [1 exponent], xseg, log(yseg), ...
                               [-Inf exponent*1.01], [Inf, exponent*0.99]);
        rmse(l2) = cal_log_err(phase2_close_form(param, xseg), yseg);

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

        param = lsqcurvefit(@phase2_close_form_log, [1 exponent], xseg, log(yseg), ...
                               [-Inf exponent*0.999], [Inf, exponent*1.001]);
        rmse(u2-u_hat+1) = cal_log_err(phase2_close_form(param, xseg), yseg);

        if DEBUG, fprintf('  u2=%d, rmse=%.4f\n', u2, rmse(u2-u_hat+1)); end
    end
    [~,uu] = min(rmse);
    uu = uu + u_hat - 1;

    L = x(ll);
    U = x(uu);

    if DEBUG
        fprintf('  phase 2: \n');
        fprintf('  L idx from %d -> %d (max=%d)\n', l, ll, l_hat);
        fprintf('  U idx from %d -> %d (min=%d)\n', u, uu, u_hat);
        fprintf('  exponent = %.4f\n', exponent);
    end


    if DEBUG
        fh = figure(2); clf;
        plot(x, y, 'bo');
        hold on;
        plot(x, phase2_close_form(param, x), '-r');
        set(gca, 'xscale', 'log');
        set(gca, 'yscale', 'log');
        set(gca, 'ylim', [min(y(y>0)) max(y)*1.1]);
    end

end