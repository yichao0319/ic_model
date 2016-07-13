function [est_p, alpha_hat] = est_pl_prob(data, x_min, x_max)
    idx_min = find(data(:,1) >= x_min);
    idx_min = idx_min(1);
    idx_max = find(data(:,1) <= x_max);
    idx_max = idx_max(end);

    alpha_hat = mle_discrete(data, x_min, x_max);
    zeta = hurwitz_zeta(alpha_hat, x_min);

    est_p = 1/zeta * (data(:,1).^(-alpha_hat));
end