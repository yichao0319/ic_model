function sim_ic_model_v3(N, L, U, seed)
    % N = 100000;
    % N = 1000;
    if nargin < 1, N = 100000; end
    if N <= 0, N = 100000; end
    if nargin < 2, L = 1; end
    if nargin < 3, U = N; end
    if nargin < 4, seed = 1; end

    rng(seed);


    % output_dir = './data/';
    output_dir = '../../data/sim/data/';
    % fig_dir = './fig/';
    font_size = 18;
    total_sim = 1000;

    A = randperm(N);
    k = zeros(1, N);
    k_hat = zeros(1, N);


    tStart = tic;
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

    end
    elapsed_time = toc(tStart);
    fprintf('  time = %f\n', elapsed_time);


    x = [min(k):max(k)]';
    y = histc(k, x)';


    %% --------------------
    %% Fitting
    %% --------------------
    % [fit_curve, ok, xseg, yseg, rmse] = fit_3seg_curve(x/sum(x), y, L, U);

    % if ok(2)
    %     values = coeffvalues(fit_curve{2});
    %     a = values(1);
    %     exponent = values(2);
    % else
    %     a = 0;
    %     exponent = 0;
    % end


    %% --------------------
    %% save values
    %% --------------------
    dlmwrite(sprintf('%sL%dU%dN%d.seed%d.txt', output_dir, L, U, N, seed), [x, y], 'delimiter', '\t');
    % dlmwrite(sprintf('%sL%dU%dN%d.fit.txt', output_dir, L, U, N), [a, exponent], 'delimiter', '\t');
    

    %% --------------------
    %% plot figure
    %% --------------------
    % fh = figure(1); clf;
    
    % lh = plot(x, y, '-bo');
    % set(lh, 'MarkerSize', 10);
    % legends = {'empirical data'};
    % lhs = [lh];
    % hold on;

    % if ok(2)
    %     lh = plot(xseg{2}, fit_curve{2}(xseg{2}));    
    %     set(lh, 'Color', 'r');
    %     set(lh, 'LineStyle', '-');
    %     set(lh, 'LineWidth', 4);
    %     legends{end+1} = 'Power-Law';
    %     lhs(end+1) = lh;
    %     hold on;
        
    %     if ok(1) | ok(3)
    %         others = [];
    %         if ok(1), others = [others; xseg{1}]; end
    %         if ok(3), others = [others; xseg{3}]; end
    %         lh = plot(others, fit_curve{2}(others));
    %         set(lh, 'Color', 'r');
    %         set(lh, 'LineStyle', '--');
    %         set(lh, 'LineWidth', 1);
    %     end
    % end

    % plot(x, 4/(x.*(x+1).*(x+2)), '-g');

    % set(gca, 'FontSize', font_size);
    % set(gca, 'XScale', 'log');
    % set(gca, 'YScale', 'log');
    % xlabel('Node Degree', 'FontSize', font_size);
    % ylabel('Frequency', 'FontSize', font_size);
    % title(sprintf('L=%d,U=%d, exponent=%.2f', L, U, exponent));

    % maxx = max(x) * 1.1;
    % minx = min(x) * 0.9;
    % maxy = max(y) * 1.1;
    % miny = min(y(y>0)) * 0.9;
    % set(gca, 'XLim', [minx maxx]);
    % set(gca, 'YLim', [miny maxy]);
    % legend(lhs, legends);

    % print(fh, '-dpsc', sprintf('%sL%dU%dN%d.eps', fig_dir, L, U, N));
    % print(fh, '-dpng', sprintf('%sL%dU%dN%d.png', fig_dir, L, U, N));
end


