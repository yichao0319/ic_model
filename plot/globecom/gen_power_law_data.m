%% gen_power_law_data(2, 3)
function gen_power_law_data(a, k)
    font_size = 28;

    output_dir = './data/distribution/';
    fig_dir = './fig/';
    filename = 'powerlaw_dist_data';

    x = [1:0.1:1000];
    pdf = a * x.^(-k);
    % pdf = pdf / sum(pdf);
    % pdf(1)

    data_len = 1000000;
    data = randpdf(pdf, x, [data_len, 1]);
    ranges = min(data):1:max(data);
    prob = hist(data, ranges) / data_len;

    fh = figure(1); clf;
    % lh = plot(ranges(1:end), prob(1:end), '-k');
    % set(lh, 'LineWidth', 1);
    % hold on;
    lh = plot(ranges, prob, 'ko');
    set(lh, 'LineWidth', 1);
    set(lh, 'MarkerSize', 10);

    set(gca, 'XLim', [1 200]);
    set(gca, 'YLim', [0 1]);
    set(gca, 'XTick', [1 10 100]);
    % set(gca, 'YTick', 0:0.2:1);
    
    set(gca, 'xscale', 'log');
    set(gca, 'yscale', 'log');

    set(gca, 'FontSize', font_size);
    xlabel('Node Degree', 'FontSize', font_size);
    ylabel('Frequency', 'FontSize', font_size);
    % print(fh, '-dpsc', [fig_dir filename '.eps']);
    print(fh, '-dpng', [fig_dir filename '.png']);
end
