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
%%   visualize_curve_snapshot('../../data/beijing_taxi/processed/', 'snapshot_counts', 3600, 300, 1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function visualize_curve_snapshot(input_dir, filename, itvl, range, binsize)
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

    colors   = {'r', 'b', [0 0.8 0], 'm', [1 0.85 0], [0 0 0.47], [0.45 0.17 0.48], 'k'};
    lines    = {'-', '--', '-.', ':'};
    markers  = {'+', 'o', '*', '.', 'x', 's', 'd', '^', '>', '<', 'p', 'h'};


    %% --------------------
    %% Variable
    %% --------------------
    fig_idx = 0;
    

    %% --------------------
    %% Check input
    %% --------------------
    if nargin < 1, input_dir = '../../data/beijing_taxi/processed/'; end
    if nargin < 2, filename = 'snapshot_counts'; end
    if nargin < 3, itvl = 3600; end
    if nargin < 4, range = 200; end
    if nargin < 5, binsize = 1; end


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

    fig_idx = fig_idx + 1;
    fh = figure(fig_idx); clf;

    cnt = 0;
    for ti = 1:4:23
        cnt = cnt + 1;
        tmp = sprintf('%ssnapshot_counts.%d.%d.%d.txt', input_dir, itvl, range, ti);
        data{cnt} = load(tmp);
        fprintf('  size = %dx%d\n', size(data{cnt}));

        %% --------------------
        %% Put to bins: equal bin
        %% --------------------
        x{cnt} = [min(data{cnt}):binsize:max(data{cnt})+1];
        y{cnt} = histc(data{cnt}, x{cnt});
        y{cnt} = y{cnt} / sum(y{cnt});

        lh = plot(x{cnt}, y{cnt}, '-b.');
        set(lh, 'Color', colors{mod(cnt-1,length(colors))+1});
        hold on;

        lhs(cnt) = lh;
        legends{cnt} = ['hr' num2str(ti)];
    end

    set(gca, 'XScale', 'log');
    set(gca, 'YScale', 'log');
    % set(gca, 'XLim', [minx maxx]);
    % set(gca, 'YLim', [miny maxy]);

    set(gca, 'FontSize', font_size);
    % title([filename ', size=' num2str(length(data))], 'Interpreter', 'none');
    % xlabel('Node Degree', 'FontSize', font_size);
    % ylabel('Frequency', 'FontSize', font_size);
    xlabel('Contact Counts', 'FontSize', font_size);
    ylabel('Frequency', 'FontSize', font_size);
    % legend(lhs, legends);
    legend('2pm', '6pm', '10pm', '2am', '6am', '10am');

    print(fh, '-dpsc', [fig_dir dataname '.' filename '.' num2str(itvl) '.' num2str(range) '.eps']);
end


%% get_dataset_name
function [dataname] = get_dataset_name(input_dir)
    C = strsplit(input_dir, '/');
    dataname = char(C{4});
end
