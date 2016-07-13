function [fit_data, p, p_hat] = fit_phase1_v3(x, y, L, U, exponent, DEBUG)
    if nargin < 6, DEBUG = 0; end

    l = find(x <= L);
    l = l(end);

    xseg = x(1:l);
    yseg = y(1:l);

    gamma = -exponent;
    p = gamma / (L+gamma);
    p_hat = ones(1,2) * 0.1;

    % param = lsqcurvefit(@phase1_close_form_v2_log, [p 0.1], xseg, log(yseg));
    param = lsqcurvefit(@phase1_close_form_v3_log, [p 0.1], xseg, log_with_0(yseg));

    p = param(1);
    p_hat = param(2);


    %% seg 1
    idx = find(x>0 & x<=L);
    xseg1 = x(idx);
    yseg1 = phase1_close_form_v3(param, xseg1);

    %% seg 2
    idx = find(x>=L & x<=U);
    xseg2 = x(idx);
    yseg2 = phase1_close_form_v3(param, xseg2);

    %% seg 3
    idx = find(x>=U);
    xseg3 = x(idx);
    yseg3 = phase1_close_form_v3(param, xseg3);


    fit_data.xseg1 = xseg1;
    fit_data.xseg2 = xseg2;
    fit_data.xseg3 = xseg3;
    fit_data.est_yseg1 = yseg1;
    fit_data.est_yseg1_others = [yseg2; yseg3];


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

