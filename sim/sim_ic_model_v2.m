% Generate 300,000 points
% Focus on 1 particular node * among the 300,000 points

%% sim_ic_model_v2: function description
function [exponent] = sim_ic_model_v2(N, L, U)
    % N = 100000;
    % N = 1000;
    if nargin < 1, N = 100000; end
    if N <= 0, N = 100000; end
    if nargin < 2, L = 1; end
    if nargin < 3, U = N; end


    fig_dir = './fig/';
    font_size = 18;
    total_sim = 1000;

    star = round(N*rand); %a random index of 300,000
    A = randperm(N);
    k = zeros(1, N);
    k_hat = zeros(1, N);


    for i = 1:N
        % fprintf('%d / %d\n', i, N);

        k(A(i)) = 1;
        for j = 1:i
        	if k(A(j)) <= L
           	k_hat(A(j)) = L;
	   	else
            	if k(A(j)) <= U
                		k_hat(A(j)) = k(A(j));
            	else
                		k_hat(A(j)) = U;
            	end
        	end
        end
        total_mod_deg = sum(k_hat(A(1:i)));
        
        prob = zeros(1, i);
        cdf = zeros(1, i);

        for j = 1:i
            
            prob(j) = k_hat(A(j))/total_mod_deg;
        
            if(j == 1)
                cdf(j) = prob(j);
            else
                cdf(j) = cdf(j-1) + prob(j);
            end

        end

        realized = rand;
        join = zeros(1, i);
    
        % prob of attaching the node is k_hat/sum(k_hat);

        for j = 1:i
            if (realized < cdf(j))
                join(j) = 1;
                break;
            end
        end
       
        for j2 = 1:i
            k(A(j2)) = k(A(j2)) + join(j2);
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
        exponent = values(2);
    else
        exponent = 0;
    end


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

    plot(x, 4/(x.*(x+1).*(x+2)), '-g');

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

    print(fh, '-dpsc', sprintf('%sL%dU%dN%d.eps', fig_dir, L, U, N));
    print(fh, '-dpng', sprintf('%sL%dU%dN%d.png', fig_dir, L, U, N));
end




%% fit_3seg_curve
function [fit_curve, ok, xseg, yseg, rmse] = fit_3seg_curve(x, y, L, U)
    ok = [0, 0, 0];

    min_cnt = 3;

    idx = find(x <= L);
    rmse = 0;
    len = 0;
    if length(idx) > min_cnt
        ok(1) = 1;
        xseg{1} = x(idx);
        yseg{1} = y(idx);

        [fit_curve{1}, gof{1}] = fit(xseg{1}, yseg{1}, 'exp1', 'Robust', 'Bisquare');
        fprintf('  Error1:\n');
        fit_curve{1}
        gof{1}
        rmse = rmse + (gof{1}.rmse ^ 2) * length(xseg{1});
        len = len + length(xseg{1});
    end

    idx = find(x > L & x <= U);
    if length(idx) > min_cnt
        ok(2) = 1;
        xseg{2} = x(idx);
        yseg{2} = y(idx);

        [fit_curve{2}, gof{2}] = fit(xseg{2}, yseg{2}, 'power1');
        fprintf('  Error2:\n');
        fit_curve{2}
        gof{2}
        rmse = rmse + (gof{2}.rmse ^ 2) * length(xseg{2});
        len = len + length(xseg{2});
    end

    idx = find(x > U);
    if length(idx) > min_cnt
        ok(3) = 1;
        xseg{3} = x(idx);
        yseg{3} = y(idx);

        [fit_curve{3}, gof{3}] = fit(xseg{3}, yseg{3}, 'exp1');
        fprintf('  Error3:\n');
        fit_curve{3}
        gof{3}
        rmse = rmse + (gof{3}.rmse ^ 2) * length(xseg{3});
        len = len + length(xseg{3});
    end

    rmse = sqrt(rmse / len);
    fprintf('  Avg RMSE = %f\n', rmse);
end


