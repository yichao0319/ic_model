%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Yi-Chao Chen @ Huawei
%%
%% - Input:
%%
%%
%% - Output:
%%
%%
%% example:
%%  visualize_vehicle_trace('rome_taxi')
%%  visualize_vehicle_trace('shanghai_taxi')
%%  visualize_vehicle_trace('sf_taxi')
%%  visualize_vehicle_trace('seattle_bus')
%%  visualize_vehicle_trace('beijing_taxi')
%%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function visualize_vehicle_trace(dataname, gran, ncar)
    % addpath('../utils');
    
    %% --------------------
    %% DEBUG
    %% --------------------
    DEBUG0 = 0;
    DEBUG1 = 1;
    DEBUG2 = 1;  %% progress
    DEBUG3 = 1;  %% verbose
    DEBUG4 = 1;  %% results


    %% --------------------
    %% Constant
    %% --------------------
    % input_dir  = '';
    % output_dir = '';

    font_size = 28;
    colors   = {'r', 'b', [0 0.8 0], 'm', [1 0.85 0], [0 0 0.47], [0.45 0.17 0.48], 'k'};
    lines    = {'-', '--', '-.', ':'};
    markers  = {'+', 'o', '*', '.', 'x', 's', 'd', '^', '>', '<', 'p', 'h'};


    %% --------------------
    %% Variable
    %% --------------------
    fig_idx = 0;
    

    %% --------------------
    %% Check input
    %% --------------------
    if nargin < 1, dataname = 'shanghai_taxi'; end
    if nargin < 2, gran = 1000; end
    if nargin < 3, ncar = Inf; end

    input_dir  = ['processed_' dataname '/cars/'];
    fig_dir = ['fig_' dataname '/'];


    %% --------------------
    %% Main starts
    %% --------------------

    %% --------------------
    %% Read Directory
    %% --------------------
    if DEBUG2, fprintf('Read Directory\n'); end

    filelist = dir([input_dir '*.txt']);
    fprintf('  #files = %d\n', length(filelist));

    
    %% --------------------
    %% Read car data
    %% --------------------
    if DEBUG2, fprintf('Read car data\n'); end

    fig_idx = fig_idx + 1;
    fh = figure(fig_idx); clf;

    car_cnt = 0;
    map_range = [Inf Inf -Inf -Inf];
    for fi = 1:length(filelist)
        filename = filelist(fi).name;
        car_cnt = car_cnt + 1;

        %% ================
        if car_cnt > ncar, break; end
        %% ================

        car_data{car_cnt} = load([input_dir filename]);
        % fprintf('  car %s: size=%dx%d\n', filename, size(car_data{car_cnt}));

        %% --------------------
        %% plot traces
        %% --------------------
        lh = plot(car_data{car_cnt}(:,2), car_data{car_cnt}(:,3), '.');
        set(lh, 'Color', colors{mod(fi-1,length(colors))+1});
        hold on;


        %% --------------------
        %% find the size of map
        %% --------------------
        idx = find(car_data{car_cnt}(:,2) ~= 0 & car_data{car_cnt}(:,3) ~= 0);
        minx = min(car_data{car_cnt}(idx,2));
        miny = min(car_data{car_cnt}(idx,3));
        maxx = max(car_data{car_cnt}(idx,2));
        maxy = max(car_data{car_cnt}(idx,3));
        if minx < map_range(1), map_range(1) = minx; end
        if miny < map_range(2), map_range(2) = miny; end
        if maxx > map_range(3), map_range(3) = maxx; end
        if maxy > map_range(4), map_range(4) = maxy; end        

        % fprintf('    range: (%f,%f) - (%f,%f)\n', map_range);
    end
    set(gca, 'XLim', [map_range(1) map_range(3)]);
    set(gca, 'YLim', [map_range(2) map_range(4)]);
    % print(fh, '-dpsc', [fig_dir dataname '.map.eps']);
    % print(fh, '-dpng', [fig_dir dataname '.map.png']);
    fprintf('  range: (%f,%f) - (%f,%f)\n', map_range);

    %% ================
    [map_range] = get_large(dataname);
    %% ================


    %% --------------------
    %% Plot density of all maps
    %% --------------------
    if DEBUG2, fprintf('Plot density of all maps\n'); end

    granx = (map_range(3) - map_range(1)) / gran;
    grany = (map_range(4) - map_range(2)) / gran;
    density = zeros(gran+1, gran+1);

    for ci = 1:length(car_data)
        idx = find(car_data{ci}(:, 2) >= map_range(1) & ...
                   car_data{ci}(:, 3) >= map_range(2) & ...
                   car_data{ci}(:, 2) <= map_range(3) & ...
                   car_data{ci}(:, 3) <= map_range(4));

        posx = floor((car_data{ci}(idx, 2) - map_range(1))/granx) + 1;
        posy = floor((car_data{ci}(idx, 3) - map_range(2))/grany) + 1;
        pos = (posx-1) * size(density,1) + posy;
        
        density(pos) = density(pos) + 1;
    end

    %% =================
    density(density == 0) = -10;
    %% =================

    fig_idx = fig_idx + 1;
    fh = figure(fig_idx); clf;

    xranges = [map_range(1):granx:map_range(3)];
    yranges = [map_range(2):grany:map_range(4)];
    imagesc(xranges, yranges, density);
    colorbar;
    set(gca,'YDir','normal');
    print(fh, '-dpsc', [fig_dir dataname '.density.eps']);
    print(fh, '-dpng', [fig_dir dataname '.density.png']);


    %% --------------------
    %% Plot density of center area
    %% --------------------
    if DEBUG2, fprintf('Plot density of center area\n'); end

    [center_range] = get_center(dataname);

    if sum(center_range) == 0, return; end

    granx = (center_range(3) - center_range(1)) / gran;
    grany = (center_range(4) - center_range(2)) / gran;
    density_center = zeros(gran+1, gran+1);

    fig_idx = fig_idx + 1;
    fh = figure(fig_idx); clf;

    for ci = 1:length(car_data)
        idx = find(car_data{ci}(:, 2) >= center_range(1) & ...
                   car_data{ci}(:, 3) >= center_range(2) & ...
                   car_data{ci}(:, 2) <= center_range(3) & ...
                   car_data{ci}(:, 3) <= center_range(4));

        %% --------------------
        %% plot traces
        %% --------------------
        lh = plot(car_data{ci}(idx,2), car_data{ci}(idx,3), '.');
        set(lh, 'Color', colors{mod(ci-1,length(colors))+1});
        hold on;


        %% --------------------
        %% density
        %% --------------------
        posx = floor((car_data{ci}(idx, 2) - center_range(1))/granx) + 1;
        posy = floor((car_data{ci}(idx, 3) - center_range(2))/grany) + 1;
        pos = (posx-1) * size(density_center,1) + posy;

        % idx = find(pos > 0 & pos <= numel(density_center));
        % density_center(pos(idx)) = density_center(pos(idx)) + 1;
        density_center(pos) = density_center(pos) + 1;
    end
    set(gca, 'XLim', [center_range(1) center_range(3)]);
    set(gca, 'YLim', [center_range(2) center_range(4)]);
    % print(fh, '-dpsc', [fig_dir dataname '.map_center.eps']);
    % print(fh, '-dpng', [fig_dir dataname '.map_center.png']);

    %% =================
    density_center(density_center == 0) = -10;
    %% =================

    fig_idx = fig_idx + 1;
    fh = figure(fig_idx); clf;

    xranges = [center_range(1):granx:center_range(3)];
    yranges = [center_range(2):grany:center_range(4)];
    imagesc(xranges, yranges, density_center);
    colorbar;
    set(gca,'YDir','normal');
    print(fh, '-dpsc', [fig_dir dataname '.density_center.eps']);
    print(fh, '-dpng', [fig_dir dataname '.density_center.png']);
