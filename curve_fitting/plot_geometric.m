colors   = {'r', 'b', [0 0.8 0], 'm', [1 0.85 0], [0 0 0.47], [0.45 0.17 0.48], 'k'};
font_size = 28;

fh = figure(1); clf;
lc = 0;
for p = [0:0.1:1]
    lc = lc + 1;
    x = [1:1000];
    y = p*((1-p).^(x-1));
    lh(lc) = plot(x,y, '.-');
    legends{lc} = num2str(p);
    set(lh(lc), 'Color', colors{mod(lc-1,length(colors))+1});
    hold on;
end

set(gca, 'XLim', [0 10]);
set(gca, 'YLim', [0.01 1]);
set(gca, 'FontSize', font_size);
legend(lh, legends);
set(gca, 'xscale', 'log');
set(gca, 'yscale', 'log');

%% ========================================
fh = figure(2); clf;
lc = 0;
p = 0.5;
for w = [0:1:10]
    lc = lc + 1;
    x = [1:1000];
    y = p*((1-p).^(x-w));
    lh2(lc) = plot(x,y, '.-');
    legends2{lc} = num2str(w);
    set(lh2(lc), 'Color', colors{mod(lc-1,length(colors))+1});
    hold on;
end

set(gca, 'XLim', [0 10]);
set(gca, 'YLim', [0.01 1]);
set(gca, 'FontSize', font_size);
% legend(lh2, legends2);
set(gca, 'xscale', 'log');
set(gca, 'yscale', 'log');
