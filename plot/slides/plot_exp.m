function plot_exp
    input_dir = './data/exp/';
    fig_dir   = './fig/';
    font_size = 26;
    colors   = {'r', 'b', [0 0.8 0], 'm', [1 0.85 0], [0 0 0.47], [0.45 0.17 0.48], 'k'};

    legends = {'Empirical Data', 'MC:Geom($\frac{\gamma}{\gamma+L}$)', 'MC:Power-Low', 'MC:Geom($\frac{\gamma}{\gamma+U}$)'};

    plot_coauthor(input_dir, fig_dir, font_size, legends, colors);
    plot_dblp(input_dir, fig_dir, font_size, legends, colors);
    plot_coauthor_network(input_dir, fig_dir, font_size, legends, colors);
    plot_dblp_network(input_dir, fig_dir, font_size, legends, colors);
    plot_aps(input_dir, fig_dir, font_size, legends, colors);
    plot_patent(input_dir, fig_dir, font_size, legends, colors);
    plot_facebook(input_dir, fig_dir, font_size, legends, colors);
    plot_twitter(input_dir, fig_dir, font_size, legends, colors);
    plot_rome(input_dir, fig_dir, font_size, legends, colors);
    plot_beijing(input_dir, fig_dir, font_size, legends, colors);
    plot_sf(input_dir, fig_dir, font_size, legends, colors);
end



function [data, param, esty1, esty2, esty3, esty1_others, esty2_others, esty3_others] = get_data(input_dir, filename)

    data = load([input_dir filename '.data.txt']);
    param = load([input_dir filename '.param_and_err.txt']);
    L = param(1);
    U = param(2);
    exponent = param(6);
    esty1 = load([input_dir filename '.phase1.a.txt']);
    esty2 = load([input_dir filename '.phase2.b.txt']);
    esty3 = load([input_dir filename '.phase3.c.txt']);
    esty1_others = load([input_dir filename '.phase1.bc.txt']);
    esty2_others = load([input_dir filename '.phase2.ac.txt']);
    esty3_others = load([input_dir filename '.phase3.ab.txt']);

end


function plot_coauthor(input_dir, fig_dir, font_size, legends, colors)
    %% ---------------------------
    %% Coauthor
    filename = 'fit_auto.publications.num_coauthor_all_authors';
    [data, param, esty1, esty2, esty3, esty1_others, esty2_others, esty3_others] = get_data(input_dir, filename);

    fh = figure(1); clf;
    lhs(1) = plot(data(:,1), data(:,2), 'bo');
    set(lhs(1), 'MarkerSize', 15);

    set(gca, 'FontSize', font_size);
    % title(sprintf('L=%d,U=%d,exponent=%.2f', L, U, exponent));
    xlabel('Number of Coauthor', 'FontSize', font_size);
    ylabel('Probability', 'FontSize', font_size);

    set(gca, 'xscale', 'log');
    set(gca, 'yscale', 'log');
    x = data(:,1);
    y = data(:,2);
    set(gca, 'xlim', [min(x(x>0)) max(x)*1.1]);
    set(gca, 'ylim', [min(y(y>0)) max(y)*1.1]);
    set(gca, 'XTick', 10.^[-20:20]);
    set(gca, 'YTick', 10.^[-20:0]);

    figname = strrep(filename, '.', '-');
    % print(fh, '-dpsc', sprintf('%s%s.eps', fig_dir, figname));
    print(fh, '-dpng', sprintf('%s%s.png', fig_dir, figname));
    % input('')
end


function plot_dblp(input_dir, fig_dir, font_size, legends, colors)
    %% ---------------------------
    %% DBLP
    filename = 'fit_auto.publications.num_cite_all_papers';
    [data, param, esty1, esty2, esty3, esty1_others, esty2_others, esty3_others] = get_data(input_dir, filename);

    fh = figure(1); clf;
    lhs(1) = plot(data(:,1), data(:,2), 'bo');
    set(lhs(1), 'MarkerSize', 15);

    set(gca, 'FontSize', font_size);
    % title(sprintf('L=%d,U=%d,exponent=%.2f', L, U, exponent));
    xlabel('Number of Citation', 'FontSize', font_size);
    ylabel('Probability', 'FontSize', font_size);

    set(gca, 'xscale', 'log');
    set(gca, 'yscale', 'log');
    x = data(:,1);
    y = data(:,2);
    set(gca, 'xlim', [min(x(x>0)) max(x)*1.1]);
    set(gca, 'ylim', [min(y(y>0)) max(y)*1.1]);
    set(gca, 'XTick', 10.^[-20:20]);
    set(gca, 'YTick', 10.^[-20:0]);

    figname = strrep(filename, '.', '-');
    % print(fh, '-dpsc', sprintf('%s%s.eps', fig_dir, figname));
    print(fh, '-dpng', sprintf('%s%s.png', fig_dir, figname));
    % input('')