end


%% get_center
function [center_range] = get_center(dataname)
    if strcmp(dataname, 'rome_taxi')
        center_range = [41.88 12.45 41.93 12.53];
    elseif strcmp(dataname, 'shanghai_taxi')
        center_range = [31.18 121.41 31.27 121.51];
    elseif strcmp(dataname, 'sf_taxi')
        center_range = [37.74 -122.43 37.8 -122.39];
    elseif strcmp(dataname, 'seattle_bus')
        center_range = [12500 45300 16500 48500];
    elseif strcmp(dataname, 'beijing_taxi')
        % center_range = [39.87 116.28 39.97 116.48];
        center_range = [39.9 116.41 39.97 116.47];
    else
        center_range = [0 0 0 0];
    end
end

%% get_center
function [map_range] = get_large(dataname)
    if strcmp(dataname, 'rome_taxi')
        map_range = [41.776525 12.248885 41.987339 12.613000];
    elseif strcmp(dataname, 'shanghai_taxi')
        map_range = [31.032117 121.241500 31.360800 121.801850];
    elseif strcmp(dataname, 'sf_taxi')
        map_range = [37.7 -122.47 37.84 -122.36];
    elseif strcmp(dataname, 'seattle_bus')
        map_range = [8940.088800 35885.608950 19498.779900 53930.588100];
    elseif strcmp(dataname, 'beijing_taxi')
        map_range = [39.82 116.27 40 116.5];
    else
        map_range = [0 0 0 0];
    end
end
