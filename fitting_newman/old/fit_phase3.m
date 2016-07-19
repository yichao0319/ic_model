function [p, c] = fit_phase3(x, y, U, exponent, DEBUG)

    u = find(x >= U);
    u = u(1);

    xseg = x(u:end);
    yseg = y(u:end);

    gamma = -exponent;
    p = gamma / (U+gamma);

    est_y = phase3_close_form([p 1], xseg);
    c = yseg(1) / est_y(1);
    est_y = c * est_y;

    if DEBUG
        fprintf('  phase3: p = %.4f, c = %.4f\n', p, c);
    end

    if DEBUG
        fh = figure(3); clf;
        plot(x, y, 'bo');
        hold on;
        plot(x, phase3_close_form([p c], x), '-g');
        % plot(xseg, est_y, '-g');
        set(gca, 'xscale', 'log');
        set(gca, 'yscale', 'log');
        set(gca, 'ylim', [min(y(y>0)) max(y)*1.1]);
    end
end