end


function plot_coauthor_network(input_dir, fig_dir, font_size, legends, colors)
    %% ---------------------------
    %% Coauthor - Networking
    filename = 'fit_auto.networks.num_coauthor_all_authors';
    [data, param, esty1, esty2, esty3, esty1_others, esty2_others, esty3_others] = get_data(input_dir, filename);

    fh = figure(1); clf;
    lhs(1) = plot(data(:,1), data(:,2), 'bo');
    set(lhs(1), 'MarkerSize', 15);

    set(gca, 'FontSize', font_size);
    % title(sprintf('L=%d,U=%d,exponent=%.2f', L, U, exponent));
    xlabel('Number of Coauthor', 'FontSize', font_size);
    ylabel('Probability', 'FontSize', font_size);

    set(gca, 'xscale', 'log');
    set(gca, 'yscale', 'log');
    x = data(:,1);
    y = data(:,2);
    set(gca, 'xlim', [min(x(x>0)) max(x)*1.1]);
    set(gca, 'ylim', [min(y(y>0)) max(y)*1.1]);
    set(gca, 'XTick', 10.^[-20:20]);
    set(gca, 'YTick', 10.^[-20:0]);

    figname = strrep(filename, '.', '-');
    % print(fh, '-dpsc', sprintf('%s%s.eps', fig_dir, figname));
    print(fh, '-dpng', sprintf('%s%s.png', fig_dir, figname));
end

function plot_dblp_network(input_dir, fig_dir, font_size, legends, colors)
    %% ---------------------------
    %% DBLP - Networking
    filename = 'fit_auto.networks.num_cite_all_papers';
    [data, param, esty1, esty2, esty3, esty1_others, esty2_others, esty3_others] = get_data(input_dir, filename);

    fh = figure(1); clf;
    lhs(1) = plot(data(:,1), data(:,2), 'bo');
    set(lhs(1), 'MarkerSize', 15);

    set(gca, 'FontSize', font_size);
    % title(sprintf('L=%d,U=%d,exponent=%.2f', L, U, exponent));
    xlabel('Number of Citation', 'FontSize', font_size);
    ylabel('Probability', 'FontSize', font_size);

    set(gca, 'xscale', 'log');
    set(gca, 'yscale', 'log');
    x = data(:,1);
    y = data(:,2);
    set(gca, 'xlim', [min(x(x>0)) max(x)*1.1]);
    set(gca, 'ylim', [min(y(y>0)) max(y)*1.1]);
    set(gca, 'XTick', 10.^[-20:20]);
    set(gca, 'YTick', 10.^[-20:0]);

    figname = strrep(filename, '.', '-');
    % print(fh, '-dpsc', sprintf('%s%s.eps', fig_dir, figname));
    print(fh, '-dpng', sprintf('%s%s.png', fig_dir, figname));
end


function plot_aps(input_dir, fig_dir, font_size, legends, colors)
    %% ---------------------------
    %% APS
    filename = 'fit_auto.aps-dataset-citations-2013';
    [data, param, esty1, esty2, esty3, esty1_others, esty2_others, esty3_others] = get_data(input_dir, filename);

    fh = figure(1); clf;
    lhs(1) = plot(data(:,1), data(:,2), 'bo');
    set(lhs(1), 'MarkerSize', 15);

    set(gca, 'FontSize', font_size);
    % title(sprintf('L=%d,U=%d,exponent=%.2f', L, U, exponent));
    xlabel('Number of Citation', 'FontSize', font_size);
    ylabel('Probability', 'FontSize', font_size);

    set(gca, 'xscale', 'log');
    set(gca, 'yscale', 'log');
    x = data(:,1);
    y = data(:,2);
    set(gca, 'xlim', [min(x(x>0)) max(x)*1.4]);
    set(gca, 'ylim', [min(y(y>0)) max(y)*1.1]);
    set(gca, 'XTick', 10.^[-20:20]);
    set(gca, 'YTick', 10.^[-20:0]);
    % xtics = get(gca,'XTick');
    % set(gca,'XTickLabel',sprintf('%d|',xtics));

    figname = strrep(filename, '.', '-');
    % print(fh, '-dpsc', sprintf('%s%s.eps', fig_dir, figname));
    print(fh, '-dpng', sprintf('%s%s.png', fig_dir, figname));
