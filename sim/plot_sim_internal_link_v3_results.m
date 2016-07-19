%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Yi-Chao Chen @ UT Austin
%%
%% - Input:
%%
%%
%% - Output:
%%
%%
%% example:
%%  plot_sim_internal_link_v3_results([2000:2000:4000,10000:10000:30000], 2, 8, 1, 'cal')
%%  plot_sim_internal_link_v3_results([2000:2000:4000,10000:10000:30000], 3, 10, 1, 'cal')
%%  plot_sim_internal_link_v3_results([2000:2000:4000,10000:10000:30000], 1, 1, 1, 'cal')
%%  plot_sim_internal_link_v3_results([2000:2000:4000,10000:10000:30000], 1, 100000, 1, 'cal')
%%  plot_sim_internal_link_v3_results([2000:2000:4000,10000:10000:30000], 3, 100000, 1, 'cal')
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plot_sim_internal_link_results(Ns, L, U, itvl, sel_type)
    for ni = 1:length(Ns)
        N = Ns(ni);
        plot_sim_internal_link_one_result(N, L, U, itvl, sel_type);
        % pause
    end
end

function plot_sim_internal_link_one_result(N, L, U, itvl, sel_type)
    % addpath('../utils');

    %% --------------------
    %% DEBUG
    %% --------------------
    DEBUG0 = 0;
    DEBUG1 = 1;
    DEBUG2 = 1;  %% progress
    DEBUG3 = 1;  %% verbose
    DEBUG4 = 1;  %% results


    %% --------------------
    %% Constant
    %% --------------------
    input_dir = './data/';
    fig_dir = './fig/';
    font_size = 18;


    %% --------------------
    %% Variable
    %% --------------------
    fig_idx = 0;


    %% --------------------
    %% Check input
    %% --------------------
    if nargin < 1, N = 100000; end
    if N <= 0, N = 100000; end
    if nargin < 2, L = 1; end
    if nargin < 3, U = N; end

    filename = sprintf('L%dU%dN%d', L, U, N);


    %% --------------------
    %% Main starts
    %% --------------------

    data = load(sprintf('%s%s.internal_link_v3.itvl%d.%s.txt', input_dir, filename, itvl, sel_type));

    % idx = find(data(:,1) > 0);
    % data = data(idx, :);
    % a = tmp(1);
    % exponent = tmp(2);


    %% --------------------
    %% Plot
    %% --------------------
    fig_param.font_size = font_size;
    fig_param.fig_dir   = fig_dir;
    fig_param.itvl      = itvl;
    fig_param.sel_type  = sel_type;

    if L~=U
        if L == 1 & U == N
            plot_powerlaw_only(data, L, U, N, fig_param);
        elseif L > 1 & U == N
            plot_phase12_only(data, L, U, N, fig_param);
        else
            plot_powerlaw(data, L, U, N, fig_param);
        end
    else
        plot_exp(data, L, U, N, fig_param);
        % plot_lognormal(data, L, U, N, fig_param);


        data2 = load(sprintf('%sL%dU%dN%d.internal_link_v2.itvl%d.poisson.txt', input_dir, L, U, N, itvl));
        plot_poisson(data2, L, U, N, fig_param);
    end

end


