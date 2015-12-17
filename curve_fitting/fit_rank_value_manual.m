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
%%  fit_rank_value_manual('../../data/citation/processed/', 'publications.num_cite_all_papers');
%%  fit_rank_value_manual('../../data/citation/processed/', 'publications.num_coauthor_all_authors');

%%  fit_rank_value_manual('../../data/rome_taxi/processed/', 'range100.contact_dur');
%%  fit_rank_value_manual('../../data/rome_taxi/processed/', 'range200.contact_dur');
%%  fit_rank_value_manual('../../data/shanghai_bus/processed/', 'range100.contact_dur');
%%  fit_rank_value_manual('../../data/shanghai_bus/processed/', 'range200.contact_dur');
%%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [rmse_our, rmse_pl, p, exponent, slope] = fit_rank_value_manual(input_dir, filename, L, U)
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
    fig_dir = './fig/';
    font_size = 18;


    %% --------------------
    %% Variable
    %% --------------------
    fig_idx = 0;
    

    %% --------------------
    %% Check input
    %% --------------------
    if nargin < 1, input_dir = '../../data/citation/processed/'; end
    if nargin < 2, filename = 'citation.cnt'; end
    if nargin < 3, [L, U] = get_properties(filename, input_dir); end


    %% --------------------
    %% Main starts
    %% --------------------
    
    %% --------------------
    %% Read data
    %% --------------------
    if DEBUG2, fprintf('Read Data\n'); end

    data = load([input_dir filename '.txt']);
    fprintf('  size = %dx%d\n', size(data));
    fprintf('  L = %f, U = %f\n', L, U);

    % rank_cnt = sort(unique(data), 'descend');
    rank_cnt = sort((data), 'descend');


    %% --------------------
    %% Plot
    %% --------------------
    % fig_idx = fig_idx + 1;
    % fh = figure(fig_idx); clf;

    % plot(rank_cnt, '-b.');
    
    % set(gca, 'XScale', 'log');
    % set(gca, 'YScale', 'log');
    
    % set(gca, 'FontSize', font_size);
    % title([filename ', size=' num2str(length(data))], 'Interpreter', 'none');
    % xlabel('Rank', 'FontSize', font_size)
    % ylabel('Count', 'FontSize', font_size);


    %% --------------------
    %% Curve Fitting -- original
    %% --------------------
    if DEBUG2, fprintf('Curve Fitting\n'); end

    % y = rank_cnt;
    y = rank_cnt / sum(rank_cnt);
    x = [1:length(y)]';
    fig_idx = fig_idx + 1;
    [fit_curve, ok, xseg, yseg, rmse] = fit_3seg_curve(x, y, L, U);
    atitle = [filename ', size=' num2str(length(data))];
    plot_3seg_curve(x, y, L, U, fit_curve, ok, xseg, yseg, fig_idx, atitle, font_size, filename, input_dir, fig_dir, 'fit_rank');


    %% --------------------
    %% Fitting Error using Powere Law
    %% --------------------
    if DEBUG2, fprintf('Fitting Error using Powere Law\n'); end

    pl_error_mid = sqrt(mean((yseg{2} - fit_curve{2}(xseg{2})) .^ 2));
    pl_error_all = sqrt(mean((y - fit_curve{2}(x)) .^ 2));
    fprintf('  Power Law Error in middle = %f\n', pl_error_mid);
    fprintf('  Power Law Error of all    = %f\n', pl_error_all);
    fprintf('  Error with 3 phases       = %f\n', rmse);


    %% --------------------
    %% Output
    %% --------------------
    rmse_our = rmse;
    rmse_pl = pl_error_all;
    if ok(1)
        p = fit_curve{1}.p;
    else
        p = 0;
    end
    if ok(2)
        exponent = fit_curve{2}.n;
    else
        exponent = 0;
    end
    slope = (y(1)-y(2))/(x(2)-x(1));
end


% %% fit_3seg_curve
% function [fit_curve, ok, xseg, yseg, rmse] = fit_3seg_curve(x, y, L, U)
%     ok = [0, 0, 0];

%     idx = find(x <= L);
%     rmse = 0;
%     len = 0;
%     if length(idx) > 5
%         ok(1) = 1;
%         xseg{1} = x(idx);
%         yseg{1} = y(idx);

