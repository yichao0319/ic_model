function plot_3seg_curve(x, y, L, U, fit_curve, ok, xseg, yseg, fig_idx, atitle, font_size, filename, input_dir, fig_dir, prefix)

    figname = get_figname(filename, input_dir, fig_dir, prefix);
    [x_ticks, y_ticks, x_label, y_label] = get_plot_param(filename, input_dir, prefix);
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
    % if 0
        % lh = plot(xseg{1}, yseg{1}, '-g');
        % lh = plot(fit_curve{1});
        lh = plot(xseg{1}, fit_curve{1}(xseg{1}));
        set(lh, 'Color', [0 0.8 0]);
        set(lh, 'LineStyle', '-');
        set(lh, 'LineWidth', 2);
        % legends{end+1} = 'phase1';
        legends{end+1} = ' geometric';
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
        % legends{end+1} = 'phase2';
        legends{end+1} = ' power law';
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

    % if ok(3)
    if 0
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
    % legend(lhs, legends);
    legend(lhs, legends, 'Location', 'SouthWest');
    % legendflex(lhs, legends, 'ref', gcf, ... 
    %                         'xscale', 2, ...
    %                         'anchor', {'sw','sw'}, ...
    %                         'nrow', 1);
    % gridLegend(lhs, 3, legends, 'Location', 'SouthWest');
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


function figname = get_figname(filename, input_dir, fig_dir, prefix)
    if findstr(input_dir, 'rome_taxi')
        figname = [fig_dir prefix '.rome_taxi.' filename];
    elseif findstr(input_dir, 'shanghai_bus')
        figname = [fig_dir prefix '.shanghai_bus.' filename];
    elseif findstr(input_dir, 'shanghai_taxi')
        figname = [fig_dir prefix '.shanghai_taxi.' filename];
    elseif findstr(input_dir, 'beijing_taxi')
        figname = [fig_dir prefix '.beijing_taxi.' filename];
    elseif findstr(input_dir, 'sf_taxi')
        figname = [fig_dir prefix '.sf_taxi.' filename];
    elseif findstr(input_dir, 'seattle_bus')
        figname = [fig_dir prefix '.seattle_bus.' filename];
    else
        figname = [fig_dir prefix '.' filename];
    end
end

function [x_ticks, y_ticks, x_label, y_label] = get_plot_param(filename, input_dir, prefix)
    if nargin < 2, input_dir = './'; end

    x_ticks = [];
    y_ticks = [];
    x_label = '';
    y_label = '';
    

    if findstr(prefix, 'fit_manual')
        if strcmp(filename, 'publications.num_cite_all_papers')
            % y_ticks = 10 .^ [0:5];
            x_label = 'Citation Count x';
            y_label = 'Number of Papers';
        elseif strcmp(filename, 'ai.num_cite_all_papers')
            x_label = 'Citation Count x';
            y_label = 'Number of Papers';
        elseif strcmp(filename, 'networks.num_cite_all_papers')
            x_label = 'Citation Count x';
            y_label = 'Number of Papers';
        elseif strcmp(filename, 'publications.num_coauthor_all_authors')
            % x_ticks = 10 .^ [0:3];
            % y_ticks = 10 .^ [0:7];
            x_label = 'Coauthor Count x';
            y_label = 'Nummber of Scientists';
        elseif strcmp(filename, 'ai.num_coauthor_all_authors')
            x_label = 'Coauthor Count x';
            y_label = 'Nummber of Scientists';
        elseif strcmp(filename, 'networks.num_coauthor_all_authors')
            x_label = 'Coauthor Count x';
            y_label = 'Nummber of Scientists';
        elseif strcmp(filename, 'range100.contact_dur') & length(findstr(input_dir, 'rome_taxi'))>0
            x_label = 'Contact Duration (s)';
            y_label = 'Number of Contacts';
        elseif strcmp(filename, 'range200.contact_dur') & length(findstr(input_dir, 'rome_taxi'))>0
            x_label = 'Contact Duration (s)';
            y_label = 'Number of Contacts';
        elseif strcmp(filename, 'range100.contact_dur') & length(findstr(input_dir, 'shanghai_bus'))>0
            x_label = 'Contact Duration (s)';
            y_label = 'Number of Contacts';
        elseif strcmp(filename, 'range200.contact_dur') & length(findstr(input_dir, 'shanghai_bus'))>0
            x_label = 'Contact Duration (s)';
            y_label = 'Number of Contacts';
        elseif strcmp(filename, 'facebook_combined')
            x_label = 'Friend Count x';
            y_label = 'Number of Users';
        elseif strcmp(filename, 'twitter_combined')
            x_label = 'Following People Count x';
            y_label = 'Number of Users';
        elseif strcmp(filename, 'cit-Patents')
            x_label = 'Citation Count x';
            y_label = 'Number of Patents';
        elseif strcmp(filename, 'aps-dataset-citations-2013')
            x_label = 'Citation Count x';
            y_label = 'Number of Papers';
        elseif length(findstr(input_dir, 'beijing_taxi'))>0 & length(findstr(filename, 'counts'))>0
            x_ticks = 10 .^ [0:2];
            x_label = 'Contact Count x';
            y_label = 'Number of Vehicles';
        elseif length(findstr(input_dir, 'sf_taxi'))>0 & length(findstr(filename, 'counts'))>0
            x_label = 'Contact Count x';
            y_label = 'Number of Vehicles';
        elseif length(findstr(input_dir, 'rome_taxi'))>0 & length(findstr(filename, 'counts'))>0
            x_label = 'Contact Count x';
            y_label = 'Number of Vehicles';
        elseif length(findstr(input_dir, 'shanghai_taxi'))>0 & length(findstr(filename, 'counts'))>0
            x_label = 'Contact Count x';
            y_label = 'Number of Vehicles';
        end
        y_label = 'Frequency';
    
    %% rank-freq
    elseif findstr(prefix, 'fit_rank')
        if strcmp(filename, 'publications.num_cite_all_papers')
            x_ticks = 10 .^ [0:7];
            x_label = 'Rank n';
            y_label = 'Citation Frequency';
        elseif strcmp(filename, 'publications.num_coauthor_all_authors')
            x_ticks = 10 .^ [0:6];
            x_label = 'Rank n';
            y_label = 'Coauthor Frequency';
        end
    else
        error(['wrong prefix: ' prefix]);
    end
end