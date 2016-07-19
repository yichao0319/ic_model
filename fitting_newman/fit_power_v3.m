function [fit_data, a, exponent] = fit_power_v3(x, y, L, U, DEBUG)
    if nargin < 5, DEBUG = 0; end

    idx = find(x >= L & x <= U);
    exponent = -(L+1);

    parm = lsqcurvefit(@phase2_close_form_log, [1 exponent], x(idx), log_with_0(y(idx)), [-Inf exponent-1], [Inf exponent]);
    a = parm(1);
    exponent = parm(2);

    %% phase 2 - seg 2
    xseg2 = x(idx);
    yseg2 = a*(xseg2.^exponent);
    % lh(4) = plot(xseg2, yseg2, '-');
    % set(lh(4), 'Color', colors{1});
    % set(lh(4), 'LineWidth', 5);

    %% phase 2 - seg 1
    idx = find(x>0 & x<=L);
    if length(idx) > 0
        xseg1 = x(idx);
        yseg1 = a*(xseg1.^exponent);
        % lh2 = plot(xseg1, yseg1, '--');
        % set(lh2, 'Color', colors{1});
        % set(lh2, 'LineWidth', 2);
    end

    %% phase 2 - seg 3
    idx = find(x>=U);
    if length(idx) > 0
        xseg3 = x(idx);
        yseg3 = a*(xseg3.^exponent);
        % lh2 = plot(xseg3, yseg3, '--');
        % set(lh2, 'Color', colors{1});
        % set(lh2, 'LineWidth', 2);
    end


    fit_data.xseg1 = xseg1;
    fit_data.xseg2 = xseg2;
    fit_data.xseg3 = xseg3;
    fit_data.est_yseg2 = yseg2;
    fit_data.est_yseg2_others = [yseg1; yseg3];
end
