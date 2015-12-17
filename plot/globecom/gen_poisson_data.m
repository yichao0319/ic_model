%% gen_poisson_data(60)
function gen_poisson_data(lambda)
    font_size = 28;

    output_dir = './data/distribution/';
    fig_dir = './fig/';
    filename = 'poisson_dist_data';

    data_len = 1000000;

    data = poissrnd(lambda, data_len, 1);

    ranges = min(data):1:max(data);
    prob = hist(data, ranges) / data_len;

    % ranges = 0:lambda*lambda;
    % prob = poisspdf(ranges, lambda);

    fh = figure(1); clf;
    % lh = plot(ranges, prob, '-k');
    % set(lh, 'LineWidth', 1);
    % hold on;
    lh = plot(ranges, prob, 'ko');
    set(lh, 'LineWidth', 1);
    set(lh, 'MarkerSize', 10);

    set(gca, 'XLim', [30 100]);
    % set(gca, 'YLim', [0 0.14]);
    % set(gca, 'YTick', 0:0.04:0.15);
    
    set(gca, 'FontSize', font_size);
    xlabel('Arrival Request Number', 'FontSize', font_size);
    ylabel('Frequency', 'FontSize', font_size);
    % print(fh, '-dpsc', [fig_dir filename '.eps']);
    print(fh, '-dpng', [fig_dir filename '.png']);
 
    
    % dlmwrite([output_dir filename '.txt'], [ranges prob], 'delimiter', '\n');
end