function [p, p_hat] = fit_phase1_v2(x, y, L, exponent, DEBUG)

    l = find(x <= L);
    l = l(end);

    xseg = x(1:l);
    yseg = y(1:l);

    gamma = -exponent;
    p = gamma / (L+gamma);
    p_hat = ones(1,2) * 0.1;

    % param = lsqcurvefit(@phase1_close_form_v2_log, [p 0.1], xseg, log(yseg));
    param = lsqcurvefit(@phase1_close_form_v3_log, [p 0.1], xseg, log(yseg));

    p = param(1);
    p_hat = param(2);

    if DEBUG
        fprintf('  phase1: p = %.4f, p_hat = ', param(1));
        fprintf('%.4f,', param(2:end));
        fprintf('\n');
    end

    if DEBUG
        fh = figure(1); clf;
        plot(x, y, 'bo');
        hold on;

        % plot(x, phase1_close_form_v2(param, x), '-g');
        plot(x, phase1_close_form_v3(param, x), '-g');

        set(gca, 'xscale', 'log');
        set(gca, 'yscale', 'log');
        set(gca, 'ylim', [min(y(y>0)) max(y)*1.1]);
    end
end

