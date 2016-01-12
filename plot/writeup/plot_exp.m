function plot_exp
    input_dir = './data/exp/';
    fig_dir   = './fig/';
    font_size = 22;
    legends = {'Empirical Data', 'MC:Geom($\frac{\gamma}{\gamma+L}$)', 'MC:Power-Low', 'MC:Geom($\frac{\gamma}{\gamma+U}$)'};

    %% ---------------------------
    %% Coauthor
    filename = 'fit_auto.publications.num_coauthor_all_authors';
    [data, param, esty1, esty2, esty3, esty1_others, esty2_others, esty3_others] = get_data(input_dir, filename);

    fh = figure(1); clf;
    lhs(1) = plot(data(:,1), data(:,2), 'bo');
    set(lhs(1), 'MarkerSize', 15);
    hold on;
    lhs(2) = plot(esty1(:,1), esty1(:,2), '-g');
    set(lhs(2), 'LineWidth', 3);
    lhs(3) = plot(esty2(:,1), esty2(:,2), '-r');
    set(lhs(3), 'LineWidth', 4);
    lhs(4) = plot(esty3(:,1), esty3(:,2), '-m');
    set(lhs(4), 'LineWidth', 5);

    lh = plot(esty1_others(:,1), esty1_others(:,2), '--g');
    set(lh, 'LineWidth', 2);
    lh = plot(esty2_others(:,1), esty2_others(:,2), '--r');
    set(lh, 'LineWidth', 2);
    lh = plot(esty3_others(:,1), esty3_others(:,2), '--m');
    set(lh, 'LineWidth', 2);

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
    set(gca, 'YTick', 10.^[-20:0]);

    h = legend(lhs, legends);
    set(h, 'Interpreter', 'latex');
    leg_pos = get(h, 'position');
    set(h, 'position',[leg_pos(1)*0.95,leg_pos(2),...
                      leg_pos(3)*1.1,leg_pos(4)]);

    figname = strrep(filename, '.', '-');
    print(fh, '-dpsc', sprintf('%s%s.eps', fig_dir, figname));
    % input('')

    %% ---------------------------
    %% DBLP
    filename = 'fit_auto.publications.num_cite_all_papers';
    [data, param, esty1, esty2, esty3, esty1_others, esty2_others, esty3_others] = get_data(input_dir, filename);
    
    fh = figure(1); clf;
    lhs(1) = plot(data(:,1), data(:,2), 'bo');
    set(lhs(1), 'MarkerSize', 15);
    hold on;
    lhs(2) = plot(esty1(:,1), esty1(:,2), '-g');
    set(lhs(2), 'LineWidth', 3);
    lhs(3) = plot(esty2(:,1), esty2(:,2), '-r');
    set(lhs(3), 'LineWidth', 4);
    lhs(4) = plot(esty3(:,1), esty3(:,2), '-m');
    set(lhs(4), 'LineWidth', 5);

    lh = plot(esty1_others(:,1), esty1_others(:,2), '--g');
    set(lh, 'LineWidth', 2);
    lh = plot(esty2_others(:,1), esty2_others(:,2), '--r');
    set(lh, 'LineWidth', 2);
    lh = plot(esty3_others(:,1), esty3_others(:,2), '--m');
    set(lh, 'LineWidth', 2);

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
    set(gca, 'YTick', 10.^[-20:0]);

    h = legend(lhs, legends);
    set(h, 'Interpreter', 'latex');
    leg_pos = get(h, 'position');
    set(h, 'position',[leg_pos(1)*0.95,leg_pos(2),...
                      leg_pos(3)*1.1,leg_pos(4)]);

    figname = strrep(filename, '.', '-');
    print(fh, '-dpsc', sprintf('%s%s.eps', fig_dir, figname));
    % input('')

    %% ---------------------------
    %% Coauthor - Networking
    filename = 'fit_auto.networks.num_coauthor_all_authors';
    [data, param, esty1, esty2, esty3, esty1_others, esty2_others, esty3_others] = get_data(input_dir, filename);
    
    fh = figure(1); clf;
    lhs(1) = plot(data(:,1), data(:,2), 'bo');
    set(lhs(1), 'MarkerSize', 15);
    hold on;
    lhs(2) = plot(esty1(:,1), esty1(:,2), '-g');
    set(lhs(2), 'LineWidth', 3);
    lhs(3) = plot(esty2(:,1), esty2(:,2), '-r');
    set(lhs(3), 'LineWidth', 4);
    lhs(4) = plot(esty3(:,1), esty3(:,2), '-m');
    set(lhs(4), 'LineWidth', 5);

    lh = plot(esty1_others(:,1), esty1_others(:,2), '--g');
    set(lh, 'LineWidth', 2);
    lh = plot(esty2_others(:,1), esty2_others(:,2), '--r');
    set(lh, 'LineWidth', 2);
    lh = plot(esty3_others(:,1), esty3_others(:,2), '--m');
    set(lh, 'LineWidth', 2);

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
    set(gca, 'YTick', 10.^[-20:0]);

    h = legend(lhs, legends);
    set(h, 'Interpreter', 'latex');
    leg_pos = get(h, 'position');
    set(h, 'position',[leg_pos(1)*0.95,leg_pos(2),...
                      leg_pos(3)*1.1,leg_pos(4)]);

    figname = strrep(filename, '.', '-');
    print(fh, '-dpsc', sprintf('%s%s.eps', fig_dir, figname));

    %% ---------------------------
    %% DBLP - Networking
    filename = 'fit_auto.networks.num_cite_all_papers';
    [data, param, esty1, esty2, esty3, esty1_others, esty2_others, esty3_others] = get_data(input_dir, filename);
    
    fh = figure(1); clf;
    lhs(1) = plot(data(:,1), data(:,2), 'bo');
    set(lhs(1), 'MarkerSize', 15);
    hold on;
    lhs(2) = plot(esty1(:,1), esty1(:,2), '-g');
    set(lhs(2), 'LineWidth', 3);
    lhs(3) = plot(esty2(:,1), esty2(:,2), '-r');
    set(lhs(3), 'LineWidth', 4);
    lhs(4) = plot(esty3(:,1), esty3(:,2), '-m');
    set(lhs(4), 'LineWidth', 5);

    lh = plot(esty1_others(:,1), esty1_others(:,2), '--g');
    set(lh, 'LineWidth', 2);
    lh = plot(esty2_others(:,1), esty2_others(:,2), '--r');
    set(lh, 'LineWidth', 2);
    lh = plot(esty3_others(:,1), esty3_others(:,2), '--m');
    set(lh, 'LineWidth', 2);

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

    h = legend(lhs, legends);
    set(h, 'Interpreter', 'latex');
    leg_pos = get(h, 'position');
    set(h, 'position',[leg_pos(1)*0.95,leg_pos(2),...
                      leg_pos(3)*1.1,leg_pos(4)]);

    figname = strrep(filename, '.', '-');
    print(fh, '-dpsc', sprintf('%s%s.eps', fig_dir, figname));

    %% ---------------------------
    %% APS
    filename = 'fit_auto.aps-dataset-citations-2013';
    [data, param, esty1, esty2, esty3, esty1_others, esty2_others, esty3_others] = get_data(input_dir, filename);
    
    fh = figure(1); clf;
    lhs(1) = plot(data(:,1), data(:,2), 'bo');
    set(lhs(1), 'MarkerSize', 15);
    hold on;
    lhs(2) = plot(esty1(:,1), esty1(:,2), '-g');
    set(lhs(2), 'LineWidth', 3);
    lhs(3) = plot(esty2(:,1), esty2(:,2), '-r');
    set(lhs(3), 'LineWidth', 4);
    lhs(4) = plot(esty3(:,1), esty3(:,2), '-m');
    set(lhs(4), 'LineWidth', 5);

    lh = plot(esty1_others(:,1), esty1_others(:,2), '--g');
    set(lh, 'LineWidth', 2);
    lh = plot(esty2_others(:,1), esty2_others(:,2), '--r');
    set(lh, 'LineWidth', 2);
    lh = plot(esty3_others(:,1), esty3_others(:,2), '--m');
    set(lh, 'LineWidth', 2);

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

    h = legend(lhs, legends);
    set(h, 'Interpreter', 'latex');
    leg_pos = get(h, 'position');
    set(h, 'position',[leg_pos(1)*0.95,leg_pos(2),...
                      leg_pos(3)*1.1,leg_pos(4)]);

    figname = strrep(filename, '.', '-');
    print(fh, '-dpsc', sprintf('%s%s.eps', fig_dir, figname));

    %% ---------------------------
    %% US Patent
    filename = 'fit_auto.cit-Patents';
    [data, param, esty1, esty2, esty3, esty1_others, esty2_others, esty3_others] = get_data(input_dir, filename);
    
    fh = figure(1); clf;
    lhs(1) = plot(data(:,1), data(:,2), 'bo');
    set(lhs(1), 'MarkerSize', 15);
    hold on;
    lhs(2) = plot(esty1(:,1), esty1(:,2), '-g');
    set(lhs(2), 'LineWidth', 3);
    lhs(3) = plot(esty2(:,1), esty2(:,2), '-r');
    set(lhs(3), 'LineWidth', 4);
    lhs(4) = plot(esty3(:,1), esty3(:,2), '-m');
    set(lhs(4), 'LineWidth', 5);

    lh = plot(esty1_others(:,1), esty1_others(:,2), '--g');
    set(lh, 'LineWidth', 2);
    lh = plot(esty2_others(:,1), esty2_others(:,2), '--r');
    set(lh, 'LineWidth', 2);
    lh = plot(esty3_others(:,1), esty3_others(:,2), '--m');
    set(lh, 'LineWidth', 2);

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

    h = legend(lhs, legends);
    set(h, 'Interpreter', 'latex');
    leg_pos = get(h, 'position');
    set(h, 'position',[leg_pos(1)*0.95,leg_pos(2),...
                      leg_pos(3)*1.1,leg_pos(4)]);

    figname = strrep(filename, '.', '-');
    print(fh, '-dpsc', sprintf('%s%s.eps', fig_dir, figname));

    %% ---------------------------
    %% Facebook 
    filename = 'fit_auto.facebook_combined';
    [data, param, esty1, esty2, esty3, esty1_others, esty2_others, esty3_others] = get_data(input_dir, filename);
    
    fh = figure(1); clf;
    lhs(1) = plot(data(:,1), data(:,2), 'bo');
    set(lhs(1), 'MarkerSize', 15);
    hold on;
    lhs(2) = plot(esty1(:,1), esty1(:,2), '-g');
    set(lhs(2), 'LineWidth', 3);
    lhs(3) = plot(esty2(:,1), esty2(:,2), '-r');
    set(lhs(3), 'LineWidth', 4);
    lhs(4) = plot(esty3(:,1), esty3(:,2), '-m');
    set(lhs(4), 'LineWidth', 5);

    lh = plot(esty1_others(:,1), esty1_others(:,2), '--g');
    set(lh, 'LineWidth', 2);
    lh = plot(esty2_others(:,1), esty2_others(:,2), '--r');
    set(lh, 'LineWidth', 2);
    lh = plot(esty3_others(:,1), esty3_others(:,2), '--m');
    set(lh, 'LineWidth', 2);

    set(gca, 'FontSize', font_size);
    % title(sprintf('L=%d,U=%d,exponent=%.2f', L, U, exponent));
    xlabel('Number of Friend', 'FontSize', font_size);
    ylabel('Probability', 'FontSize', font_size);

    set(gca, 'xscale', 'log');
    set(gca, 'yscale', 'log');
    x = data(:,1);
    y = data(:,2);
    set(gca, 'xlim', [min(x(x>0)) max(x)*1.1]);
    set(gca, 'ylim', [min(y(y>0)) max(y)*1.1]);

    h = legend(lhs, legends);
    set(h, 'Interpreter', 'latex');
    leg_pos = get(h, 'position');
    set(h, 'position',[leg_pos(1)*0.95,leg_pos(2),...
                      leg_pos(3)*1.1,leg_pos(4)]);

    figname = strrep(filename, '.', '-');
    print(fh, '-dpsc', sprintf('%s%s.eps', fig_dir, figname));

    %% ---------------------------
    %% Twitter
    filename = 'fit_auto.twitter_combined';
    [data, param, esty1, esty2, esty3, esty1_others, esty2_others, esty3_others] = get_data(input_dir, filename);
    
    fh = figure(1); clf;
    lhs(1) = plot(data(:,1), data(:,2), 'bo');
    set(lhs(1), 'MarkerSize', 15);
    hold on;
    lhs(2) = plot(esty1(:,1), esty1(:,2), '-g');
    set(lhs(2), 'LineWidth', 3);
    lhs(3) = plot(esty2(:,1), esty2(:,2), '-r');
    set(lhs(3), 'LineWidth', 4);
    lhs(4) = plot(esty3(:,1), esty3(:,2), '-m');
    set(lhs(4), 'LineWidth', 5);

    lh = plot(esty1_others(:,1), esty1_others(:,2), '--g');
    set(lh, 'LineWidth', 2);
    lh = plot(esty2_others(:,1), esty2_others(:,2), '--r');
    set(lh, 'LineWidth', 2);
    lh = plot(esty3_others(:,1), esty3_others(:,2), '--m');
    set(lh, 'LineWidth', 2);

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

    h = legend(lhs, legends);
    set(h, 'Interpreter', 'latex');
    leg_pos = get(h, 'position');
    set(h, 'position',[leg_pos(1)*0.95,leg_pos(2),...
                      leg_pos(3)*1.1,leg_pos(4)]);

    figname = strrep(filename, '.', '-');
    print(fh, '-dpsc', sprintf('%s%s.eps', fig_dir, figname));

    %% ---------------------------
    %% Rome - Contact Count
    filename = 'fit_auto.rome_taxi.counts.120.1000';
    [data, param, esty1, esty2, esty3, esty1_others, esty2_others, esty3_others] = get_data(input_dir, filename);
    
    fh = figure(1); clf;
    lhs(1) = plot(data(:,1), data(:,2), 'bo');
    set(lhs(1), 'MarkerSize', 15);
    hold on;
    lhs(2) = plot(esty1(:,1), esty1(:,2), '-g');
    set(lhs(2), 'LineWidth', 3);
    lhs(3) = plot(esty2(:,1), esty2(:,2), '-r');
    set(lhs(3), 'LineWidth', 4);
    lhs(4) = plot(esty3(:,1), esty3(:,2), '-m');
    set(lhs(4), 'LineWidth', 5);

    lh = plot(esty1_others(:,1), esty1_others(:,2), '--g');
    set(lh, 'LineWidth', 2);
    lh = plot(esty2_others(:,1), esty2_others(:,2), '--r');
    set(lh, 'LineWidth', 2);
    lh = plot(esty3_others(:,1), esty3_others(:,2), '--m');
    set(lh, 'LineWidth', 2);

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

    h = legend(lhs, legends, 'location', 'southwest');
    set(h, 'Interpreter', 'latex');
    leg_pos = get(h, 'position');
    set(h, 'position',[leg_pos(1)*1.3,leg_pos(2),...
                      leg_pos(3)*1.1,leg_pos(4)]);

    figname = strrep(filename, '.', '-');
    print(fh, '-dpsc', sprintf('%s%s.eps', fig_dir, figname));

    %% ---------------------------
    %% Beijing - Contact Count
    filename = 'fit_auto.beijing_taxi.counts.300.300';
    [data, param, esty1, esty2, esty3, esty1_others, esty2_others, esty3_others] = get_data(input_dir, filename);
    
    fh = figure(1); clf;
    lhs(1) = plot(data(:,1), data(:,2), 'bo');
    set(lhs(1), 'MarkerSize', 15);
    hold on;
    lhs(2) = plot(esty1(:,1), esty1(:,2), '-g');
    set(lhs(2), 'LineWidth', 3);
    lhs(3) = plot(esty2(:,1), esty2(:,2), '-r');
    set(lhs(3), 'LineWidth', 4);
    lhs(4) = plot(esty3(:,1), esty3(:,2), '-m');
    set(lhs(4), 'LineWidth', 5);

    lh = plot(esty1_others(:,1), esty1_others(:,2), '--g');
    set(lh, 'LineWidth', 2);
    lh = plot(esty2_others(:,1), esty2_others(:,2), '--r');
    set(lh, 'LineWidth', 2);
    lh = plot(esty3_others(:,1), esty3_others(:,2), '--m');
    set(lh, 'LineWidth', 2);

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

    h = legend(lhs, legends, 'location', 'southwest');
    set(h, 'Interpreter', 'latex');
    leg_pos = get(h, 'position');
    set(h, 'position',[leg_pos(1)*1.3,leg_pos(2),...
                      leg_pos(3)*1.1,leg_pos(4)]);

    figname = strrep(filename, '.', '-');
    print(fh, '-dpsc', sprintf('%s%s.eps', fig_dir, figname));

    %% ---------------------------
    %% SF - Contact Count
    filename = 'fit_auto.sf_taxi.counts.120.1000';
    [data, param, esty1, esty2, esty3, esty1_others, esty2_others, esty3_others] = get_data(input_dir, filename);
    
    fh = figure(1); clf;
    lhs(1) = plot(data(:,1), data(:,2), 'bo');
    set(lhs(1), 'MarkerSize', 15);
    hold on;
    lhs(2) = plot(esty1(:,1), esty1(:,2), '-g');
    set(lhs(2), 'LineWidth', 3);
    lhs(3) = plot(esty2(:,1), esty2(:,2), '-r');
    set(lhs(3), 'LineWidth', 4);
    lhs(4) = plot(esty3(:,1), esty3(:,2), '-m');
    set(lhs(4), 'LineWidth', 5);

    lh = plot(esty1_others(:,1), esty1_others(:,2), '--g');
    set(lh, 'LineWidth', 2);
    lh = plot(esty2_others(:,1), esty2_others(:,2), '--r');
    set(lh, 'LineWidth', 2);
    lh = plot(esty3_others(:,1), esty3_others(:,2), '--m');
    set(lh, 'LineWidth', 2);

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

    h = legend(lhs, legends, 'location', 'southwest');
    set(h, 'Interpreter', 'latex');
    leg_pos = get(h, 'position');
    set(h, 'position',[leg_pos(1)*1.3,leg_pos(2),...
                      leg_pos(3)*1.1,leg_pos(4)]);

    figname = strrep(filename, '.', '-');
    print(fh, '-dpsc', sprintf('%s%s.eps', fig_dir, figname));
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