end

function plot_patent(input_dir, fig_dir, font_size, legends, colors)
    %% ---------------------------
    %% US Patent
    filename = 'fit_auto.cit-Patents';
    [data, param, esty1, esty2, esty3, esty1_others, esty2_others, esty3_others] = get_data(input_dir, filename);

    fh = figure(1); clf;
    lhs(1) = plot(data(:,1), data(:,2), 'bo');
    set(lhs(1), 'MarkerSize', 15);

    set(gca, 'FontSize', font_size);
    % title(sprintf('L=%d,U=%d,exponent=%.2f', L, U, exponent));
    xlabel('Number of Citation', 'FontSize', font_size);
    ylabel('Probability', 'FontSize', font_size);

    set(gca, 'xscale', 'log');
    set(gca, 'yscale', 'log');
    x = data(:,1);
    y = data(:,2);
    set(gca, 'xlim', [min(x(x>0)) max(x)*1.1]);
    set(gca, 'ylim', [min(y(y>0)) max(y)*1.1]);
    set(gca, 'XTick', 10.^[-20:20]);
    set(gca, 'YTick', 10.^[-20:0]);

    figname = strrep(filename, '.', '-');
    % print(fh, '-dpsc', sprintf('%s%s.eps', fig_dir, figname));
    print(fh, '-dpng', sprintf('%s%s.png', fig_dir, figname));
end


function plot_facebook(input_dir, fig_dir, font_size, legends, colors)
    %% ---------------------------
    %% Facebook
    filename = 'fit_auto.facebook_combined';
    [data, param, esty1, esty2, esty3, esty1_others, esty2_others, esty3_others] = get_data(input_dir, filename);

    fh = figure(1); clf;
    lhs(1) = plot(data(:,1), data(:,2), 'bo');
    set(lhs(1), 'MarkerSize', 15);

    set(gca, 'FontSize', font_size);
    % title(sprintf('L=%d,U=%d,exponent=%.2f', L, U, exponent));
    xlabel('Number of Friend', 'FontSize', font_size);
    ylabel('Probability', 'FontSize', font_size);

    set(gca, 'xscale', 'log');
    set(gca, 'yscale', 'log');
    x = data(:,1);
    y = data(:,2);
    set(gca, 'xlim', [min(x(x>0)) max(x)*1.3]);
    set(gca, 'ylim', [min(y(y>0)) max(y)*1.1]);
    set(gca, 'XTick', 10.^[-20:20]);
    % set(gca, 'XTick', [1 2 4 6 10 20 40 100]);
    set(gca, 'YTick', 10.^[-20:0]);

    figname = strrep(filename, '.', '-');
    % print(fh, '-dpsc', sprintf('%s%s.eps', fig_dir, figname));
    print(fh, '-dpng', sprintf('%s%s.png', fig_dir, figname));
end


function plot_twitter(input_dir, fig_dir, font_size, legends, colors)
    %% ---------------------------
    %% Twitter
    filename = 'fit_auto.twitter_combined';
    [data, param, esty1, esty2, esty3, esty1_others, esty2_others, esty3_others] = get_data(input_dir, filename);

    fh = figure(1); clf;
    lhs(1) = plot(data(:,1), data(:,2), 'bo');
    set(lhs(1), 'MarkerSize', 15);

    set(gca, 'FontSize', font_size);
    % title(sprintf('L=%d,U=%d,exponent=%.2f', L, U, exponent));
    xlabel('Number of Follow', 'FontSize', font_size);
    ylabel('Probability', 'FontSize', font_size);

    set(gca, 'xscale', 'log');
    set(gca, 'yscale', 'log');
    x = data(:,1);
    y = data(:,2);
    set(gca, 'xlim', [min(x(x>0)) max(x)*1.1]);
    set(gca, 'ylim', [min(y(y>0)) max(y)*1.1]);
    set(gca, 'XTick', 10.^[-20:20]);
    set(gca, 'YTick', 10.^[-20:0]);

    figname = strrep(filename, '.', '-');
    % print(fh, '-dpsc', sprintf('%s%s.eps', fig_dir, figname));
    print(fh, '-dpng', sprintf('%s%s.png', fig_dir, figname));
