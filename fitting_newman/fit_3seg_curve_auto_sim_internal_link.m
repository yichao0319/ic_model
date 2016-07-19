function [fit_data, param] = fit_3seg_curve_auto_sim_internal_link(x, y, L, U, N, lambda, eta, DEBUG)
    if nargin < 8, DEBUG = 0; end


    param.L      = L;
    param.U      = U;
    param.f      = (U - L) / N;
    param.lambda = lambda;
    param.eta    = eta;

    idx1 = find(x <= L);
    xseg1 = x(idx1);
    yseg1 = y(idx1);

    idx2 = find(x > L & x <= U);
    xseg2 = x(idx2);
    yseg2 = y(idx2);

    idx3 = find(x > U);
    xseg3 = x(idx3);
    yseg3 = y(idx3);

    inparam1         = [param.L, param.lambda, param.eta, param.f];
    est_yseg1        = close_form_mc_internal_p1(inparam1, xseg1);
    est_yseg1_others = close_form_mc_internal_p1(inparam1, [xseg2; xseg3]);
    % c1               = yseg1(1) / est_yseg1(1);
    % est_yseg1        = c1 * est_yseg1;
    % est_yseg1_others = c1 * close_form_mc_internal_p1(inparam1, [xseg2; xseg3]);

    inparam2         = [param.L, param.lambda, param.eta, param.f];
    est_yseg2        = close_form_mc_internal_p2(inparam2, xseg2);
    est_yseg2_others = close_form_mc_internal_p2(inparam2, [xseg1; xseg3]);
    % c2               = yseg2(1) / est_yseg2(1);
    % est_yseg2        = c2 * est_yseg2;
    % est_yseg2_others = c2 * close_form_mc_internal_p2(inparam2, [xseg1; xseg3]);

    inparam3         = [param.L, param.U, param.lambda, param.eta, param.f];
    est_yseg3        = close_form_mc_internal_p3(inparam3, xseg3);
    est_yseg3_others = close_form_mc_internal_p3(inparam3, [xseg1; xseg2]);
    % c3               = yseg3(1) / est_yseg3(1);
    % est_yseg3        = c3 * est_yseg3;
    % est_yseg3_others = c3 * close_form_mc_internal_p3(inparam3, [xseg1; xseg2]);


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
end



function [fit_data, param] = fit_3phases_sim(x, y, L, U, DEBUG)
    if nargin < 5, DEBUG = 0; end

    %% First find the lower and upper bound
    % [pl_curve, L, U, exponent] = fit_power(x, y, L, U, DEBUG);
    [fit_data_seg2, a, exponent] = fit_power_v3(x, y, L, U, DEBUG);
    param.a = a;
    param.exponent = exponent;

    %% Fit the phase 1
    %%   method 1: by iterative heuristic
    % exponent = -3;
    % fit_phase1(x, y, L, exponent, DEBUG);
    %%   method 2: solve a optimization problem with 2 geometric distribution
    % [p1, p_hat] = fit_phase1_v2(x, y, L, -3, DEBUG);
    [fit_data_seg1, p1, p_hat] = fit_phase1_v3(x, y, L, U, exponent, DEBUG);
    param.p1 = p1;
    param.p_hat = p_hat;


    %% Fit the phase 2 again with the given p from phase 1
    %% p = gamma / (L + gamma)
    % exponent = - (p*L/(1-p));
    % [L, U, a, exponent] = fit_power_v2(x, y, L, U, exponent, DEBUG);

    %% Fit the phase 3 by formula
    % [p3, c] = fit_phase3(x, y, U, exponent, DEBUG);
    [fit_data_seg3] = fit_phase3_v3(x, y, L, U, exponent, DEBUG);


    idx1 = find(x>0 & x<=L);
    idx2 = find(x>=L & x<=U);
    idx3 = find(x>=U);

    xseg1 = x(idx1);
    yseg1 = y(idx1);
    xseg2 = x(idx2);
    yseg2 = y(idx2);
    xseg3 = x(idx3);
    yseg3 = y(idx3);


    fit_data.xseg1 = xseg1;
    fit_data.xseg2 = xseg2;
    fit_data.xseg3 = xseg3;
    fit_data.yseg1 = yseg1;
    fit_data.yseg2 = yseg2;
    fit_data.yseg3 = yseg3;
    fit_data.est_yseg1 = fit_data_seg1.est_yseg1;
    fit_data.est_yseg2 = fit_data_seg2.est_yseg2;
    fit_data.est_yseg3 = fit_data_seg3.est_yseg3;
    fit_data.est_yseg1_others = fit_data_seg1.est_yseg1_others;
    fit_data.est_yseg2_others = fit_data_seg2.est_yseg2_others;
    fit_data.est_yseg3_others = fit_data_seg3.est_yseg3_others;


    if DEBUG
    % if 1
        fh = figure(4); clf;
        lh = plot(x, y, 'bo');
        set(lh, 'MarkerSize', 15);
        hold on;
        lh = plot(fit_data.xseg1, fit_data.est_yseg1, '-g');
        set(lh, 'LineWidth', 2);
        lh = plot(fit_data.xseg2, fit_data.est_yseg2, '-r');
        set(lh, 'LineWidth', 2);
        lh = plot(fit_data.xseg3, fit_data.est_yseg3, '-m');
        set(lh, 'LineWidth', 2);

        lh = plot([fit_data.xseg2; fit_data.xseg3], fit_data.est_yseg1_others, '--g');
        set(lh, 'LineWidth', 2);
        lh = plot([fit_data.xseg1; fit_data.xseg3], fit_data.est_yseg2_others, '--r');
        set(lh, 'LineWidth', 2);
        lh = plot([fit_data.xseg1; fit_data.xseg2], fit_data.est_yseg3_others, '--m');
        set(lh, 'LineWidth', 2);

        set(gca, 'xscale', 'log');
        set(gca, 'yscale', 'log');
        set(gca, 'ylim', [min(y(y>0)) max(y)*1.1]);
        waitforbuttonpress
    end