%         [fit_curve{1}, gof{1}] = fit(xseg{1}, yseg{1}, 'exp1', 'Robust', 'Bisquare');
%         fprintf('  Error1:\n');
%         fit_curve{1}
%         gof{1}
%         rmse = rmse + (gof{1}.rmse ^ 2) * length(xseg{1});
%         len = len + length(xseg{1});
%     end

%     idx = find(x > L & x <= U);
%     if length(idx) > 5
%         ok(2) = 1;
%         xseg{2} = x(idx);
%         yseg{2} = y(idx);

%         [fit_curve{2}, gof{2}] = fit(xseg{2}, yseg{2}, 'power1');
%         fprintf('  Error2:\n');
%         fit_curve{2}
%         gof{2}
%         rmse = rmse + (gof{2}.rmse ^ 2) * length(xseg{2});
%         len = len + length(xseg{2});
%     end

%     idx = find(x > U);
%     if length(idx) > 5
%         ok(3) = 1;
%         xseg{3} = x(idx);
%         yseg{3} = y(idx);

%         xx = xseg{3};
%         yy = smoothn(yseg{3}, 10000);
%         % [fit_curve{3}, gof{3}] = fit(xseg{3}, yseg{3}, 'exp2');
%         [fit_curve{3}, gof{3}] = fit(xx, yy, 'exp1');
%         fprintf('  Error3:\n');
%         fit_curve{3}
%         gof{3}
%         rmse = rmse + (gof{3}.rmse ^ 2) * length(xseg{3});
%         len = len + length(xseg{3});
%     end

%     rmse = sqrt(rmse / len);
%     fprintf('  Avg RMSE = %f\n', rmse);
% end


%% plot_3seg_curve
% function plot_3seg_curve(x, y, L, U, fit_curve, ok, xseg, yseg, fig_idx, atitle, font_size, filename, input_dir, fig_dir, prefix)

%     figname = get_figname(filename, input_dir, fig_dir, prefix);
%     [x_ticks, y_ticks, x_label, y_label] = get_plot_param(filename, input_dir);
%     maxx = max(x) * 1.1;
%     minx = min(x) * 0.9;
%     maxy = max(y) * 1.1;
%     miny = min(y(y>0)) * 0.9;
    

%     fh = figure(fig_idx); clf;

%     lh = plot(x, y, 'bo');
%     % set(lh, 'LineWidth', 5);
%     set(lh, 'MarkerSize', 10);
%     legends = {'empirical data'};
%     lhs = [lh];
%     hold on;

%     if ok(1)
%         % lh = plot(xseg{1}, yseg{1}, '-g');
%         % lh = plot(fit_curve{1});
%         lh = plot(xseg{1}, fit_curve{1}(xseg{1}));
%         set(lh, 'Color', [0 0.8 0]);
%         set(lh, 'LineStyle', '-');
%         set(lh, 'LineWidth', 2);
%         legends{end+1} = 'phase1';
%         lhs(end+1) = lh;
%         hold on;

%         others = [];
%         if ok(2), others = [others; xseg{2}]; end
%         if ok(3), others = [others; xseg{3}]; end
%         lh = plot(others, fit_curve{1}(others));
%         set(lh, 'Color', [0 0.8 0]);
%         set(lh, 'LineStyle', '--');
%         set(lh, 'LineWidth', 1);
%     end

%     if ok(2)
%         % lh = plot(fit_curve{2}, '-r');
%         lh = plot(xseg{2}, fit_curve{2}(xseg{2}));
%         set(lh, 'Color', 'r');
%         set(lh, 'LineStyle', '-');
%         set(lh, 'LineWidth', 4);
%         legends{end+1} = 'phase2';
%         lhs(end+1) = lh;
%         hold on;

%         others = [];
%         if ok(1), others = [others; xseg{1}]; end
%         if ok(3), others = [others; xseg{3}]; end
%         lh = plot(others, fit_curve{2}(others));
%         set(lh, 'Color', 'r');
%         set(lh, 'LineStyle', '--');
%         set(lh, 'LineWidth', 1);
%     end

%     if ok(3)
%         % lh = plot(fit_curve{3}, '-m');
%         lh = plot(xseg{3}, fit_curve{3}(xseg{3}));
%         set(lh, 'Color', 'm');
%         set(lh, 'LineStyle', '-');
%         set(lh, 'LineWidth', 6);
%         legends{end+1} = 'phase3';
%         lhs(end+1) = lh;
%         hold on;

%         others = [];
%         if ok(1), others = [others; xseg{1}]; end
%         if ok(2), others = [others; xseg{2}]; end
%         lh = plot(others, fit_curve{3}(others));
%         set(lh, 'Color', 'm');
%         set(lh, 'LineStyle', '--');
%         set(lh, 'LineWidth', 1);
%     end