function plot_powerlaw(data, L, U, N, fig_param)
    font_size = fig_param.font_size;
    fig_dir   = fig_param.fig_dir;
    itvl      = fig_param.itvl;
    sel_type  = fig_param.sel_type;

    fh = figure(1); clf;

    %% Data
    norm_scale = sum(data(:,2));
    x_data = data(:,1);
    y_data = data(:,2)/norm_scale/2;
    lh(1) = plot(x_data, y_data, 'bo');
    set(lh(1), 'MarkerSize', 15);
    set(lh(1), 'LineWidth', 2);
    hold on;

    % lh(2) = plot(-1,-1, 'w.');
    % set(lh(2), 'MarkerSize', 1);


    % %% phase 2
    % idx = find(x_data > L & x_data <= U);
    % exponent = -(L+1);
    % parm = lsqcurvefit(@phase2_close_form_log, [1 exponent], x_data(idx), log(y_data(idx)), [-Inf exponent-1], [Inf exponent]);
    % a = parm(1);
    % exponent = parm(2);

    % %% phase 2 - seg 2
    % x_pl_seg2 = x_data(idx);
    % y_pl_seg2 = a*(x_pl_seg2.^exponent);
    % lh(4) = plot(x_pl_seg2, y_pl_seg2, '-r');
    % set(lh(4), 'LineWidth', 2);

    % %% phase 2 - seg 1
    % idx = find(x_data>0 & x_data<=L+1);
    % if length(idx) > 0
    %     x_pl_seg1 = x_data(idx);
    %     y_pl_seg1 = a*(x_pl_seg1.^exponent);
    %     lh2 = plot(x_pl_seg1, y_pl_seg1, '--r');
    %     set(lh2, 'LineWidth', 2);
    % end

    % %% phase 2 - seg 3
    % idx = find(x_data>=U);
    % if length(idx) > 0
    %     x_pl_seg3 = x_data(idx);
    %     y_pl_seg3 = a*(x_pl_seg3.^exponent);
    %     lh2 = plot(x_pl_seg3, y_pl_seg3, '--r');
    %     set(lh2, 'LineWidth', 2);
    % end


    % %% phase 1 - seg 1
    % idx = find(x_data>0 & x_data<=L);
    % gamma = -exponent;
    % this_p = gamma/(gamma+L);
    % if length(idx) > 0
    %     x_p1_seg1 = x_data(idx);
    %     y_p1_seg1 = ((0.5).^x_p1_seg1)/2;

    %     lh(3) = plot(x_p1_seg1, y_p1_seg1, '-g');
    %     set(lh(3), 'LineWidth', 2);
    % end
    % %% phase 1 - seg 2,3
    % idx = find(x_data>=L);
    % if length(idx) > 0
    %     x_p1_seg23 = x_data(idx);
    %     y_p1_seg23 = ((0.5).^x_p1_seg23)/2;

    %     lh2 = plot(x_p1_seg23, y_p1_seg23, '--g');
    %     set(lh2, 'LineWidth', 2);
    % end


    % %% phase 3 - seg 3
    % idx = find(x_data>=U);
    % alpha = 1;
    % if length(idx) > 0
    %     x_p3_seg3 = x_data(idx);
    %     y_p3_seg3 = geom_phase3(x_p3_seg3, L, U, gamma);
    %     % y_p3_seg3_v2 = geom_phase3_v2(x_p3_seg3, L, U);
    %     % y_p3_seg3 = (y_p3_seg3 + y_p3_seg3_v2) / 2;
    %     % y_p3_seg3 = y_p3_seg3_v2;

    %     % norm_idx = round((idx(1) + idx(end))*3/5);
    %     norm_idx = idx(1);
    %     alpha = y_data(norm_idx) / y_p3_seg3(norm_idx-idx(1)+1);

    %     lh(5) = plot(x_p3_seg3, alpha*y_p3_seg3, '-m');
    %     set(lh(5), 'LineWidth', 2);
    % end
    % %% phase 3 - seg 1,2
    % idx = find(x_data<=U);
    % if length(idx) > 0
    %     x_p3_seg12 = x_data(idx);
    %     y_p3_seg12 = geom_phase3(x_p3_seg12, L, U, gamma);
    %     % y_p3_seg12 = geom_phase3(x_p3_seg12, L, U, gamma);

    %     lh2 = plot(x_p3_seg12, alpha*y_p3_seg12, '--m');
    %     set(lh2, 'LineWidth', 2);
    % end


    set(gca, 'XLim', [min(x_data(x_data>0)) max(x_data)]);
    set(gca, 'YLim', [min(y_data(y_data>0)) max(y_data)*1.1]);

    set(gca, 'FontSize', font_size);
    title(sprintf('L=%d,U=%d', L, U));
    % title(sprintf('L=%d,U=%d,exponent=%.2f', L, U, exponent));
    xlabel('Node Degree', 'FontSize', font_size);
    ylabel('Probability', 'FontSize', font_size);

    set(gca, 'xscale', 'log');
    set(gca, 'yscale', 'log');
    set(gca, 'XTick', [1 2 3 4 6 10 20 40 100 200 400]);
    set(gca, 'YTick', 10.^[-20:0]);
    % % xtics = get(gca,'XTick');
    % % set(gca,'XTickLabel',sprintf('%d|',xtics));

    % % h = legend(lh, {'Empirical Data', 'MC:', 'Geom($\frac{\gamma}{\gamma+L}$)', 'Power-Low', 'Geom($\frac{\gamma}{\gamma+U}$)'}, 'location', 'southwest');
    h = legend(lh, {'Empirical Data', 'MC:', 'Geom($\frac{\gamma}{\gamma+L}$)', 'Power-Low', 'Geom($\frac{\gamma}{\gamma+U}$)'});
    % set(h, 'Interpreter', 'latex');
    % leg_pos = get(h, 'position');
    % set(h, 'position',[leg_pos(1)*0.95,leg_pos(2),...
    %                   leg_pos(3)*1.1,leg_pos(4)]);

    print(fh, '-dpsc', sprintf('%sL%dU%dN%d-itvl%d-%s-internal_link_v3-pl.eps', fig_dir, L, U, N, itvl, sel_type));
