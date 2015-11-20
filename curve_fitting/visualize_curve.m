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
%%  visualize_curve('../../data/kddcup99/processed/', 'kddcup99.dl_byte', 100);
%%  visualize_curve('../../data/kddcup99/processed/', 'kddcup99.ul_byte', 100);
%%  visualize_curve('../../data/kddcup99/processed/', 'kddcup99.duration', 100);
%%  visualize_curve('../../data/MovieTweetings/processed/', 'movietweetings.movie_rate_cnt', 1);
%%  visualize_curve('../../data/MovieTweetings/processed/', 'movietweetings.user_rate_cnt', 1);
%%  visualize_curve('../../data/NetflixPrize/processed/', 'qualifying.movie_rate_cnt', 1);
%%  visualize_curve('../../data/NetflixPrize/processed/', 'training.movie_rate_cnt', 1);
%%  visualize_curve('../../data/NetflixPrize/processed/', 'training.user_rate_cnt', 1);
%%  visualize_curve('../../data/USC_VPN_sessions/processed/', 'USC_VPN_sessions.length', 60);
%%
%%
%%  visualize_curve('../../data/citation/processed/', 'publications.num_cite_all_papers', 1);
%%  visualize_curve('../../data/citation/processed/', 'ai.num_cite_all_papers', 1);
%%  visualize_curve('../../data/citation/processed/', 'database.num_cite_all_papers', 1);
%%  visualize_curve('../../data/citation/processed/', 'graphics.num_cite_all_papers', 1);
%%  visualize_curve('../../data/citation/processed/', 'hci.num_cite_all_papers', 1);
%%  visualize_curve('../../data/citation/processed/', 'hp_computing.num_cite_all_papers', 1);
%%  visualize_curve('../../data/citation/processed/', 'interdisciplinary.num_cite_all_papers', 1);
%%  visualize_curve('../../data/citation/processed/', 'networks.num_cite_all_papers', 1);
%%  visualize_curve('../../data/citation/processed/', 'security.num_cite_all_papers', 1);
%%  visualize_curve('../../data/citation/processed/', 'software_engineering.num_cite_all_papers', 1);
%%  visualize_curve('../../data/citation/processed/', 'theoretical.num_cite_all_papers', 1);
%%
%%
%%  visualize_curve('../../data/citation/processed/', 'publications.num_coauthor_all_authors', 1);
%%  visualize_curve('../../data/citation/processed/', 'ai.num_coauthor_all_authors', 1);
%%  visualize_curve('../../data/citation/processed/', 'database.num_coauthor_all_authors', 1);
%%  visualize_curve('../../data/citation/processed/', 'graphics.num_coauthor_all_authors', 1);
%%  visualize_curve('../../data/citation/processed/', 'hci.num_coauthor_all_authors', 1);
%%  visualize_curve('../../data/citation/processed/', 'hp_computing.num_coauthor_all_authors', 1);
%%  visualize_curve('../../data/citation/processed/', 'interdisciplinary.num_coauthor_all_authors', 1);
%%  visualize_curve('../../data/citation/processed/', 'networks.num_coauthor_all_authors', 1);
%%  visualize_curve('../../data/citation/processed/', 'security.num_coauthor_all_authors', 1);
%%  visualize_curve('../../data/citation/processed/', 'software_engineering.num_coauthor_all_authors', 1);
%%  visualize_curve('../../data/citation/processed/', 'theoretical.num_coauthor_all_authors', 1);
%%
%%
%%  visualize_curve('../../data/citation/processed/', 'publications.num_cite_one_author.Wei Wang', 1);
%%  visualize_curve('../../data/citation/processed/', 'publications.num_coauthor_times_one_author.Wei Wang', 1);
%%
%%
%%  visualize_curve('../../data/rome_taxi/processed/', 'range100.contact_dur', 100);
%%  visualize_curve('../../data/rome_taxi/processed/', 'range200.contact_dur', 100);
%%
%%  visualize_curve('../../data/sigcomm09/processed/', 'proximity.dur', 100);
%%  visualize_curve('../../data/sigcomm09/processed/', 'proximity.num_seen', 150);
%%
%%  visualize_curve('../../data/shanghai_taxi/processed/', 'counts.600.10000', 1);
%%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function visualize_curve(input_dir, filename, binsize)
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
    %% get dataset name
    %% --------------------
    if DEBUG2, fprintf('Get Dataset Name\n'); end

    dataname = get_dataset_name(input_dir);
    fprintf('  dataset name = %s\n', dataname);
    
    
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
    y = y / sum(y);
    % y = y(2:end);
    % ranges = ranges(2:end);

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
    y_logbin = y_logbin / sum(y_logbin);


    minx = min(ranges) * 0.9;
    maxx = max(ranges) * 1.1;
    miny = min(y) * 0.9;
    maxy = max(y) * 1.1;


    %% --------------------
    %% Plot
    %% --------------------
    fig_idx = fig_idx + 1;
    fh = figure(fig_idx); clf;

    plot(ranges, y, '-b.');
    hold on;
    % plot(ranges_logbin, y_logbin, 'ro');
    
    set(gca, 'XScale', 'log');
    set(gca, 'YScale', 'log');
    set(gca, 'XLim', [minx maxx]);
    set(gca, 'YLim', [miny maxy]);

    set(gca, 'FontSize', font_size);
    title([filename ', size=' num2str(length(data))], 'Interpreter', 'none');
    % xlabel('Node Degree', 'FontSize', font_size);
    % ylabel('Frequency', 'FontSize', font_size);
    xlabel('Contact Counts', 'FontSize', font_size);
    ylabel('Frequency', 'FontSize', font_size);
    % legend({['equal bin=' num2str(binsize)], 'log bin'});

    
    print(fh, '-dpsc', [fig_dir dataname '.' filename '.eps']);
end


%% get_dataset_name
function [dataname] = get_dataset_name(input_dir)
    C = strsplit(input_dir, '/');
    dataname = char(C{4});
end