end



function [fit_data, param] = fit_powerlaw_only(x, y, L, U)
    idx = find(x >=4 & x <= 20);
    ret = lsqcurvefit(@phase2_close_form_log, [1 -2], x(idx), log(y(idx)));
    param.a = ret(1);
    param.exponent = ret(2);

    est_y = phase2_close_form(ret, x);

    fit_data.x = x;
    fit_data.y = y;
    fit_data.est_y = est_y;
end


function [fit_data, param] = fit_phase12_only(x, y, L, U)


    %% phase 2
    idx = find(x > L & x <= 20);
    exponent = -(L+1);
    ret = lsqcurvefit(@phase2_close_form_log, [1 exponent], x(idx), log(y(idx)), [-Inf exponent-1], [Inf exponent]);
    param.a = ret(1);
    param.exponent = ret(2);

    %% phase 2 - seg 2
    idx = find(x >= L & x <= U);
    xseg2 = x(idx);
    yseg2 = y(idx);
    est_yseg2 = param.a*(xseg2.^param.exponent);

    %% phase 2 - seg 1
    idx = find(x>0 & x<=L);
    if length(idx) > 0
        xseg1 = x(idx);
        est_yseg2_others = param.a*(xseg1.^param.exponent);
    end



    %% phase 1 - seg 1
    [fit_data_seg1, p1, p_hat] = fit_phase1_v3(x, y, L, U, param.exponent);
    param.p1 = p1;
    param.p_hat = p_hat;


    fit_data.xseg1 = fit_data_seg1.xseg1;
    fit_data.xseg2 = xseg2;
    fit_data.est_yseg1 = fit_data_seg1.est_yseg1;
    fit_data.est_yseg2 = est_yseg2;
    fit_data.est_yseg1_others = fit_data_seg1.est_yseg1_others;
    fit_data.est_yseg2_others = est_yseg2_others;
end


function [fit_data, param] = fit_exp(x, y)

    %% -------------
    %% fitting and plot
    [fit_curve, param] = fit(x, y, 'exp1');
    %% -------------

    fit_data.est_y = fit_curve(x);
end


function [fit_data, param] = fit_poisson(x, y)

    %% -------------
    %% fitting and plot
    func = @(parm,xx)poisspdf(xx,parm);
    param = lsqcurvefit(func, 1, x, y);
    %% -------------

    fit_data.est_y = poisspdf(x, param);
end