end


function plot_phase12_only(data, L, U, N, fig_param)
    font_size = fig_param.font_size;
    fig_dir   = fig_param.fig_dir;
    itvl      = fig_param.itvl;
    sel_type  = fig_param.sel_type;

    fh = figure(1); clf;

    %% Data
    norm_scale = sum(data(:,2));
    x_data = data(:,1);
    y_data = data(:,2)/norm_scale/2;
    lh(1) = plot(x_data, y_data, 'bo');
    set(lh(1), 'MarkerSize', 15);
    set(lh(1), 'LineWidth', 2);
    hold on;

    % lh(2) = plot(-1,-1, 'w.');
    % set(lh(2), 'MarkerSize', 1);


    % %% phase 2
    % idx = find(x_data > L & x_data <= 20);
    % % [fit_curve, gof] = fit(x_data(idx), y_data(idx), 'power1');
    % exponent = -(L+1);
    % parm = lsqcurvefit(@phase2_close_form_log, [1 exponent], x_data(idx), log(y_data(idx)), [-Inf exponent-1], [Inf exponent]);
    % a = parm(1);
    % exponent = parm(2);
    % % lh(2) = plot(x_data(idx), phase2_close_form(parm, x_data(idx)), '-r');
    % % set(lh, 'LineWidth', 2);

    % % values = coeffvalues(fit_curve);
    % % a = values(1);
    % % exponent = values(2);
    % % exponent = -(L+1);

    % %% phase 2 - seg 2
    % idx = find(x_data > L & x_data <= U);
    % x_pl_seg2 = x_data(idx);
    % y_pl_seg2 = a*(x_pl_seg2.^exponent);
    % lh(4) = plot(x_pl_seg2, y_pl_seg2, '-r');
    % set(lh(4), 'LineWidth', 2);

    % %% phase 2 - seg 1
    % idx = find(x_data>0 & x_data<=L+1);
    % if length(idx) > 0
    %     x_pl_seg1 = x_data(idx);
    %     y_pl_seg1 = a*(x_pl_seg1.^exponent);
    %     lh2 = plot(x_pl_seg1, y_pl_seg1, '--r');
    %     set(lh2, 'LineWidth', 2);
    % end



    % %% phase 1 - seg 1
    % idx = find(x_data>0 & x_data<=L);
    % gamma = -exponent;
    % this_p = gamma/(gamma+L);
    % if length(idx) > 0
    %     x_p1_seg1 = x_data(idx);
    %     y_p1_seg1 = ((0.5).^x_p1_seg1)/2;

    %     lh(3) = plot(x_p1_seg1, y_p1_seg1, '-g');
    %     set(lh(3), 'LineWidth', 2);
    % end
    % %% phase 1 - seg 2,3
    % idx = find(x_data>=L);
    % if length(idx) > 0
    %     x_p1_seg23 = x_data(idx);
    %     y_p1_seg23 = ((0.5).^x_p1_seg23)/2;

    %     lh2 = plot(x_p1_seg23, y_p1_seg23, '--g');
    %     set(lh2, 'LineWidth', 2);
    % end


    set(gca, 'XLim', [min(x_data(x_data>0)) max(x_data)]);
    set(gca, 'YLim', [min(y_data(y_data>0)) max(y_data)*1.1]);

    set(gca, 'FontSize', font_size);
    title(sprintf('L=%d,U=%d', L, U));
    % title(sprintf('L=%d,U=%d,exponent=%.2f', L, U, exponent));
    xlabel('Node Degree', 'FontSize', font_size);
    ylabel('Probability', 'FontSize', font_size);

    set(gca, 'xscale', 'log');
    set(gca, 'yscale', 'log');
    set(gca, 'XTick', [1 2 3 4 5 6 8 10 20 40 100 200 400]);
    set(gca, 'YTick', 10.^[-20:0]);
    % % xtics = get(gca,'XTick');
    % % set(gca,'XTickLabel',sprintf('%d|',xtics));

    h = legend(lh, {'Empirical Data', 'MC:', 'Geom($\frac{\gamma}{\gamma+L}$)', 'Power-Low'}, 'location', 'southwest');
    % set(h, 'Interpreter', 'latex');
    % leg_pos = get(h, 'position');
    % set(h, 'position',[leg_pos(1)*0.95,leg_pos(2),...
    %                   leg_pos(3)*1.1,leg_pos(4)]);

    print(fh, '-dpsc', sprintf('%sL%dU%dN%d-itvl%d-%s-internal_link_v3-pl.eps', fig_dir, L, U, N, itvl, sel_type));
