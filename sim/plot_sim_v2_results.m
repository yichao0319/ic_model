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
%%  plot_sim_v2_results(10000, 1, 1)
%%  plot_sim_v2_results(10000, 2, 8)
%%  plot_sim_v2_results(10000, 1, 5)
%%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plot_sim_v2_results(N, L, U)
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
    data = load([input_dir filename '.txt']);
    tmp = load([input_dir filename '.fit.txt']);
    a = tmp(1);
    exponent = tmp(2);


    %% --------------------
    %% Plot
    %% --------------------
    fig_idx = fig_idx + 1;
    fh = figure(fig_idx); clf;

    norm_scale = sum(data(:,2));
    x_data = data(:,1);
    y_data = data(:,2)/norm_scale;
    lh = plot(x_data, y_data, 'bo');
    set(lh, 'MarkerSize', 10);
    hold on;
    if a ~= 0
        % % x_pl = [L,U];
        % x_pl = [min(x_data(x_data>0)) max(x_data)];
        % x_pl
        % y_pl = a/norm_scale*(x_pl.^exponent);
        % lh = plot(x_pl, y_pl, '-r');
        % set(lh, 'LineWidth', 2);

        %% seg1
        idx = find(x_data>0 & x_data<=L);
        if length(idx) > 0
            x_pl_seg1 = x_data(idx);
            y_pl_seg1 = a/norm_scale*(x_pl_seg1.^exponent);
            lh = plot(x_pl_seg1, y_pl_seg1, '--r');
            set(lh, 'LineWidth', 2);
        end

        %% seg2
        idx = find(x_data>=L & x_data<=U);
        if length(idx) > 0
            x_pl_seg2 = x_data(idx);
            y_pl_seg2 = a/norm_scale*(x_pl_seg2.^exponent);
            lh = plot(x_pl_seg2, y_pl_seg2, '-r');
            set(lh, 'LineWidth', 2);
        end

        %% seg3
        idx = find(x_data>=U);
        if length(idx) > 0
            x_pl_seg3 = x_data(idx);
            y_pl_seg3 = a/norm_scale*(x_pl_seg3.^exponent);
            lh = plot(x_pl_seg3, y_pl_seg3, '--r');
            set(lh, 'LineWidth', 2);
        end
    end

    set(gca, 'XLim', [min(x_data(x_data>0)) max(x_data)]);
    set(gca, 'YLim', [min(y_data) max(y_data)*1.1]);

    set(gca, 'FontSize', font_size);
    title(sprintf('L=%d,U=%d,exponent=%.2f', L, U, exponent));
    xlabel('Node Degree', 'FontSize', font_size);
    ylabel('Probability', 'FontSize', font_size);

    set(gca, 'xscale', 'log');
    set(gca, 'yscale', 'log');
    set(gca, 'XTick', [1 2 3 4 5 6 8 10 20 40]);
    set(gca, 'YTick', 10.^[-20:0]);
    xtics = get(gca,'XTick');
    set(gca,'XTickLabel',sprintf('%d|',xtics));

    legend('data', 'power-low');

    print(fh, '-dpsc', sprintf('%sL%dU%dN%d.eps', fig_dir, L, U, N));
end