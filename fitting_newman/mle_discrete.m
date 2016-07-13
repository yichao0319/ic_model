function [alpha_hat] = mle_discrete(data, x_min, x_max)
    N = size(data,1);
    idx_min = find(data(:,1) >= x_min);
    idx_min = idx_min(1);

    idx_max = find(data(:,1) <= x_max);
    idx_max = idx_max(end);

    term1 = 0;
    N_sum = 0 ;
    for ki = idx_min:idx_max
    % for ki = idx_min:N
        num = data(ki,2);
        term1 = term1 + num*log(data(ki,1)/(x_min-0.5));
        N_sum = N_sum + num;
    end
    alpha_hat = 1 + N_sum*(term1)^(-1);

    % sum(data(idx_min:idx_max,2))
    % N_sum
    % alpha_hat
end