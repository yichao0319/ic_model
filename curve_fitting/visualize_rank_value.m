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
%%  visualize_rank_value('../../data/kddcup99/processed/', 'kddcup99.dl_byte');
%%  visualize_rank_value('../../data/kddcup99/processed/', 'kddcup99.ul_byte');
%%  visualize_rank_value('../../data/kddcup99/processed/', 'kddcup99.duration');
%%  visualize_rank_value('../../data/MovieTweetings/processed/', 'movietweetings.movie_rate_cnt');
%%  visualize_rank_value('../../data/MovieTweetings/processed/', 'movietweetings.user_rate_cnt');
%%  visualize_rank_value('../../data/NetflixPrize/processed/', 'qualifying.movie_rate_cnt');
%%  visualize_rank_value('../../data/NetflixPrize/processed/', 'training.movie_rate_cnt');
%%  visualize_rank_value('../../data/NetflixPrize/processed/', 'training.user_rate_cnt');
%%  visualize_rank_value('../../data/USC_VPN_sessions/processed/', 'USC_VPN_sessions.length');
%%
%%  visualize_rank_value('../../data/citation/processed/', 'publications.num_cite_all_papers');
%%
%%  visualize_rank_value('../../data/citation/processed/', 'publications.num_coauthor_all_authors');
%%  visualize_rank_value('../../data/rome_taxi/processed/', 'range100');
%%  visualize_rank_value('../../data/rome_taxi/processed/', 'range200');
%%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function visualize_rank_value(input_dir, filename)
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


    %% --------------------
    %% Main starts
    %% --------------------
    
    %% --------------------
    %% Read data
    %% --------------------
    if DEBUG2, fprintf('Read Data\n'); end

    data = load([input_dir filename '.txt']);
    fprintf('  size = %dx%d\n', size(data));

    % rank_cnt = sort(unique(data), 'descend');
    rank_cnt = sort((data), 'descend');


    %% --------------------
    %% Plot
    %% --------------------
    fig_idx = fig_idx + 1;
    fh = figure(fig_idx); clf;

    plot(rank_cnt, '-b.');
    hold on;
    % plot(f1, '-r');
    % plot(f2, '--g');

    set(gca, 'XScale', 'log');
    set(gca, 'YScale', 'log');
    
    set(gca, 'FontSize', font_size);
    title([filename ', size=' num2str(length(data))], 'Interpreter', 'none');
    xlabel('Rank', 'FontSize', font_size)
    ylabel('Count', 'FontSize', font_size);
    
    print(fh, '-dpsc', [fig_dir 'rank.' filename '.eps']);
end