end


function plot_powerlaw_only(data, L, U, N, fig_param)
    font_size = fig_param.font_size;
    fig_dir   = fig_param.fig_dir;
    itvl      = fig_param.itvl;
    sel_type  = fig_param.sel_type;

    fh = figure(2); clf;

    %% --------------
    %% w/o 0s
    idx = find(data(:,1) > 0);
    data = data(idx,:);
    %% --------------

    norm_scale = sum(data(:,2));
    x_data = data(:,1);
    y_data = data(:,2)/norm_scale;
    lh = plot(x_data, y_data, 'bo');
    set(lh, 'MarkerSize', 15);
    set(lh, 'LineWidth', 2);
    hold on;


    %% -------------
    %% fitting and plot
    idx = find(x_data >=4 & x_data <= 20);
    [fit_curve, gof] = fit(x_data(idx), y_data(idx), 'power1');

    values = coeffvalues(fit_curve);
    exponent = values(2);

    lh = plot(x_data, fit_curve(x_data), '-r');
    set(lh, 'LineWidth', 2);
    %% -------------


    set(gca, 'XLim', [min(x_data(x_data>0)) max(x_data)]);
    set(gca, 'YLim', [min(y_data(y_data>0)) max(y_data)*1.1]);

    set(gca, 'FontSize', font_size);
    title(sprintf('L=%d,U=%d,exponent=%.2f', L, U, exponent));
    xlabel('Node Degree', 'FontSize', font_size);
    ylabel('Probability', 'FontSize', font_size);

    set(gca, 'xscale', 'log');
    set(gca, 'yscale', 'log');
    set(gca, 'XTick', [1 2 3 4 5 6 8 10 20 40 100 200 400]);
    set(gca, 'YTick', 10.^[-20:0]);
    % xtics = get(gca,'XTick');
    % set(gca,'XTickLabel',sprintf('%d|',xtics));

    legend('Empirical Data', 'Power-Low');

    print(fh, '-dpsc', sprintf('%sL%dU%dN%d-itvl%d-%s-internal_link_v3-pl.eps', fig_dir, L, U, N, itvl, sel_type));
end


