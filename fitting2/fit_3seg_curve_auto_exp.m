function [fit_data] = fit_3seg_curve_auto_exp(x, y, L, U, DEBUG)

    %% First find the lower and upper bound
    [pl_curve, L, U, exponent] = fit_power(x, y, L, U, DEBUG);

    %% Fit the phase 1
    %%   method 1: by iterative heuristic
    % exponent = -3;
    % fit_phase1(x, y, L, exponent, DEBUG);
    %%   method 2: solve a optimization problem with 2 geometric distribution
    [p1, p_hat] = fit_phase1_v2(x, y, L, -3, DEBUG);

    %% Fit the phase 2 again with the given p from phase 1
    %% p = gamma / (L + gamma)
    % exponent = - (p*L/(1-p));
    % [L, U, a, exponent] = fit_power_v2(x, y, L, U, exponent, DEBUG);

    %% Fit the phase 3 by formula
    [p3, c] = fit_phase3(x, y, U, exponent, DEBUG);

    l = find(x <= L);
    l = l(end);
    u = find(x >= U);
    u = u(1);

    xseg1 = x(1:l);
    yseg1 = y(1:l);
    xseg2 = x(l:u);
    yseg2 = y(l:u);
    xseg3 = x(u:end);
    yseg3 = y(u:end);

    % est_yseg1 = phase1_close_form_v2([p1, p_hat], xseg1);
    est_yseg1 = phase1_close_form_v3([p1, p_hat], xseg1);
    est_yseg2 = pl_curve(xseg2);
    est_yseg3 = phase3_close_form([p3 c], xseg3);


    % est_yseg1_others = phase1_close_form_v2_tail([p1, p_hat], [xseg2; xseg3]);
    est_yseg1_others = phase1_close_form_v3_tail([p1, p_hat], [xseg2; xseg3]);
    est_yseg2_others = pl_curve([xseg1; xseg3]);
    est_yseg3_others = phase3_close_form([p3 c], [xseg1; xseg2]);


    fit_data.xseg1 = xseg1;
    fit_data.xseg2 = xseg2;
    fit_data.xseg3 = xseg3;
    fit_data.yseg1 = yseg1;
    fit_data.yseg2 = yseg2;
    fit_data.yseg3 = yseg3;
    fit_data.est_yseg1 = est_yseg1;
    fit_data.est_yseg2 = est_yseg2;
    fit_data.est_yseg3 = est_yseg3;
    fit_data.est_yseg1_others = est_yseg1_others;
    fit_data.est_yseg2_others = est_yseg2_others;
    fit_data.est_yseg3_others = est_yseg3_others;


    if DEBUG
    % if 1
        fh = figure(4); clf;
        lh = plot(x, y, 'bo');
        set(lh, 'MarkerSize', 15);
        hold on;
        lh = plot(xseg1, est_yseg1, '-g');
        set(lh, 'LineWidth', 2);
        lh = plot(xseg2, est_yseg2, '-r');
        set(lh, 'LineWidth', 2);
        lh = plot(xseg3, est_yseg3, '-m');
        set(lh, 'LineWidth', 2);

        lh = plot([xseg2; xseg3], est_yseg1_others, '--g');
        set(lh, 'LineWidth', 2);
        lh = plot([xseg1; xseg3], est_yseg2_others, '--r');
        set(lh, 'LineWidth', 2);
        lh = plot([xseg1; xseg2], est_yseg3_others, '--m');
        set(lh, 'LineWidth', 2);

        set(gca, 'xscale', 'log');
        set(gca, 'yscale', 'log');
        set(gca, 'ylim', [min(y(y>0)) max(y)*1.1]);
        waitforbuttonpress
    end

end

