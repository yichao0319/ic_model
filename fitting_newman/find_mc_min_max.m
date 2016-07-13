function [x_min, x_max, Dmins, Dmaxs, x_mins, x_maxs] = find_mc_min_max(data, x_mins, x_maxs, default)
    %% --------------------
    %% DEBUG
    %% --------------------
    DEBUG0 = 0;
    DEBUG1 = 1;
    DEBUG2 = 1;  %% progress
    DEBUG3 = 1;  %% verbose
    DEBUG4 = 1;  %% results


    %% --------------------
    %% Variable
    %% --------------------
    fig_idx = 0;


    %% --------------------
    %% Conversion
    %% --------------------
    % orig_x = data(:,1);
    % data(:,1) = 1:size(data,1);

    % % orig_x_mins = x_mins;
    % idx1 = find(orig_x >= x_mins(1)); idx1 = idx1(1);
    % idx2 = find(orig_x <= x_mins(end)); idx2 = idx2(end);
    % x_mins = data(idx1,1):data(idx2,1);
    % idx1 = find(data(:,1) >= x_mins(1)); idx1 = idx1(1);
    % idx2 = find(data(:,1) <= x_mins(end)); idx2 = idx2(end);
    % orig_x_mins = orig_x(idx1:idx2);

    % % orig_x_maxs = x_maxs;
    % if length(x_maxs) > 0
    %     idx1 = find(orig_x >= x_maxs(1)); idx1 = idx1(1);
    %     idx2 = find(orig_x <= x_maxs(end)); idx2 = idx2(end);
    %     x_maxs = data(idx1,1):data(idx2,1);
    %     idx1 = find(data(:,1) >= x_maxs(1)); idx1 = idx1(1);
    %     idx2 = find(data(:,1) <= x_maxs(end)); idx2 = idx2(end);
    %     orig_x_maxs = orig_x(idx1:idx2);
    % end

    % fprintf('orig x = %g-%g, size = %d\n', orig_x(1), orig_x(end), length(orig_x));
    % fprintf('orig x_mins = %d-%d\n', orig_x_mins(1), orig_x_mins(end));
    % fprintf('     x_mins = %d-%d\n', x_mins(1), x_mins(end));
    % fprintf('orig x_maxs = %d-%d\n', orig_x_maxs(1), orig_x_maxs(end));
    % fprintf('     x_maxs = %d-%d\n', x_maxs(1), x_maxs(end));


    %% --------------------
    %%   Find min
    %% --------------------
    if DEBUG2, fprintf('  Find min\n'); end


    if default.x_max < 0
        x_max = max(data(:,1));
    else
        x_max = default.x_max;
    end
    Dmins = ones(size(x_mins)) * Inf;
    for xi = 1:length(x_mins)
        x_min = x_mins(xi);
        D = KS_test_of_min(data, x_min, x_max);
        Dmins(xi) = D;


        % idx_min = find(data(:,1) >= x_min);
        % idx_min = idx_min(1);
        % idx_max = find(data(:,1) <= x_max);
        % idx_max = idx_max(end);

        % est_p = est_pl_prob(data, x_min, x_max);
        % emp_p = cal_real_prob(data, x_min, x_max);

        % fh = figure(4); clf;
        % plot(data(:,1), emp_p, 'bo');
        % hold on;
        % plot(data(idx_min:end,1), est_p(idx_min:end), '-r');
        % plot(x_min, est_p(idx_min,1), 'go');
        % plot(x_max, est_p(idx_max,1), 'go');
        % set(gca, 'xscale', 'log');
        % set(gca, 'yscale', 'log');
        % title(sprintf('x_min=%d, error=%f', x_min, D));
        % pause
    end
    [~,idx] = min(Dmins);
    if default.thresh_min < 0
        thresh_min = 1e-2;
    else
        thresh_min = default.thresh_min;
    end
    for i = idx-1:-1:1
        if abs(Dmins(idx) - Dmins(i)) > thresh_min
            idx = i+1;
            break;
        end
    end
    x_min = x_mins(idx);
    if DEBUG3, fprintf('  > x_min = %d\n', x_min); end


    %% --------------------
    %%   Find max
    %% --------------------
    if DEBUG2, fprintf('  Find max\n'); end

    if length(x_maxs) == 0
        x_maxs = [x_min+1:max(data(:,1))];

        % val = x_min+1;
        % idx1 = find(data(:,1) == val);
        % idx2 = size(data,1);
        % orig_x_maxs = orig_x(idx1:idx2);
    end

    Dmaxs = ones(size(x_maxs)) * Inf;
    for xi = 1:length(x_maxs)
        x_max = x_maxs(xi);
        D = KS_test_of_max(data, x_min, x_max);

        Dmaxs(xi) = D;

        % idx_min = find(data(:,1) >= x_min);
        % idx_min = idx_min(1);
        % idx_max = find(data(:,1) <= x_max);
        % idx_max = idx_max(end);

        % est_p = est_pl_prob(data, x_min, x_max);
        % emp_p = cal_real_prob(data, x_min, x_max);

        % fh = figure(4); clf;
        % plot(data(:,1), emp_p, 'bo');
        % hold on;
        % plot(data(idx_min:end,1), est_p(idx_min:end), '-r');
        % plot(x_min, est_p(idx_min,1), 'go');
        % plot(x_max, est_p(idx_max,1), 'go');
        % set(gca, 'xscale', 'log');
        % set(gca, 'yscale', 'log');
        % title(sprintf('x_max=%d, error=%f', x_max, D));
        % pause
    end
    [~,idx] = min(Dmaxs);
    thresh_max = 1e-2;
    for i = idx-1:-1:1
        if abs(Dmaxs(idx) - Dmaxs(i)) > thresh_max
            idx = i+1;
            break;
        end
    end
    x_max = x_maxs(idx);
    if DEBUG3, fprintf('  > x_max = %d\n', x_max); end

    % fig_idx = fig_idx + 1;
    % fh = figure(fig_idx); clf;
    % plot(x_maxs, Dmaxs, '-b*');


    %% --------------------
    %% Convert back
    %% --------------------
    % used_x = data(:,1);
    % data(:,1) = orig_x;

    % used_x_min = x_min;
    % idx = find(x_mins == x_min);
    % x_min = orig_x_mins(idx);
    % % x_mins = used_x(x_mins);
    % x_mins = orig_x_mins;

    % used_x_max = x_max;
    % idx = find(x_maxs == x_max);
    % x_max = orig_x_maxs(idx);
    % % x_maxs = used_x(x_maxs);
    % x_maxs = orig_x_maxs;


    % fprintf('x_min = %d, orig_x_min = %d\n', used_x_min, x_min);
    % fprintf('x_max = %d, orig_x_max = %d\n', used_x_max, x_max);

end