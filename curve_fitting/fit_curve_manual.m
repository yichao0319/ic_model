%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Yi-Chao Chen @ Huawei
%%
%% - Input:
%%
%%
%% - Output:
%%
%%
%% example:
%%  fit_curve_manual('../../data/citation/processed/', 'publications.num_cite_all_papers', 1);
%%  fit_curve_manual('../../data/citation/processed/', 'ai.num_cite_all_papers', 1);
%%  fit_curve_manual('../../data/citation/processed/', 'networks.num_cite_all_papers', 1);
%%
%%  fit_curve_manual('../../data/citation/processed/', 'publications.num_coauthor_all_authors', 1);
%%  fit_curve_manual('../../data/citation/processed/', 'ai.num_coauthor_all_authors', 1);
%%  fit_curve_manual('../../data/citation/processed/', 'networks.num_coauthor_all_authors', 1);
%%
%%  fit_curve_manual('../../data/rome_taxi/processed/', 'range100.contact_dur', 100);
%%  fit_curve_manual('../../data/rome_taxi/processed/', 'range200.contact_dur', 100);
%%
%%  fit_curve_manual('../../data/rome_taxi/processed/', 'counts.60.100', 1);
%%
%%  fit_curve_manual('../../data/shanghai_bus/processed/', 'range100.contact_dur', 2000);
%%  fit_curve_manual('../../data/shanghai_bus/processed/', 'range200.contact_dur', 6000);
%%     
%%  fit_curve_manual('../../data/shanghai_taxi/processed/', 'range100.contact_dur', 1);
%%  fit_curve_manual('../../data/shanghai_taxi/processed/', 'range200.contact_dur', 1);
%%
%%  fit_curve_manual('../../data/facebook/processed/', 'facebook_combined', 3);
%%  fit_curve_manual('../../data/twitter/processed/', 'twitter_combined', 2);
%%  fit_curve_manual('../../data/us_patent_cit/processed/', 'cit-Patents', 2);
%%
%%  fit_curve_manual('../../data/beijing_taxi/processed/', 'counts.300.1000', 1);
%%  fit_curve_manual('../../data/sf_taxi/processed/', 'counts.120.1000', 1);
%%  fit_curve_manual('../../data/rome_taxi/processed/', 'counts.120.1000', 1);
%%
%%  fit_curve_manual('../../data/aps_citation/processed/', 'aps-dataset-citations-2013', 1);
%%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [rmse_our, rmse_pl, p, exponent, slope] = fit_curve_manual(input_dir, filename, binsize, L, U)
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
    if nargin < 1, input_dir = '../../data/kddcup99/processed/'; end
    if nargin < 2, filename = 'kddcup99.dl_byte'; end
    if nargin < 3, binsize = 1; end
    if nargin < 4, [L, U] = get_properties(filename, input_dir); end


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

    if findstr(filename, 'contact')
        data = data - min(data);
        data = data(data > 0);
    end
    

    %% --------------------
    %% Put to bins
    %% --------------------
    if DEBUG2, fprintf('Put to bins\n'); end

    ranges = [min(data):binsize:max(data)+1]';
    y = histc(data, ranges);
    % if ranges(1) == 0
    %     ranges = ranges + 1;
    % end
    % y = y(2:end);
    % ranges = ranges(2:end);
    idx = find(ranges > 0);
    ranges = ranges(idx);
    y = y(idx);
    y = y / sum(y);


    %% CCDF
    % yccdf = 1 - cumsum(y);
    % y = yccdf;


    %% --------------------
    %% smoothen
    %% --------------------
    % if DEBUG2, fprintf('Smoothen\n'); end

    % x_smooth = ranges(1):1:ranges(end);
    % y_smooth = smoothn(interp1(ranges, y, x_smooth), 100);
    % x_smooth = ranges;
    % y_smooth = smoothn(y, 100);


    

    %% --------------------
    %% Put to bins: log bin
    %% --------------------
    % if DEBUG2, fprintf('Put to bins: log bin\n'); end

    % max_log_data = log(max(data)) / log(10);
    % min_log_data = max(0,log(min(data)) / log(10));

    % bin_ratio = 100;
    % ranges_logbin = 10.^[min_log_data:(max_log_data-min_log_data)/bin_ratio:max_log_data]';
    % ranges_new = [ranges_logbin(1)];
    % for ri = 2:length(ranges_logbin)
    %     if ranges_logbin(ri) - ranges_new(end) >= binsize
    %         ranges_new = [ranges_new; ranges_logbin(ri)];
    %     end
    % end
    % ranges_logbin = ranges_new;
    
    % y_logbin = histc(data, ranges_logbin);
    % y_logbin = y_logbin(2:end);
    % ranges_logbin = ranges_logbin(2:end);

    % idx = find(y_logbin > 0);
    % y_logbin = y_logbin(idx);
    % ranges_logbin = ranges_logbin(idx);
    % % y_logbin = y_logbin / sum(y);

    % idx = find(ranges_logbin > 0);
    % ranges_logbin = ranges_logbin(idx);
    % y_logbin = y_logbin(idx);


    %% --------------------
    %% Plot data without fitting
    %% --------------------
    % fig_idx = fig_idx + 1;
    % fh = figure(fig_idx); clf;
    % lh = plot(ranges, y, '-b.');
    % hold on;
    % % lh = plot(x_smooth, y_smooth, '-b')
    % % lh = plot(ranges_logbin, y_logbin, 'ro');
    % legend('data', 'in log bins');

    % set(gca, 'XScale', 'log');
    % set(gca, 'YScale', 'log');
    % title('no fitting');
    
    
    %% --------------------
    %% Curve Fitting -- original
    %% --------------------
    if DEBUG2, fprintf('Curve Fitting\n'); end

    fig_idx = fig_idx + 1;
    % y = y/sum(y);
    [fit_curve, ok, xseg, yseg, rmse] = fit_3seg_curve(ranges, y, L, U);
    atitle = [filename ', size=' num2str(length(data)) ', bin=' num2str(binsize)];
    plot_3seg_curve(ranges, y, L, U, fit_curve, ok, xseg, yseg, fig_idx, atitle, font_size, filename, input_dir, fig_dir, 'fit_manual.orig');


    %% --------------------
    %% Goodness of fit
    %% --------------------
    % if DEBUG2, fprintf('Goodness of fit\n'); end

    % if ok(1)
    %     %% empirical data
    %     idx = find(data <= L);
    %     x1 = data(idx);
    %     %% distribution
    %     pdfs = PDFsampler(x1);
    %     x2 = [];
    %     for i = 1:length(x1)
    %         x2(i) = pdfs.nextRandom;
    %     end

    %     % tmp_ranges1 = [min(x1):binsize:max(x1)+1]';
    %     % tmp_y1 = histc(x1, tmp_ranges1);
    %     % tmp_y1 = tmp_y1 / sum(tmp_y1);

    %     % tmp_ranges2 = [min(x2):binsize:max(x2)+1]';
    %     % tmp_y2 = histc(x2, tmp_ranges2);
    %     % tmp_y2 = tmp_y2 / sum(tmp_y2);
        
    %     % fig_idx = fig_idx + 1;
    %     % fh = figure(fig_idx); clf;
    %     % plot(tmp_ranges1, tmp_y1, '-b.');
    %     % hold on;
    %     % plot(tmp_ranges2, tmp_y2, '-r.');
    %     % set(gca, 'xscale', 'log');
    %     % set(gca, 'yscale', 'log');
    %     % set(gca, 'FontSize', font_size);

    %     % [h, p] = kstest2(x1, x2)
    %     [h, p] = kstest2(x1(randi(length(x1), 1, min(length(x1),100))), ...
    %                      x2(randi(length(x2), 1, min(length(x2),100))));
    %     fprintf('  phase1: h=%d, p=%f\n', h, p);
    % end
    % if ok(2)
    %     %% empirical data
    %     idx = find(data >= L & data <= U);
    %     x1 = data(idx);
    %     %% distribution
    %     pdfs = PDFsampler(x1);
    %     x2 = [];
    %     for i = 1:length(x1)
    %         x2(i) = pdfs.nextRandom;
    %     end

    %     tmp_ranges1 = [min(x1):binsize:max(x1)+1]';
    %     tmp_y1 = histc(x1, tmp_ranges1);
    %     tmp_y1 = tmp_y1 / sum(tmp_y1);

    %     tmp_ranges2 = [min(x2):binsize:max(x2)+1]';
    %     tmp_y2 = histc(x2, tmp_ranges2);
    %     tmp_y2 = tmp_y2 / sum(tmp_y2);
        
    %     fig_idx = fig_idx + 1;
    %     fh = figure(fig_idx); clf;
    %     plot(tmp_ranges1, tmp_y1, '-b.');
    %     hold on;
    %     plot(tmp_ranges2, tmp_y2, '-r.');
    %     set(gca, 'xscale', 'log');
    %     set(gca, 'yscale', 'log');
    %     set(gca, 'FontSize', font_size);

    %     [h, p] = kstest2(x1(randi(length(x1), 1, min(length(x1),1000))), ...
    %                      x2(randi(length(x2), 1, min(length(x2),1000))));
    %     fprintf('  phase1: h=%d, p=%f\n', h, p);
    % end
    % if ok(3)
    %     %% empirical data
    %     idx = find(data >= U);
    %     x1 = data(idx);
    %     %% distribution
    %     pdfs = PDFsampler(x1);
    %     x2 = [];
    %     for i = 1:length(x1)
    %         x2(i) = pdfs.nextRandom;
    %     end

    %     tmp_ranges1 = [min(x1):binsize:max(x1)+1]';
    %     tmp_y1 = histc(x1, tmp_ranges1);
    %     tmp_y1 = tmp_y1 / sum(tmp_y1);

    %     tmp_ranges2 = [min(x2):binsize:max(x2)+1]';
    %     tmp_y2 = histc(x2, tmp_ranges2);
    %     tmp_y2 = tmp_y2 / sum(tmp_y2);
        
    %     fig_idx = fig_idx + 1;
    %     fh = figure(fig_idx); clf;
    %     plot(tmp_ranges1, tmp_y1, '-b.');
    %     hold on;
    %     plot(tmp_ranges2, tmp_y2, '-r.');
    %     set(gca, 'xscale', 'log');
    %     set(gca, 'yscale', 'log');
    %     set(gca, 'FontSize', font_size);

    %     [h, p] = kstest2(x1(randi(length(x1), 1, min(length(x1),100))), ...
    %                      x2(randi(length(x2), 1, min(length(x2),100))));
    %     fprintf('  phase1: h=%d, p=%f\n', h, p);
    % end



    %% --------------------
    %% Fitting Error using Power Law
    %% --------------------
    if DEBUG2, fprintf('Fitting Error using Powere Law\n'); end

    pl_error_mid = sqrt(mean((yseg{2} - fit_curve{2}(xseg{2})) .^ 2));
    pl_error_all = sqrt(mean((y - fit_curve{2}(ranges)) .^ 2));
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
        % exponent = fit_curve{2}.n;
        exponent = fit_curve{2}.b;
    else
        exponent = 0;
    end

    slope = (y(1)-y(2))/(ranges(2)-ranges(1));
    slope

    % exponent_best = 1 + length(xseg{2}) * (sum(log(xseg{2}/xseg{2}(1))) .^ (-1) );
    % exponent_best

    %% --------------------
    %% Curve Fitting -- log bin
    %% --------------------
    % if DEBUG2, fprintf('Curve Fitting: log bin\n'); end

    % fig_idx = fig_idx + 1;
    % % y_logbin = y_logbin/sum(y_logbin);
    % [fit_curve, ok, xseg, yseg] = fit_3seg_curve(ranges_logbin, y_logbin, L, U);
    % atitle = [filename ', size=' num2str(length(data)) ', bin=' num2str(binsize)];
    % plot_3seg_curve(ranges_logbin, y_logbin, L, U, fit_curve, ok, xseg, yseg, fig_idx, atitle, font_size, filename, input_dir, fig_dir, 'fit_manual.logbin');
