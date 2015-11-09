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
%%
%%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function parse_shanghai_taxi_step2()
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
    input_dir  = './processed_shanghai_taxi/';
    output_dir = './processed_shanghai_taxi/';
    fig_dir = './fig_shanghai_taxi/';

    time_filename = 'times.txt';
    car_dir = 'cars/';

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
    if nargin < 1, arg = 1; end


    %% --------------------
    %% Main starts
    %% --------------------

    %% --------------------
    %% Read times
    %% --------------------
    if DEBUG2, fprintf('Read times\n'); end
    
    times = load([input_dir time_filename]);
    base_time = times(1);
    times = times - base_time;
    fprintf('  time size = %dx%d\n', size(times));
    fprintf('  duration = %f days = %d - %d\n', (times(end)-times(1))/60/60/24, times(end), times(1));
    % times = times(1:1*24*60*60)';
    % times = [min(times):5:max(times)]';
    times = [min(times):1:max(times)]';
    fprintf('      new size = %dx%d\n', size(times));
    % return
    

    %% --------------------
    %% Read Directory
    %% --------------------
    if DEBUG2, fprintf('Read Directory\n'); end

    filelist = dir([input_dir car_dir '*.txt']);
    fprintf('  #files = %d\n', length(filelist));

    %% find the largest k
    select_car_num = 100;
    file_sizes = [];
    for fi = 1:length(filelist)
        filename = filelist(fi).name;
        % data = load([input_dir car_dir filename]);
        % file_sizes = [file_sizes, size(data,1)];
        [status,cmdout] = system(['cat ' input_dir car_dir filename '| wc -l']);
        file_sizes = [file_sizes, str2num(cmdout)];
    end
    file_sizes = sort(file_sizes, 'descend');
    

    %% --------------------
    %% Read car data
    %% --------------------
    if DEBUG2, fprintf('Read car data\n'); end

    fig_idx = fig_idx + 1;
    fh = figure(fig_idx); clf;

    car_cnt = 0;
    for fi = 1:length(filelist)
        % if fi > 50
        %     break;
        % end

        filename = filelist(fi).name;
        %% ------------
        [status,cmdout] = system(['cat ' input_dir car_dir filename '| wc -l']);
        if str2num(cmdout) < file_sizes(select_car_num)
            continue;
        end
        %% ------------
        car_cnt = car_cnt + 1;

        data = load([input_dir car_dir filename]);
        fprintf('  car %s: size=%dx%d\n', filename, size(data));

        [v,idx] = unique(data(:,1));

        newx = interp1(data(idx,1)-base_time, data(idx,2), times);
        newy = interp1(data(idx,1)-base_time, data(idx,3), times);
    
        car_data{car_cnt} = [times, newx, newy];
        fprintf('      new size=%dx%d\n', size(car_data{car_cnt}));

        
        % fig_idx = fig_idx + 1;
        % fh = figure(fig_idx); clf;
        lh = plot(data(find((data(:,1)-base_time) < max(times)),2), data(find((data(:,1)-base_time) < max(times)),3), 'b.');
        set(lh, 'Color', colors{mod(fi-1,length(colors))+1});
        % hold on;
        % lh = plot(car_data{fi}(:,2), car_data{fi}(:,3), 'r*');
        hold on;
    end
    print(fh, '-dpsc', [fig_dir 'map.eps']);

    %% --------------------
    %% Find intersection
    %% --------------------
    if DEBUG2, fprintf('Find intersection\n'); end

    ranges = [100, 200, 300];
    for ri = 1:length(ranges)
        for ci = 1:length(car_data)
            contact_durations{ri}{ci} = [];
            contact_cars{ri}{ci} = [];
            contact_time{ri}{ci} = [];
        end
    end
    
    for ri = 1:length(ranges)
        range = ranges(ri);
        fprintf('range %d/%d: %d\n', ri, length(ranges), range);
        
        to_print = 1;
        contact_dur = [];
        contact_car = [];
        tmp2 = [];
        for ci1 = 1:length(car_data)-1

            fprintf('  car %d/%d\n  ', ci1, length(car_data));

            start_contact_time = -1 * ones(1, length(car_data)-ci1);

            for ti = 1:length(times)
                time = times(ti);

                %% -------------
                %% print status
                status = round(ti/length(times)*100);
                if mod(status, 10) == 0
                    if to_print == 1
                        fprintf('.');
                        to_print = 0;
                    end
                else
                    to_print = 1;
                end
                %% -------------

                for ci2 = ci1+1:length(car_data)
                    [dist d2km] = lldistkm([car_data{ci1}(ti,2) car_data{ci1}(ti,3)], ...
                                           [car_data{ci2}(ti,2) car_data{ci2}(ti,3)]);
                    dist = dist * 1000;

                    %% not contact before
                    if start_contact_time(ci2-ci1) < 0
                        %% not contact now -> skip
                        %% contact now
                        if dist <= range
                            start_contact_time(ci2-ci1) = time;
                        end
                    %% contact before
                    else
                        %% still contact now -> skip
                        %% not contact now
                        if dist > range
                            duration = time - start_contact_time(ci2-ci1);
                            contact_durations{ri}{ci1} = [contact_durations{ri}{ci1} duration];
                            contact_durations{ri}{ci2} = [contact_durations{ri}{ci2} duration];
                            contact_cars{ri}{ci1} = [contact_cars{ri}{ci1} ci2];
                            contact_cars{ri}{ci2} = [contact_cars{ri}{ci2} ci1];
                            contact_time{ri}{ci1} = [contact_time{ri}{ci1} start_contact_time(ci2-ci1)];
                            contact_time{ri}{ci2} = [contact_time{ri}{ci2} start_contact_time(ci2-ci1)];

                            start_contact_time(ci2-ci1) = -1;
                        end
                    end

                end
            end

            %% write detail car contact info
            dlmwrite([output_dir 'contacts/' 'range' num2str(range) '.car' num2str(ci1) '.txt'], [contact_time{ri}{ci1}' contact_cars{ri}{ci1}' contact_durations{ri}{ci1}'], 'delimiter', ',');

            %% processed data
            contact_dur = [contact_dur contact_durations{ri}{ci1}];
            contact_car = [contact_car length(contact_cars{ri}{ci1})];
            %% ----------------
            %% end of a car process
            fprintf('\n');
            %% ----------------
        end

        dlmwrite([output_dir 'range' num2str(range) '.contact_dur.txt'], sort(contact_dur), 'delimiter', '\n');
        dlmwrite([output_dir 'range' num2str(range) '.contact_car.txt'], sort(contact_car), 'delimiter', '\n');
    end

end

