function [emp_p] = cal_real_prob(data, x_min, x_max)
    idx_min = find(data(:,1) >= x_min);
    idx_min = idx_min(1);
    idx_max = find(data(:,1) <= x_max);
    idx_max = idx_max(end);

    emp_p = data(:,2)/sum(data(idx_min:idx_max,2));
end