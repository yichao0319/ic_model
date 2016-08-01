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
%%   cal_path_length('topology1')
%%   cal_path_length('L1U100000N30000.internal_link_v4.l1.00.e1.00.cal.topo')
%%   cal_path_length('L3U10N30000.internal_link_v4.l1.00.e1.00.cal.topo')
%%   cal_path_length('L2U8N20000.internal_link_v4.l1.00.e1.00.cal.topo')
%%   cal_path_length('L3U100000N30000.internal_link_v4.l1.00.e1.00.cal.topo')
%%   cal_path_length('L1U1N30000.internal_link_v4.l1.00.e1.00.cal.topo')
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [path_length] = cal_path_length(filename)
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
    input_dir  = '../sim/data/';
    output_dir = './results/';
    fig_dir = './figs/';

    font_size = 28;
    colors   = {'r', 'b', [0 0.8 0], 'm', [1 0.85 0], [0 0 0.47], [0.45 0.17 0.48], 'k'};
    % colors   = {[228 26 28]/255, [55 126 184]/255, [77,175,74]/255, [152,78,163]/255, [255,127,0]/255, [255,255,51]/255, [166,86,40]/255, [247,129,191]/255, [153,153,153]/255};
    lines    = {'-', '--', '-.', ':'};
    markers  = {'+', 'o', '*', '.', 'x', 's', 'd', '^', '>', '<', 'p', 'h'};


    %% --------------------
    %% Variable
    %% --------------------
    fig_idx = 0;


    %% --------------------
    %% Check input
    %% --------------------
    % if nargin < 1, arg = 1; end


    %% --------------------
    %% Main starts
    %% --------------------
    topology = load(sprintf('%s%s.txt', input_dir, filename));
    topology(topology>0) = 1;
    N = size(topology, 1);
    paths = graphallshortestpaths(sparse(topology));

    for ni = 1:N
        if length(find(paths(ni,:)==0)) > 1,
            error('exist unlinked node');
        end

        pls = paths(ni, setxor(1:N,ni));
        avg_pl(ni) = mean(pls);
        max_pl(ni) = max(pls);
        min_pl(ni) = min(pls);
    end

    [f{1}, x{1}] = ecdf(avg_pl);
    [f{2}, x{2}] = ecdf(max_pl);
    % [f{3}, x{3}] = ecdf(min_pl);

    fig_idx = fig_idx + 1;
    fh = figure(fig_idx); clf;
    for lc = 1:length(f)
        lh = plot(x{lc}, f{lc}); hold on;
        set(lh, 'Color', colors{lc});
        set(lh, 'LineStyle', char(lines{lc}));
        set(lh, 'LineWidth', 4);
        set(lh, 'marker', markers{lc});
        set(lh, 'MarkerSize', 10);
    end
    set(gca, 'FontSize', font_size);
    xlabel('path length', 'FontSize', font_size)
    ylabel('CDF', 'FontSize', font_size)
    legend({'avg', 'max'}, 'Location', 'SouthEast');
    title('Path Length');
    % print(fh, '-dpsc', 'name.ps');
    print(fh, '-dpng', sprintf('%s%s.png', fig_dir, filename));
    dlmwrite(sprintf('%s%s.cdf.avg.txt', output_dir, filename), [x{1} f{1}], 'delimiter', '\t');
    dlmwrite(sprintf('%s%s.cdf.max.txt', output_dir, filename), [x{2} f{2}], 'delimiter', '\t');

end