end




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
        % L = 20;
        % U = 60;
        L = 18;
        U = 50;
    elseif strcmp(filename, 'ai.num_cite_all_papers')
        L = 20;
        U = 45;
    elseif strcmp(filename, 'networks.num_cite_all_papers')
        L = 15;
        U = 32;
    elseif strcmp(filename, 'publications.num_coauthor_all_authors')
        L = 15;
        U = 100;
    elseif strcmp(filename, 'ai.num_coauthor_all_authors')
        L = 6;
        U = 28;
    elseif strcmp(filename, 'networks.num_coauthor_all_authors')
        L = 7;
        U = 30;
    elseif strcmp(filename, 'range100.contact_dur') & length(findstr(input_dir, 'rome_taxi')>0)
        L = 900;
        U = 5000;
    elseif strcmp(filename, 'range200.contact_dur') & length(findstr(input_dir, 'rome_taxi')>0)
        L = 800;
        U = 5000;
    elseif strcmp(filename, 'range100.contact_dur') & length(findstr(input_dir, 'shanghai_bus')>0)
        L = 40000;
        U = 60000;
    elseif strcmp(filename, 'range200.contact_dur') & length(findstr(input_dir, 'shanghai_bus')>0)
        L = 40000;
        U = 80000;
    elseif strcmp(filename, 'facebook_combined')
        L = 20;
        U = 100;
    elseif strcmp(filename, 'twitter_combined')
        L = 40;
        U = 200;
    elseif strcmp(filename, 'cit-Patents')
        L = 15;
        U = 150;
    elseif strcmp(filename, 'aps-dataset-citations-2013')
        L = 20;
        U = 150;
    elseif length(findstr(input_dir, 'beijing_taxi'))>0 & length(findstr(filename, 'counts'))>0
        L = 0;
        U = 25;
    elseif length(findstr(input_dir, 'sf_taxi'))>0 & length(findstr(filename, 'counts'))>0
        L = 0;
        U = 100;
    elseif length(findstr(input_dir, 'rome_taxi'))>0 & length(findstr(filename, 'counts'))>0
        L = 0;
        U = 15;
    end