%% plot_3seg_curve
function plot_3seg_curve(x, y, L, U, fit_curve, ok, xseg, yseg, fig_idx, atitle, font_size, filename, input_dir, fig_dir, prefix)

    figname = get_figname(filename, input_dir, fig_dir, prefix);
    [x_ticks, y_ticks, x_label, y_label] = get_plot_param(filename, input_dir);
    maxx = max(x) * 1.1;
    minx = min(x) * 0.9;
    maxy = max(y) * 1.1;
    miny = min(y(y>0)) * 0.9;
    % miny


    fh = figure(fig_idx); clf;

    % lh = plot(x, y, '-b');
    lh = plot(x, y, 'bo');
    % set(lh, 'LineWidth', 5);
    set(lh, 'MarkerSize', 10);
    legends = {'empirical data'};
    lhs = [lh];
    hold on;

    if ok(1)
        % lh = plot(xseg{1}, yseg{1}, '-g');
        % lh = plot(fit_curve{1});
        lh = plot(xseg{1}, fit_curve{1}(xseg{1}));
        set(lh, 'Color', [0 0.8 0]);
        set(lh, 'LineStyle', '-');
        set(lh, 'LineWidth', 2);
        legends{end+1} = 'phase1';
        lhs(end+1) = lh;
        hold on;

        others = [];
        if ok(2), others = [others; xseg{2}]; end
        if ok(3), others = [others; xseg{3}]; end
        lh = plot(others, fit_curve{1}(others));
        set(lh, 'Color', [0 0.8 0]);
        set(lh, 'LineStyle', '--');
        set(lh, 'LineWidth', 1);
    end

    if ok(2)
        % lh = plot(fit_curve{2}, '-r');
        lh = plot(xseg{2}, fit_curve{2}(xseg{2}));
        set(lh, 'Color', 'r');
        set(lh, 'LineStyle', '-');
        set(lh, 'LineWidth', 4);
        legends{end+1} = 'phase2';
        lhs(end+1) = lh;
        hold on;

        others = [];
        if ok(1), others = [others; xseg{1}]; end
        if ok(3), others = [others; xseg{3}]; end
        lh = plot(others, fit_curve{2}(others));
        set(lh, 'Color', 'r');
        set(lh, 'LineStyle', '--');
        set(lh, 'LineWidth', 1);
    end

    if ok(3)
        % lh = plot(fit_curve{3}, '-m');
        lh = plot(xseg{3}, fit_curve{3}(xseg{3}));
        set(lh, 'Color', 'm');
        set(lh, 'LineStyle', '-');
        set(lh, 'LineWidth', 6);
        legends{end+1} = 'phase3';
        lhs(end+1) = lh;
        hold on;

        others = [];
        if ok(1), others = [others; xseg{1}]; end
        if ok(2), others = [others; xseg{2}]; end
        lh = plot(others, fit_curve{3}(others));
        set(lh, 'Color', 'm');
        set(lh, 'LineStyle', '--');
        set(lh, 'LineWidth', 1);
    end

    % plot([L L], [miny maxy], '--k');
    % plot([U U], [miny maxy], '--k');
    % ylu = interp1(x,y, [L,U]);
    % lh = plot([L U], ylu, 'ro');
    % set(lh, 'MarkerSize', 15);

    set(gca, 'XScale', 'log');
    set(gca, 'YScale', 'log');
    set(gca, 'XLim', [minx maxx]);
    set(gca, 'YLim', [miny maxy]);
    if length(x_ticks)>0, set(gca, 'XTick', x_ticks); end
    if length(y_ticks)>0, set(gca, 'YTick', y_ticks); end

    set(gca, 'FontSize', font_size);
    % title(atitle, 'Interpreter', 'none');
    legend(lhs, legends);
    % xlabel('Node Degree', 'FontSize', font_size);
    % ylabel('Frequency', 'FontSize', font_size);
    % xlabel('Paper Citations', 'FontSize', font_size);
    % ylabel('Number of Papers', 'FontSize', font_size);
    % xlabel('Coauthors', 'FontSize', font_size);
    % ylabel('Number of Scientists', 'FontSize', font_size);
    % xlabel('Contact Time', 'FontSize', font_size);
    % ylabel('Number of Contacts', 'FontSize', font_size);
    xlabel(x_label, 'FontSize', font_size);
    ylabel(y_label, 'FontSize', font_size);
    
    print(fh, '-dpsc', [figname '.eps']);
    print(fh, '-dpng', [figname '.png']);
end

