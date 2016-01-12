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
%%  plot_T(15)
%%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plot_T(seed)
    
    %% --------------------
    %% DEBUG
    %% --------------------
    DEBUG0 = 0;
    DEBUG1 = 1;
    DEBUG2 = 1;  %% progress
    DEBUG3 = 1;  %% verbose
    DEBUG4 = 1;  %% results

    if nargin < 1, seed = 15; end
    rng(seed);

    %% --------------------
    %% Constant
    %% --------------------
    input_dir  = '';
    output_dir = './fig/';
    font_size = 18;


    %% --------------------
    %% Variable
    %% --------------------
    fig_idx = 0;
    num_nodes = 8;
    mu = 1;
    spacex = mu * 0.01;
    spacey = num_nodes*0.01;

    %% --------------------
    %% Main starts
    %% --------------------
    
    %% lasting time follows exp. dist.
    Ts = exprnd(mu, [1, num_nodes-1]);
    tao = max(Ts);
    Ts = sort([Ts tao], 'descend');
    % Ts

    start_time = tao - Ts;

    fh = figure(1); clf;
    for ni = 1:num_nodes
        lh = plot([start_time(ni) tao], [ni ni]);
        set(lh, 'LineWidth', 3);
        hold on;
        
        if ni <= 2
            text(start_time(ni)+spacex, ni+spacey, ['$T_{' num2str(ni) '}=\mathcal{T}$'], ...
                'HorizontalAlignment', 'left', ...
                'VerticalAlignment', 'bottom', ...
                'interpreter', 'latex', 'fontsize', font_size);
        elseif ni <= 7
            text(start_time(ni)+spacex, ni+spacey, ...
                ['$T_{' num2str(ni) '}=\mathcal{T}-t_{' num2str(ni) '}$'], ...
                'HorizontalAlignment', 'left', ...
                'VerticalAlignment', 'bottom', ...
                'interpreter', 'latex', 'fontsize', font_size);
        end
        
        if ni > 2
            lh = plot([start_time(ni) start_time(ni)], [0 ni], ':k');
            % set(lh, 'LineWidth', 3);
        end
    end
    set(gca, 'XLim', [0 tao*1.05]);
    set(gca, 'YLim', [0 num_nodes+1]);
    
    set(gca, 'XTick', [unique(start_time) tao]);
    xtics = get(gca,'XTick');
    new_x_label = ['|'  sprintf('$t_%d$|', [3:length(xtics)]) '$\mathcal{T}$'];
    % set(gca,'XTickLabel', sprintf('%.1f|', xtics));
    % set(gca,'XTickLabel', ['0|' sprintf('t%d|', [3:length(xtics)])]);
    % text(tao, -0.4, ['$\mathcal{T}$'], ...
    %      'HorizontalAlignment', 'center', ...
    %      'VerticalAlignment', 'top', ...
    %      'interpreter', 'latex', 'fontsize', font_size);
    a = get(gca, 'XTickLabel');
    set(gca, 'XTickLabel',['0||||||||||||||']);
    b = get(gca,'XTick');
    c = get(gca,'YTick');
    th = text(b, repmat(c(1)-.1*(c(2)-c(1)),length(b),1), ...
              new_x_label, ...
              'HorizontalAlignment', 'center', ...
              'VerticalAlignment', 'top', ...
              'interpreter', 'latex', 'fontsize', font_size);
    
    
    set(gca, 'YTick', 1:num_nodes);
    ytics = get(gca,'YTick');
    set(gca,'YTickLabel', sprintf('node%d|', ytics));
    
    set(gca, 'FontSize', font_size);
    xlabel('Time', 'FontSize', font_size);

    set(gca, 'OuterPosition', [0 0 1 0.6]);  %% normalized value, [0 0 1 1] in default
    % set(gca, 'Position', [0 0 0.7 1]);

    print(fh, '-depsc', [output_dir 'lasting_system_time.eps']);
end
