function [D] = KS_test_of_min(data, x_min, x_max)
    idx_min = find(data(:,1) >= x_min);
    idx_min = idx_min(1);
    idx_max = find(data(:,1) <= x_max);
    idx_max = idx_max(end);

    est_p = est_pl_prob(data, x_min, x_max);
    emp_p = cal_real_prob(data, x_min, x_max);

    D = abs(est_p(idx_min:idx_max) - emp_p(idx_min:idx_max));
    % D = abs(log10(est_p(idx_min:idx_max)) - log10(emp_p(idx_min:idx_max)));
    D = max(D);
end