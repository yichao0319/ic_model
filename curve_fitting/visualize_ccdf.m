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
%%  visualize_ccdf('../../data/rome_taxi/processed/', 'range100.contact_dur');
%%  visualize_ccdf('../../data/rome_taxi/processed/', 'range200.contact_dur');
%%  visualize_ccdf('../../data/rome_taxi/processed/', 'range100.contact_car');
%%  visualize_ccdf('../../data/rome_taxi/processed/', 'range200.contact_car');
%%
%%  visualize_ccdf('../../data/shanghai_bus/processed/', 'range100.contact_dur');
%%  visualize_ccdf('../../data/shanghai_bus/processed/', 'range200.contact_dur');
%%  visualize_ccdf('../../data/shanghai_bus/processed/', 'range100.contact_car');
%%  visualize_ccdf('../../data/shanghai_bus/processed/', 'range200.contact_car');
%%
%%  visualize_ccdf('../../data/shanghai_taxi/processed/', 'range100.contact_dur');
%%  visualize_ccdf('../../data/shanghai_taxi/processed/', 'range200.contact_dur');
%%  visualize_ccdf('../../data/shanghai_taxi/processed/', 'range300.contact_dur');
%%
%%  visualize_ccdf('../../data/sigcomm09/processed/', 'proximity.dur');
%%  visualize_ccdf('../../data/sigcomm09/processed/', 'proximity.num_seen');
%%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function visualize_ccdf(input_dir, filename)
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
    %% CCDF
    %% --------------------
    if DEBUG2, fprintf('CCDF\n'); end

    % [f,x] = ecdf(data/min(data));
    % data = data(data > min(data));
    data = data - min(data);
    data = data(data > 0);
    % data = data(data > 80);

    [f,x] = ecdf(data);
    % f = f(2:end);
    % x = x(2:end);
    f = 1-f;
    % f(1) = 1;
    % x(1) = 1;
    % f = smoothn(f);
    % f2(1) = 1;
    idx = find(x == 0); 
    if length(idx) > 0
        f(idx) = 1;
        x(idx) = 1;
    else
        x(1) = 1;
    end
    % f(x==0) = 1;
    x(1:5)'
    f(1:5)'

    
    %% --------------------
    %% Plot
    %% --------------------
    fig_idx = fig_idx + 1;
    fh = figure(fig_idx); clf;

    lh = plot(x, f, '-g');
    set(lh, 'LineWidth', 1);
    hold on;
    lh = plot(x, f, 'b.');
    % lh = plot(x, f2, 'r');
    % set(lh, 'LineWidth', 3);

    
    set(gca, 'XScale', 'log');
    set(gca, 'YScale', 'log');
    set(gca, 'XLim', [1 Inf]);
    set(gca, 'YLim', [-Inf 1]);
    
    set(gca, 'FontSize', font_size);
    title([filename ', size=' num2str(length(data))], 'Interpreter', 'none');
    xlabel('Intra-Contact Time', 'FontSize', font_size);
    ylabel('CCDF', 'FontSize', font_size);
    
    % print(fh, '-dpsc', [fig_dir filename '.eps']);
end