end


%% get_figname
% function figname = get_figname(filename, input_dir, fig_dir, prefix)
%     if findstr(input_dir, 'rome_taxi')
%         figname = [fig_dir prefix '.rome_taxi.' filename];
%     elseif findstr(input_dir, 'shanghai_bus')
%         figname = [fig_dir prefix '.shanghai_bus.' filename];
%     elseif findstr(input_dir, 'shanghai_taxi')
%         figname = [fig_dir prefix '.shanghai_taxi.' filename];
%     elseif findstr(input_dir, 'beijing_taxi')
%         figname = [fig_dir prefix '.beijing_taxi.' filename];
%     elseif findstr(input_dir, 'sf_taxi')
%         figname = [fig_dir prefix '.sf_taxi.' filename];
%     elseif findstr(input_dir, 'seattle_bus')
%         figname = [fig_dir prefix '.seattle_bus.' filename];
%     else
%         figname = [fig_dir prefix '.' filename];
%     end
% end


%% get_plot_param
% function [x_ticks, y_ticks, x_label, y_label] = get_plot_param(filename, input_dir)
%     if nargin < 2, input_dir = './'; end

%     x_ticks = [];
%     y_ticks = [];
%     x_label = '';
%     y_label = '';
    

%     if strcmp(filename, 'publications.num_cite_all_papers')
%         % y_ticks = 10 .^ [0:5];
%         x_label = 'Citation Count x';
%         y_label = 'Number of Papers';
%     elseif strcmp(filename, 'ai.num_cite_all_papers')
%         x_label = 'Citation Count x';
%         y_label = 'Number of Papers';
%     elseif strcmp(filename, 'networks.num_cite_all_papers')
%         x_label = 'Citation Count x';
%         y_label = 'Number of Papers';
%     elseif strcmp(filename, 'publications.num_coauthor_all_authors')
%         % x_ticks = 10 .^ [0:3];
%         % y_ticks = 10 .^ [0:7];
%         x_label = 'Coauthor Count x';
%         y_label = 'Nummber of Scientists';
%     elseif strcmp(filename, 'ai.num_coauthor_all_authors')
%         x_label = 'Coauthor Count x';
%         y_label = 'Nummber of Scientists';
%     elseif strcmp(filename, 'networks.num_coauthor_all_authors')
%         x_label = 'Coauthor Count x';
%         y_label = 'Nummber of Scientists';
%     elseif strcmp(filename, 'range100.contact_dur') & length(findstr(input_dir, 'rome_taxi'))>0
%         x_label = 'Contact Duration (s)';
%         y_label = 'Number of Contacts';
%     elseif strcmp(filename, 'range200.contact_dur') & length(findstr(input_dir, 'rome_taxi'))>0
%         x_label = 'Contact Duration (s)';
%         y_label = 'Number of Contacts';
%     elseif strcmp(filename, 'range100.contact_dur') & length(findstr(input_dir, 'shanghai_bus'))>0
%         x_label = 'Contact Duration (s)';
%         y_label = 'Number of Contacts';
%     elseif strcmp(filename, 'range200.contact_dur') & length(findstr(input_dir, 'shanghai_bus'))>0
%         x_label = 'Contact Duration (s)';
%         y_label = 'Number of Contacts';
%     elseif strcmp(filename, 'facebook_combined')
%         x_label = 'Friend Count x';
%         y_label = 'Number of Users';
%     elseif strcmp(filename, 'twitter_combined')
%         x_label = 'Following People Count x';
%         y_label = 'Number of Users';
%     elseif strcmp(filename, 'cit-Patents')
%         x_label = 'Citation Count x';
%         y_label = 'Number of Patents';
%     elseif strcmp(filename, 'aps-dataset-citations-2013')
%         x_label = 'Citation Count x';
%         y_label = 'Number of Papers';
%     elseif length(findstr(input_dir, 'beijing_taxi'))>0 & length(findstr(filename, 'counts'))>0
%         x_label = 'Contact Count x';
%         y_label = 'Number of Vehicles';
%     elseif length(findstr(input_dir, 'sf_taxi'))>0 & length(findstr(filename, 'counts'))>0
%         x_label = 'Contact Count x';
%         y_label = 'Number of Vehicles';
%     elseif length(findstr(input_dir, 'rome_taxi'))>0 & length(findstr(filename, 'counts'))>0
%         x_label = 'Contact Count x';
%         y_label = 'Number of Vehicles';
%     elseif length(findstr(input_dir, 'shanghai_taxi'))>0 & length(findstr(filename, 'counts'))>0
%         x_label = 'Contact Count x';
%         y_label = 'Number of Vehicles';
%     end
%     y_label = 'Frequency';
% end
