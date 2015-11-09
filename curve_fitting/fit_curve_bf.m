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
%%  fit_curve_bf('../../data/kddcup99/processed/', 'kddcup99.dl_byte', 100);
%%  fit_curve_bf('../../data/kddcup99/processed/', 'kddcup99.ul_byte', 100);
%%  fit_curve_bf('../../data/kddcup99/processed/', 'kddcup99.duration', 100);
%%  fit_curve_bf('../../data/MovieTweetings/processed/', 'movietweetings.movie_rate_cnt', 1);
%%  fit_curve_bf('../../data/MovieTweetings/processed/', 'movietweetings.user_rate_cnt', 1);
%%  fit_curve_bf('../../data/NetflixPrize/processed/', 'qualifying.movie_rate_cnt', 1);
%%  fit_curve_bf('../../data/NetflixPrize/processed/', 'training.movie_rate_cnt', 1);
%%  fit_curve_bf('../../data/NetflixPrize/processed/', 'training.user_rate_cnt', 1);
%%  fit_curve_bf('../../data/USC_VPN_sessions/processed/', 'USC_VPN_sessions.length', 60);
%%
%%
%%  fit_curve_bf('../../data/citation/processed/', 'publications.num_cite_all_papers', 1);
%%  fit_curve_bf('../../data/citation/processed/', 'ai.num_cite_all_papers', 1);
%%  fit_curve_bf('../../data/citation/processed/', 'database.num_cite_all_papers', 1);
%%  fit_curve_bf('../../data/citation/processed/', 'graphics.num_cite_all_papers', 1);
%%  fit_curve_bf('../../data/citation/processed/', 'hci.num_cite_all_papers', 1);
%%  fit_curve_bf('../../data/citation/processed/', 'hp_computing.num_cite_all_papers', 1);
%%  fit_curve_bf('../../data/citation/processed/', 'interdisciplinary.num_cite_all_papers', 1);
%%  fit_curve_bf('../../data/citation/processed/', 'networks.num_cite_all_papers', 1);
%%  fit_curve_bf('../../data/citation/processed/', 'security.num_cite_all_papers', 1);
%%  fit_curve_bf('../../data/citation/processed/', 'software_engineering.num_cite_all_papers', 1);
%%  fit_curve_bf('../../data/citation/processed/', 'theoretical.num_cite_all_papers', 1);
%%
%%
%%  fit_curve_bf('../../data/citation/processed/', 'publications.num_coauthor_all_authors', 1);
%%  fit_curve_bf('../../data/citation/processed/', 'ai.num_coauthor_all_authors', 1);
%%  fit_curve_bf('../../data/citation/processed/', 'database.num_coauthor_all_authors', 1);
%%  fit_curve_bf('../../data/citation/processed/', 'graphics.num_coauthor_all_authors', 1);
%%  fit_curve_bf('../../data/citation/processed/', 'hci.num_coauthor_all_authors', 1);
%%  fit_curve_bf('../../data/citation/processed/', 'hp_computing.num_coauthor_all_authors', 1);
%%  fit_curve_bf('../../data/citation/processed/', 'interdisciplinary.num_coauthor_all_authors', 1);
%%  fit_curve_bf('../../data/citation/processed/', 'networks.num_coauthor_all_authors', 1);
%%  fit_curve_bf('../../data/citation/processed/', 'security.num_coauthor_all_authors', 1);
%%  fit_curve_bf('../../data/citation/processed/', 'software_engineering.num_coauthor_all_authors', 1);
%%  fit_curve_bf('../../data/citation/processed/', 'theoretical.num_coauthor_all_authors', 1);
%%
%%
%%  fit_curve_bf('../../data/citation/processed/', 'publications.num_cite_one_author.Wei Wang', 1);
%%  fit_curve_bf('../../data/citation/processed/', 'publications.num_coauthor_times_one_author.Wei Wang', 1);
%%
%%
%%  fit_curve_bf('../../data/rome_taxi/processed/', 'range100.contact_dur', 100);
%%  fit_curve_bf('../../data/rome_taxi/processed/', 'range200.contact_dur', 100);
%%
%%  fit_curve_bf('../../data/sigcomm09/processed/', 'proximity.dur', 100);
%%  fit_curve_bf('../../data/sigcomm09/processed/', 'proximity.num_seen', 150);
%%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function fit_curve_bf(input_dir, filename, binsize)
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


    %% --------------------
    %% Main starts
    %% --------------------
    
    %% --------------------
    %% Read data
    %% --------------------
    if DEBUG2, fprintf('Read Data\n'); end

    data = load([input_dir filename '.txt']);
    fprintf('  size = %dx%d\n', size(data));


    %% --------------------
    %% Put to bins: equal bin
    %% --------------------
    if DEBUG2, fprintf('Put to bins: equal bin\n'); end

    ranges = [min(data):binsize:max(data)+1];
    y = histc(data, ranges);
    % y = y / sum(y);
    y = y(2:end);
    ranges = ranges(2:end);

    %% --------------------
    %% Put to bins: log bin
    %% --------------------
    if DEBUG2, fprintf('Put to bins: log bin\n'); end

    max_log_data = log(max(data)) / log(10);
    min_log_data = max(0,log(min(data)) / log(10));
    ranges_logbin = 10.^[min_log_data:(max_log_data-min_log_data)/100:max_log_data]';
    
    ranges_new = [ranges_logbin(1)];
    for ri = 2:length(ranges_logbin)
        if ranges_logbin(ri) - ranges_new(end) >= binsize
            ranges_new = [ranges_new; ranges_logbin(ri)];
        end
    end
    ranges_logbin = ranges_new;
    y_logbin = histc(data, ranges_logbin);

    %% --------------------
    %% fitting -- logbin
    %% --------------------
    x = ranges_logbin;
    ts = y_logbin;
    step = 1;
    best_rmse = Inf;
        
    fig_idx = fig_idx + 1;
    for L = [5:step:length(ts)-5+1]
        if L <= 5
            seg1_idx = [];
            seg2_std = 1;
        else
            seg1_idx = [1:L-1];
            seg2_std = L;
        end


        for U = [seg2_std+5-1:step:length(ts)-5+1]
            if U >= length(ts)-5+1
                seg3_idx = [];
                seg2_end = length(ts);
            else
                seg3_idx = [U:length(ts)];
                seg2_end = U-1;
            end
            seg2_idx = [seg2_std:seg2_end];

            
            this_rmse = 0;
            if length(seg1_idx) > 0
                [curve1, gof1] = fit(x(seg1_idx), ts(seg1_idx), 'exp1');
                this_rmse = this_rmse + (gof1.rmse ^ 2) * length(seg1_idx);
                fprintf('    seg1 err=%f\n', gof1.rmse);
            end

            if length(seg2_idx) > 0
                [curve2, gof2] = fit(x(seg2_idx), ts(seg2_idx), 'power1');
                this_rmse = this_rmse + (gof2.rmse ^ 2) * length(seg2_idx);
                fprintf('    seg2 err=%f\n', gof2.rmse);
            end

            if length(seg3_idx) > 0
                [curve3, gof3] = fit(x(seg3_idx), ts(seg3_idx), 'exp1');
                this_rmse = this_rmse + (gof3.rmse ^ 2) * length(seg3_idx);
                fprintf('    seg3 err=%f\n', gof3.rmse);
            end

            this_rmse = sqrt(this_rmse / (length(seg1_idx)+length(seg2_idx)+length(seg3_idx)));
            fprintf('  L=%d,U=%d, len=%d, err=%f\n', L, U, length(ts), this_rmse);
            % fprintf('    len1=%d, len2=%d, len3=%d\n', length(seg1_idx), length(seg2_idx), length(seg3_idx))


            if this_rmse < best_rmse
                best_rmse = this_rmse;
                best_L = L;
                best_U = U;
                if length(seg1_idx) > 0
                    best_curve1 = curve1;
                end
                if length(seg2_idx) > 0
                    best_curve2 = curve2;
                end
                if length(seg3_idx) > 0
                    best_curve3 = curve3;
                end

                fprintf('  > best: rmse=%f, [L,U]=[%d,%d]\n', best_rmse, best_L, best_U);
            end


            %% --------------------
            %% Plot
            %% --------------------
            fh = figure(fig_idx); clf;

            plot(ranges, y, '-b.');
            hold on;
            plot(ranges_logbin, y_logbin, 'ro');
            if length(seg1_idx) > 0
                lh = plot(curve1, ':g');
                set(lh, 'LineWidth', 2);
            end
            if length(seg2_idx) > 0
                lh = plot(curve2, ':r');
                set(lh, 'LineWidth', 2);
            end
            if length(seg3_idx) > 0
                lh = plot(curve3, ':c');
                set(lh, 'LineWidth', 2);
            end
            
            set(gca, 'XScale', 'log');
            set(gca, 'YScale', 'log');

            minx = min(ranges) * 0.9;
            maxx = max(ranges) * 1.1;
            miny = max(1,min(ts) * 0.9);
            maxy = max(ts) * 1.1;
            set(gca, 'XLim', [minx maxx]);
            set(gca, 'YLim', [miny maxy]);

            % waitforbuttonpress
        end
    end
    
    %% special case: only exp
    [curve, gof] = fit(x, ts, 'exp1');
    this_rmse = gof.rmse;
    if this_rmse < best_rmse
        best_rmse = this_rmse;
        best_L = 1;
        best_U = 1;
        best_curve3 = curve;
        
        fprintf('  > best: rmse=%f, [L,U]=[%d,%d]\n', best_rmse, best_L, best_U);
    end

    fprintf('  >>>> best: rmse=%f, [L,U]=[%d,%d]\n', best_rmse, best_L, best_U);

    %% --------------------
    %% Plot
    %% --------------------
    fig_idx = fig_idx + 1;
    fh = figure(fig_idx); clf;

    plot(ranges, y, '-b.');
    hold on;
    plot(ranges_logbin, y_logbin, 'ro');
    if best_L > 5
        lh = plot(best_curve1, ':g');
        set(lh, 'LineWidth', 2);
    end
    if best_U ~= best_L
        lh = plot(best_curve2, ':r');
        set(lh, 'LineWidth', 2);
    end
    if best_U < length(ts)-5+1
        lh = plot(best_curve3, ':c');
        set(lh, 'LineWidth', 2);
    end
    
    set(gca, 'XScale', 'log');
    set(gca, 'YScale', 'log');

    minx = min(ranges) * 0.9;
    maxx = max(ranges) * 1.1;
    miny = max(1,min(ts) * 0.9);
    maxy = max(ts) * 1.1;
    set(gca, 'XLim', [minx maxx]);
    set(gca, 'YLim', [miny maxy]);

    set(gca, 'FontSize', font_size);
    title([filename ', size=' num2str(length(data))], 'Interpreter', 'none');
    xlabel('Node Degree', 'FontSize', font_size);
    ylabel('Frequency', 'FontSize', font_size);
    legend({['equal bin=' num2str(binsize)], 'log bin'});

    
    print(fh, '-dpsc', [fig_dir filename '.eps']);
end
