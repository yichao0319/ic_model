
function gen_tri_data()
    font_size = 28;

    input_dir = '../../../data/rome_taxi/processed/';
    input_filename = 'range100.contact_dur.txt';
    output_dir = './data/distribution/';
    fig_dir = './fig/';
    filename = 'our_dist_data';

    data = load([input_dir input_filename]);
    data_len = length(data);
    ranges = min(data):100:max(data);
    prob = hist(data, ranges) / data_len;
    ranges = ranges(3:end);
    prob = prob(3:end);

    fh = figure(1); clf;
    % lh = plot(ranges(2:end), prob(2:end), '-k');
    % set(lh, 'LineWidth', 1);
    % hold on;
    lh = plot(ranges, prob, 'ko');
    set(lh, 'LineWidth', 1);
    set(lh, 'MarkerSize', 10);

    set(gca, 'XLim', [100 20000]);
    % set(gca, 'YLim', [0 1]);
    set(gca, 'XTick', [100 1000 10000]);
    % set(gca, 'YTick', 0:0.2:1);
    
    set(gca, 'xscale', 'log');
    set(gca, 'yscale', 'log');

    set(gca, 'FontSize', font_size);
    xlabel('Contact Time', 'FontSize', font_size);
    ylabel('Frequency', 'FontSize', font_size);
    % print(fh, '-dpsc', [fig_dir filename '.eps']);
    print(fh, '-dpng', [fig_dir filename '.png']);
end