%     % plot([L L], [miny maxy], '--k');
%     % plot([U U], [miny maxy], '--k');
%     % ylu = interp1(x,y, [L,U]);
%     % lh = plot([L U], ylu, 'ro');
%     % set(lh, 'MarkerSize', 15);

%     set(gca, 'XScale', 'log');
%     set(gca, 'YScale', 'log');
%     set(gca, 'XLim', [minx maxx]);
%     set(gca, 'YLim', [miny maxy]);
%     if length(x_ticks)>0, set(gca, 'XTick', x_ticks); end
%     if length(y_ticks)>0, set(gca, 'YTick', y_ticks); end

%     set(gca, 'FontSize', font_size);
%     % title(atitle, 'Interpreter', 'none');
%     legend(lhs, legends);
%     % xlabel('Rank', 'FontSize', font_size);
%     % ylabel('Count', 'FontSize', font_size);
%     % xlabel('Rank n', 'FontSize', font_size);
%     % ylabel('#Citations', 'FontSize', font_size);
%     % xlabel('Rank n', 'FontSize', font_size);
%     % ylabel('#Coauthors', 'FontSize', font_size);
%     xlabel(x_label, 'FontSize', font_size);
%     ylabel(y_label, 'FontSize', font_size);
    
%     print(fh, '-dpsc', [figname '.eps']);
%     print(fh, '-dpng', [figname '.png']);

% end



%% get_properties
function [L, U] = get_properties(filename, input_dir)
    if nargin < 2, input_dir = './'; end

    L = 0;
    U = Inf;
    % minx = -Inf;
    % maxx = Inf;
    % miny = -Inf;
    % maxy = Inf;

    if strcmp(filename, 'publications.num_cite_all_papers')
        L = 50;
        U = 10000;
    elseif strcmp(filename, 'publications.num_coauthor_all_authors')
        L = 50;
        U = 10000;
    elseif strcmp(filename, 'range100.contact_dur') & length(findstr(input_dir, 'rome_taxi'))>0
        L = 10;
        U = 1000;
    elseif strcmp(filename, 'range200.contact_dur') & length(findstr(input_dir, 'rome_taxi'))>0
        L = 20;
        U = 5000;
    elseif strcmp(filename, 'range100.contact_car') & length(findstr(input_dir, 'rome_taxi'))>0
        L = 9;
        U = 105;
    elseif strcmp(filename, 'range200.contact_car') & length(findstr(input_dir, 'rome_taxi'))>0
        L = 9;
        U = 100;
    elseif strcmp(filename, 'range100.contact_dur') & length(findstr(input_dir, 'shanghai_bus'))>0
        L = 500;
        U = 80000;
    elseif strcmp(filename, 'range200.contact_dur') & length(findstr(input_dir, 'shanghai_bus'))>0
        L = 700;
        U = 80000;
    elseif strcmp(filename, 'range100.contact_car') & length(findstr(input_dir, 'shanghai_bus'))>0
        L = 9;
        U = 100;
    elseif strcmp(filename, 'range200.contact_car') & length(findstr(input_dir, 'shanghai_bus'))>0
        L = 6;
        U = 100;
    end
end


% function figname = get_figname(filename, input_dir, fig_dir, prefix)
%     if findstr(input_dir, 'rome_taxi')
%         figname = [fig_dir prefix '.rome_taxi.' filename];
%     elseif findstr(input_dir, 'shanghai_bus')
%         figname = [fig_dir prefix '.shanghai_bus.' filename];
%     elseif findstr(input_dir, 'shanghai_taxi')
%         figname = [fig_dir prefix '.shanghai_taxi.' filename];
%     else
%         figname = [fig_dir prefix '.' filename];
%     end
% end

%% get_plot_param
function [x_ticks, y_ticks, x_label, y_label] = get_plot_param(filename, input_dir)
    if nargin < 2, input_dir = './'; end

    x_ticks = [];
    y_ticks = [];
    x_label = 'Rank n';
    y_label = '';
    

    if strcmp(filename, 'publications.num_cite_all_papers')
        x_ticks = 10 .^ [0:7];
        y_label = 'Citation Count';
    elseif strcmp(filename, 'publications.num_coauthor_all_authors')
        x_ticks = 10 .^ [0:6];
        y_label = 'Coauthor Count';        
    end
end