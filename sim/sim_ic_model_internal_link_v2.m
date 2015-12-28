%% sim_ic_model_internal_link(100000, 2, 8, 1, 'rand')
%% sim_ic_model_internal_link(100000, 2, 8, 1, 'mc')
%% sim_ic_model_internal_link(100000, 3, 10, 1, 'rand')
%% sim_ic_model_internal_link(100000, 3, 10, 1, 'mc')
%% sim_ic_model_internal_link(100000, 1, 1, 1, 'rand')
%% sim_ic_model_internal_link(100000, 1, 1, 1, 'mc')
%% sim_ic_model_internal_link(100000, 1, 100000, 1, 'rand')
%% sim_ic_model_internal_link(100000, 1, 100000, 1, 'mc')
function [a, exponent] = sim_ic_model_internal_link(N, L, U, itvl, sel_type)
    % N = 100000;
    % N = 1000;
    if nargin < 1, N = 100000; end
    if N <= 0, N = 100000; end
    if nargin < 2, L = 1; end
    if nargin < 3, U = N; end
    if nargin < 4, itvl = 1; end
    if nargin < 5, sel_type = 'mc'; end


    output_dir = './data/';
    fig_dir = './fig/';
    font_size = 18;
    total_sim = 1000;

    star = round(N*rand); %a random index of 300,000
    A = randperm(N);
    k = zeros(1, N);
    k_hat = zeros(1, N);


    for i = 1:N
        % fprintf('%d / %d\n', i, N);
        show_progress(i, N, 1);

        %% ---------------------
        %% calculate node degree
        %% ---------------------
        k(A(i)) = 1;
        %% find phase1 nodes
        idx = find(k(A(1:i)) <= L);
        k_hat(A(idx)) = L;
        %% find phase2 nodes
        idx = find(k(A(1:i)) > L & k(A(1:i)) <= U);
        k_hat(A(idx)) = k(A(idx));
        %% find phase3 nodes
        idx = find(k(A(1:i)) > U);
        k_hat(A(idx)) = U;


        %% ---------------------
        %% attach to a node
        %% ---------------------
        prob = k_hat(A(1:i)) / sum(k_hat(A(1:i)));
        cdf = cumsum(prob);
        
        realized = rand;
        idx = find(cdf > realized);
        idx = idx(1);
        k(A(idx)) = k(A(idx)) + 1;


        %% ---------------------
        %% select an existing node to attach to others
        %% ---------------------
        if i > 10 & mod(i,itvl) == 0
            %% select an existing node
            if strcmp(sel_type, 'mc')
                realized = rand;
                idx = find(cdf > realized);
                idx = idx(1);
            elseif strcmp(sel_type, 'rand')
                idx = round(rand * (i-2)) + 1;
            elseif strcmp(sel_type, 'cal')
                kk = cal_k(k(A(1:i)), i);
            else
                error('wrong selection type');
            end
                
            k(A(idx)) = k(A(idx)) + 1;

            %% attach to another node
            idx2 = idx;
            while(idx2 == idx)
                realized = rand;
                idx2 = find(cdf > realized);
                idx2 = idx2(1);
            end
            k(A(idx2)) = k(A(idx2)) + 1;
        end
    end

    % K(sim) = k(star);
    x = [min(k):max(k)]';
    y = histc(k, x)';


    %% --------------------
    %% Fitting
    %% --------------------
    [fit_curve, ok, xseg, yseg, rmse] = fit_3seg_curve(x, y, L, U);

    if ok(2)
        values = coeffvalues(fit_curve{2});
        a = values(1);
        exponent = values(2);
    else
        a = 0;
        exponent = 0;
    end


    %% --------------------
    %% save values
    %% --------------------
    xx = [0; x];
    yy = [N; y];
    dlmwrite(sprintf('%sL%dU%dN%d.internal_link.itvl%d.%s.txt', output_dir, L, U, N, itvl, sel_type), [xx, yy], 'delimiter', '\t');
    dlmwrite(sprintf('%sL%dU%dN%d.internal_link.itvl%d.%s.fit.txt', output_dir, L, U, N, itvl, sel_type), [a, exponent], 'delimiter', '\t');
    

    %% --------------------
    %% plot figure
    %% --------------------
    fh = figure(1); clf;
    
    lh = plot(x, y, '-bo');
    set(lh, 'MarkerSize', 10);
    legends = {'empirical data'};
    lhs = [lh];
    hold on;

    if ok(2)
        lh = plot(xseg{2}, fit_curve{2}(xseg{2}));    
        set(lh, 'Color', 'r');
        set(lh, 'LineStyle', '-');
        set(lh, 'LineWidth', 4);
        legends{end+1} = 'Power-Law';
        lhs(end+1) = lh;
        hold on;
        
        if ok(1) | ok(3)
            others = [];
            if ok(1), others = [others; xseg{1}]; end
            if ok(3), others = [others; xseg{3}]; end
            lh = plot(others, fit_curve{2}(others));
            set(lh, 'Color', 'r');
            set(lh, 'LineStyle', '--');
            set(lh, 'LineWidth', 1);
        end
    end

    % plot(x, 4/(x.*(x+1).*(x+2)), '-g');

    set(gca, 'FontSize', font_size);
    set(gca, 'XScale', 'log');
    set(gca, 'YScale', 'log');
    xlabel('Node Degree', 'FontSize', font_size);
    ylabel('Frequency', 'FontSize', font_size);
    title(sprintf('L=%d,U=%d, exponent=%.2f', L, U, exponent));

    maxx = max(x) * 1.1;
    minx = min(x) * 0.9;
    maxy = max(y) * 1.1;
    miny = min(y(y>0)) * 0.9;
    set(gca, 'XLim', [minx maxx]);
    set(gca, 'YLim', [miny maxy]);
    legend(lhs, legends);

    % print(fh, '-dpsc', sprintf('%sL%dU%dN%d.internal_link.eps', fig_dir, L, U, N));
    % print(fh, '-dpng', sprintf('%sL%dU%dN%d.internal_link.png', fig_dir, L, U, N));
end

function [k] = cal_k(K, n)
    epsilon = 0.001;
    c = sum(K) / 2;
    
    prev_a = 0;
    prev_dif = 0;

    a = 0;
    dif = sum(sqrt(1 - a*K/2/c)) - n + 2;
    
    n
    K
    c
    while abs(dif) > epsilon
        a
        dif
        sum(sqrt(1 - a*K/2/c))
        n-2

        if dif * prev_dif < 0
            new_a = (a+prev_a)/2;
        elseif dif > 0
            new_a = 2*c/max(K);
        elseif dif < 0
            error('should not be here');
        end

        prev_a = a;
        prev_dif = dif;

        a = new_a;
        dif = sum(sqrt(1 - a*K/2/c)) - n + 2;
        input('')
    end

    a
    dif
    sum(sqrt(1 - a*K/2/c))
    n-2

    input('')
    k = 8/a - 2;
end