end


function plot_rome(input_dir, fig_dir, font_size, legends, colors)
    %% ---------------------------
    %% Rome - Contact Count
    filename = 'fit_auto.rome_taxi.counts.120.1000';
    [data, param, esty1, esty2, esty3, esty1_others, esty2_others, esty3_others] = get_data(input_dir, filename);

    fh = figure(1); clf;
    lhs(1) = plot(data(:,1), data(:,2), 'bo');
    set(lhs(1), 'MarkerSize', 15);

    set(gca, 'FontSize', font_size);
    % title(sprintf('L=%d,U=%d,exponent=%.2f', L, U, exponent));
    xlabel('Contact Count', 'FontSize', font_size);
    ylabel('Probability', 'FontSize', font_size);

    set(gca, 'xscale', 'log');
    set(gca, 'yscale', 'log');
    x = data(:,1);
    y = data(:,2);
    set(gca, 'xlim', [min(x(x>0)) max(x)*1.1]);
    set(gca, 'ylim', [min(y(y>0)) max(y)*1.1]);
    set(gca, 'XTick', [1 2 4 6 10 20 40]);
    set(gca, 'YTick', 10.^[-20:0]);

    figname = strrep(filename, '.', '-');
    % print(fh, '-dpsc', sprintf('%s%s.eps', fig_dir, figname));
    print(fh, '-dpng', sprintf('%s%s.png', fig_dir, figname));
end


function plot_beijing(input_dir, fig_dir, font_size, legends, colors)
    %% ---------------------------
    %% Beijing - Contact Count
    filename = 'fit_auto.beijing_taxi.counts.300.300';
    [data, param, esty1, esty2, esty3, esty1_others, esty2_others, esty3_others] = get_data(input_dir, filename);

    fh = figure(1); clf;
    lhs(1) = plot(data(:,1), data(:,2), 'bo');
    set(lhs(1), 'MarkerSize', 15);

    set(gca, 'FontSize', font_size);
    % title(sprintf('L=%d,U=%d,exponent=%.2f', L, U, exponent));
    xlabel('Contact Count', 'FontSize', font_size);
    ylabel('Probability', 'FontSize', font_size);

    set(gca, 'xscale', 'log');
    set(gca, 'yscale', 'log');
    x = data(:,1);
    y = data(:,2);
    set(gca, 'xlim', [min(x(x>0)) max(x)*1.1]);
    set(gca, 'ylim', [min(y(y>0)) max(y)*1.1]);
    % set(gca, 'XTick', 10.^[-20:20]);
    set(gca, 'XTick', [1 2 4 6 10 20 40 100]);
    set(gca, 'YTick', 10.^[-20:0]);

    figname = strrep(filename, '.', '-');
    % print(fh, '-dpsc', sprintf('%s%s.eps', fig_dir, figname));
    print(fh, '-dpng', sprintf('%s%s.png', fig_dir, figname));
end


function plot_sf(input_dir, fig_dir, font_size, legends, colors)
    %% ---------------------------
    %% SF - Contact Count
    filename = 'fit_auto.sf_taxi.counts.120.1000';
    [data, param, esty1, esty2, esty3, esty1_others, esty2_others, esty3_others] = get_data(input_dir, filename);

    fh = figure(1); clf;
    lhs(1) = plot(data(:,1), data(:,2), 'bo');
    set(lhs(1), 'MarkerSize', 15);

    set(gca, 'FontSize', font_size);
    % title(sprintf('L=%d,U=%d,exponent=%.2f', L, U, exponent));
    xlabel('Contact Count', 'FontSize', font_size);
    ylabel('Probability', 'FontSize', font_size);

    set(gca, 'xscale', 'log');
    set(gca, 'yscale', 'log');
    x = data(:,1);
    y = data(:,2);
    set(gca, 'xlim', [min(x(x>0)) max(x)*1.1]);
    set(gca, 'ylim', [min(y(y>0)) max(y)*1.1]);
    set(gca, 'XTick', [1 2 4 6 10 20 40 100 200]);
    set(gca, 'YTick', 10.^[-20:0]);

    figname = strrep(filename, '.', '-');
    % print(fh, '-dpsc', sprintf('%s%s.eps', fig_dir, figname));
    print(fh, '-dpng', sprintf('%s%s.png', fig_dir, figname));
end