function plot_exp(data, L, U, N, fig_param)
    font_size = fig_param.font_size;
    fig_dir   = fig_param.fig_dir;
    itvl      = fig_param.itvl;
    sel_type  = fig_param.sel_type;

    fh = figure(2); clf;

    %% --------------
    %% w/o 0s
    idx = find(data(:,1) > 0);
    data = data(idx,:);
    %% --------------

    norm_scale = sum(data(:,2));
    x_data = data(:,1);
    y_data = data(:,2)/norm_scale;
    lh = plot(x_data, y_data, 'bo');
    set(lh, 'MarkerSize', 15);
    set(lh, 'LineWidth', 2);
    hold on;


    %% -------------
    %% fitting and plot
    % [fit_curve, gof] = fit(x_data, y_data, 'exp1');
    % lh = plot(x_data, fit_curve(x_data), '-r');
    % set(lh, 'LineWidth', 2);
    %% -------------


    set(gca, 'XLim', [min(x_data) max(x_data)]);
    set(gca, 'YLim', [min(y_data) max(y_data)*1.1]);

    set(gca, 'FontSize', font_size);
    title(sprintf('L=%d,U=%d', L, U));
    xlabel('Node Degree', 'FontSize', font_size);
    ylabel('Probability', 'FontSize', font_size);

    set(gca, 'xscale', 'log');
    set(gca, 'yscale', 'log');
    set(gca, 'XTick', [1 2 3 4 5 6 8 10 20 40]);
    set(gca, 'YTick', 10.^[-20:0]);
    % xtics = get(gca,'XTick');
    % set(gca,'XTickLabel',sprintf('%d|',xtics));

    legend('Empirical Data', 'Exponential');

    print(fh, '-dpsc', sprintf('%sL%dU%dN%d-itvl%d-%s-internal_link_v3-exp.eps', fig_dir, L, U, N, itvl, sel_type));
end


function plot_poisson(data, L, U, N, fig_param)
    font_size = fig_param.font_size;
    fig_dir   = fig_param.fig_dir;
    itvl      = fig_param.itvl;
    sel_type  = fig_param.sel_type;

    fh = figure(3); clf;

    %% --------------
    %% w/ 0s
    % idx = find(data(:,1) > 0);
    % data = data(idx,:);
    %% --------------

    norm_scale = sum(data(:,2));
    x_data = data(:,1);
    y_data = data(:,2)/norm_scale;
    lh = plot(x_data, y_data, 'bo');
    set(lh, 'MarkerSize', 15);
    set(lh, 'LineWidth', 2);
    hold on;


    %% -------------
    %% fitting and plot
    func = @(parm,x)poisspdf(x,parm);
    parm = lsqcurvefit(func, 1, x_data, y_data);
    lh = plot(x_data, poisspdf(x_data, parm), '-r');
    set(lh, 'LineWidth', 2);
    %% -------------


    set(gca, 'XLim', [min(x_data) max(x_data)]);
    set(gca, 'YLim', [min(y_data) max(y_data)*1.1]);

    set(gca, 'FontSize', font_size);
    title(sprintf('L=%d,U=%d', L, U));
    xlabel('Node Degree', 'FontSize', font_size);
    ylabel('Probability', 'FontSize', font_size);

    % set(gca, 'xscale', 'log');
    % set(gca, 'yscale', 'log');
    % set(gca, 'XTick', [1 2 3 4 5 6 8 10 20 40]);
    % set(gca, 'YTick', 10.^[-20:0]);
    % xtics = get(gca,'XTick');
    % set(gca,'XTickLabel',sprintf('%d|',xtics));

    legend('Empirical Data', 'Poisson');

    print(fh, '-dpsc', sprintf('%sL%dU%dN%d-itvl%d-internal_link_v2-poisson.eps', fig_dir, L, U, N, itvl));
end


function [prob] = geom_phase3(k, L, U, gamma)
    term1 = gamma/(gamma+U);
    term2 = ((U/(gamma+U)).^(k-U-1));
    term3 = U/L;
    term41 = factorial(U-1) / factorial(L-1);
    term42 = factorial(U+L) / factorial(L+L);
    term5 = (L/(gamma+L))^L;
    prob = term1 * term2 * term3 * term41/term42 * term5;
end

function y = phase2_close_form(param, x)
    a = param(1);
    exponent = param(2);

    y = a * (x.^(exponent));
end

function y = phase2_close_form_log(param, x)
    y = log(phase2_close_form(param, x));
end
