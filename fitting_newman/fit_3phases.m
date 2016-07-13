%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Yi-Chao Chen @ UT Austin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% function plot_sim_v3_condor_results(N, L, U, nseed)
function fit_3phases()
    % plot_single(100000, 1, 1, 100)
    % plot_single(100000, 1, 100000, 100)
    % plot_single(100000, 2, 8, 100)
    % plot_single(100000, 3, 10, 100)
    % plot_single(100000, 3, 100000, 100)
end

function plot_single(N, L, U, nseed)
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
    % input_dir = './data/';

    fig_dir = './fig/';
    font_size = 26;
    colors   = {'r', 'b', [0 0.8 0], 'm', [1 0.85 0], [0 0 0.47], [0.45 0.17 0.48], 'k'};


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
    if nargin < 4, nseed = 1; end


    %% --------------------
    %% Main starts
    %% --------------------
    if DEBUG2
        fprintf('============================\n');
        fprintf('L=%d, U=%d, N=%d\n', L, U, N);
    end

    %% --------------------
    %% Get Data
    %% --------------------
    if DEBUG2, fprintf('Get Data\n'); end

    % [data, data2] = get_sim_data(L, U, N, nseed, input_dir);
    para.L = L;
    para.U = U;
    para.N = N;
    para.nseed = nseed;
    [data, data2] = get_data('sim', para);
    %% --------------
    %% w/o 0s
    idx = find(data(:,1) > 0);
    data = data(idx,:);
    %% --------------

    if DEBUG3
        fprintf('  data size=%dx%d, min/max degree=%d/%d\n', size(data), min(data(:,1)), max(data(:,1)));
        fprintf('  data2 size=%dx%d, min/max degree=%d/%d\n', size(data2), min(data2(:,1)), max(data2(:,1)));
    end

    fig_idx = fig_idx + 1;
    fh = figure(fig_idx); clf;
    plot(data(:,1), data(:,2), 'bo');
    set(gca, 'xscale', 'log');
    set(gca, 'yscale', 'log');


    %% --------------------
    %% Fitting
    %% --------------------
    if DEBUG2, fprintf('Fitting\n'); end

    x_mins = [1:10];
    [x_min, x_max, Dmins, Dmaxs] = find_mc_min_max(data, x_mins);
    x_maxs = [x_min+1:max(data(:,1))];

    fig_idx = fig_idx + 1;
    fh = figure(fig_idx); clf;
    subplot(1,2,1);
    plot(x_mins, Dmins, '-b*');
    title('D: find x_{min}');

    subplot(1,2,2);
    plot(x_maxs, Dmaxs, '-b*');
    title('D: find x_{min}');


    %% --------------------
    %% Plot Result
    %% --------------------
    if DEBUG2, fprintf('Plot Result\n'); end
    idx_min = find(data(:,1) >= x_min);
    idx_min = idx_min(1);
    idx_max = find(data(:,1) <= x_max);
    idx_max = idx_max(end);

    emp_p = cal_real_prob(data, x_min, x_max);
    [est_p, exponent] = est_pl_prob(data, x_min, x_max);

    p_x = data(:,2) / sum(data(:,2));
    ratio = p_x(1) / emp_p(1);
    est_p = est_p * ratio;
    emp_p = emp_p * ratio;


    %% phase 1 - seg 1
    % idx = find(x_data>0 & x_data<=L);
    % gamma = -exponent;
    % this_p = gamma/(gamma+L);
    % if length(idx) > 0
    %     x_p1_seg1 = x_data(idx);
    %     y_p1_seg1 = ((0.5).^x_p1_seg1)/2;

    %     lh(3) = plot(x_p1_seg1, y_p1_seg1, '-');
    %     set(lh(3), 'Color', colors{3});
    %     set(lh(3), 'LineWidth', 4);
    % end
    % %% phase 1 - seg 2,3
    % idx = find(x_data>=L);
    % if length(idx) > 0
    %     x_p1_seg23 = x_data(idx);
    %     y_p1_seg23 = ((0.5).^x_p1_seg23)/2;

    %     lh2 = plot(x_p1_seg23, y_p1_seg23, '--');
    %     set(lh2, 'Color', colors{3});
    %     set(lh2, 'LineWidth', 2);
    % end


    fig_idx = fig_idx + 1;
    fh = figure(fig_idx); clf;
    plot(data(:,1), emp_p, 'bo');
    hold on;
    plot(data(idx_min:end,1), est_p(idx_min:end), '-r');
    plot(x_min, est_p(idx_min,1), 'go');
    plot(x_max, est_p(idx_max,1), 'go');
    set(gca, 'xscale', 'log');
    set(gca, 'yscale', 'log');


end

