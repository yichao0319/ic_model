function plot_fit(x, y, k, l, fit_y_old, fit_y_remain)
    fh = figure(1); clf;
    plot(x, y, 'bo');
    hold on;
    plot([1:k], [fit_y_old fit_y_remain(1)], '-g');
    plot([k:l], fit_y_remain, '-m');
    set(gca, 'xscale', 'log');
    set(gca, 'yscale', 'log');
    set(gca, 'ylim', [min(y(y>0)) max(y)*1.1]);
    set(gca, 'FontSize', 18);
    waitforbuttonpress
end
