function [L, U, p1, p_hat, pl_curve, p3, c] = fit_3seg_curve_auto(x, y, L, U, DEBUG)

    %% First find the lower and upper bound
    [pl_curve, L, U, exponent] = fit_power(x, y, L, U, DEBUG);
    
    %% Fit the phase 1
    %%   method 1: by iterative heuristic 
    % exponent = -3;
    % fit_phase1(x, y, L, exponent, DEBUG);
    %%   method 2: solve a optimization problem with 2 geometric distribution
    [p1, p_hat] = fit_phase1_v2(x, y, L, -3, DEBUG);
    
    %% Fit the phase 2 again with the given p from phase 1
    %% p = gamma / (L + gamma)
    % exponent = - (p*L/(1-p));
    % [L, U, a, exponent] = fit_power_v2(x, y, L, U, exponent, DEBUG);

    %% Fit the phase 3 by formula
    [p3, c] = fit_phase3(x, y, U, exponent, DEBUG);

    l = find(x <= L);
    l = l(end);
    u = find(x >= U);
    u = u(1);

    xseg1 = x(1:l);
    yseg1 = y(1:l);
    xseg2 = x(l:u);
    yseg2 = y(l:u);
    xseg3 = x(u:end);
    yseg3 = y(u:end);

    % est_yseg1 = phase1_close_form_v2([p1, p_hat], xseg1);
    est_yseg1 = phase1_close_form_v3([p1, p_hat], xseg1);
    est_yseg2 = pl_curve(xseg2);
    est_yseg3 = phase3_close_form([p3 c], xseg3);

    est_yseg1

    % est_yseg1_others = phase1_close_form_v2_tail([p1, p_hat], [xseg2; xseg3]);
    est_yseg1_others = phase1_close_form_v3_tail([p1, p_hat], [xseg2; xseg3]);
    est_yseg2_others = pl_curve([xseg1; xseg3]);
    est_yseg3_others = phase3_close_form([p3 c], [xseg1; xseg2]);

    if DEBUG
        fh = figure(4); clf;
        lh = plot(x, y, 'bo');
        set(lh, 'MarkerSize', 15);
        hold on;
        lh = plot(xseg1, est_yseg1, '-g');
        set(lh, 'LineWidth', 2);
        lh = plot(xseg2, est_yseg2, '-r');
        set(lh, 'LineWidth', 2);
        lh = plot(xseg3, est_yseg3, '-m');
        set(lh, 'LineWidth', 2);

        lh = plot([xseg2; xseg3], est_yseg1_others, '--g');
        set(lh, 'LineWidth', 2);
        lh = plot([xseg1; xseg3], est_yseg2_others, '--r');
        set(lh, 'LineWidth', 2);
        lh = plot([xseg1; xseg2], est_yseg3_others, '--m');
        set(lh, 'LineWidth', 2);

        set(gca, 'xscale', 'log');
        set(gca, 'yscale', 'log');
        set(gca, 'ylim', [min(y(y>0)) max(y)*1.1]);
        waitforbuttonpress
    end
    
end


%% fit_power
function [pl_curve, L, U, exponent] = fit_power(x, y, L, U, DEBUG)

    l = find(x >= L);
    l = l(1);
    u = find(x <= U);
    u = u(end);

    l_hat = l + min(50, round((u-l)/4));
    rmse = ones(1, l_hat) * Inf;
    for l2 = l_hat:-1:1
        xseg = x(l2:u);
        yseg = y(l2:u);

        [curve1, gof] = fit(xseg, yseg, 'power1');
        %% get log error
        rmse(l2) = cal_log_err(curve1(xseg), yseg);

        if l2 < l_hat-2
            if rmse(l2) > rmse(l2+1) & rmse(l2) > rmse(l2+3)
                break;
            end
        end
        
        if DEBUG, fprintf('  l2=%d, rmse=%.4f\n', l2, rmse(l2)); end
    end
    [~,ll] = min(rmse);

    rmse = [];
    u_hat = u - min(50, round((u-l)/4));
    miny = min(y);
    idx = find(y == miny);
    u_end = idx(1);
    for u2 = u_hat:u_end
        xseg = x(ll:u2);
        yseg = y(ll:u2);

        [curve2{u2-u_hat+1}, gof] = fit(xseg, yseg, 'power1');
        %% get log error
        rmse(u2-u_hat+1) = cal_log_err(curve2{u2-u_hat+1}(xseg), yseg);

        if u2 > u_hat + 3
            if rmse(u2-u_hat+1) > rmse(u2-u_hat) & rmse(u2-u_hat+1) > rmse(u2-u_hat-2)
                break;
            end
        end
        
        if DEBUG, fprintf('  u2=%d, rmse=%.4f\n', u2, rmse(u2-u_hat+1)); end
    end
    [~,uu] = min(rmse);
    pl_curve = curve2{uu};
    uu = uu + u_hat - 1;

    L = x(ll);
    U = x(uu);
    exponent = pl_curve.b;


    if DEBUG
        fprintf('  L idx from %d -> %d (max=%d)\n', l, ll, l_hat);
        fprintf('  U idx from %d -> %d (min=%d)\n', u, uu, u_hat);
        fprintf('  exponent = %.4f\n', exponent);
    end
    

    if DEBUG
        fh = figure(2); clf;
        plot(x, y, 'bo');
        hold on;
        plot(x, pl_curve(x), '-r');
        set(gca, 'xscale', 'log');
        set(gca, 'yscale', 'log');
        set(gca, 'ylim', [min(y(y>0)) max(y)*1.1]);
    end

end


%% fit_power
function [L, U, a, exponent] = fit_power_v2(x, y, L, U, exponent, DEBUG)

    l = find(x >= L);
    l = l(1);
    u = find(x <= U);
    u = u(end);

    l_hat = l + min(50, round((u-l)/4));
    for l2 = 1:l_hat
        xseg = x(l2:u);
        yseg = y(l2:u);

        param = lsqcurvefit(@phase2_close_form_log, [1 exponent], xseg, log(yseg), ...
                               [-Inf exponent*1.01], [Inf, exponent*0.99]);
        rmse(l2) = cal_log_err(phase2_close_form(param, xseg), yseg);
        
        if DEBUG, fprintf('  l2=%d, rmse=%.4f\n', l2, rmse(l2)); end
    end
    [~,ll] = min(rmse);

    rmse = [];
    u_hat = u - min(50, round((u-l)/4));
    miny = min(y);
    idx = find(y == miny);
    u_end = idx(1);
    for u2 = u_hat:u_end
        xseg = x(ll:u2);
        yseg = y(ll:u2);

        param = lsqcurvefit(@phase2_close_form_log, [1 exponent], xseg, log(yseg), ...
                               [-Inf exponent*0.999], [Inf, exponent*1.001]);
        rmse(u2-u_hat+1) = cal_log_err(phase2_close_form(param, xseg), yseg);
        
        if DEBUG, fprintf('  u2=%d, rmse=%.4f\n', u2, rmse(u2-u_hat+1)); end
    end
    [~,uu] = min(rmse);
    uu = uu + u_hat - 1;

    L = x(ll);
    U = x(uu);
    
    if DEBUG
        fprintf('  phase 2: \n');
        fprintf('  L idx from %d -> %d (max=%d)\n', l, ll, l_hat);
        fprintf('  U idx from %d -> %d (min=%d)\n', u, uu, u_hat);
        fprintf('  exponent = %.4f\n', exponent);
    end
    

    if DEBUG
        fh = figure(2); clf;
        plot(x, y, 'bo');
        hold on;
        plot(x, phase2_close_form(param, x), '-r');
        set(gca, 'xscale', 'log');
        set(gca, 'yscale', 'log');
        set(gca, 'ylim', [min(y(y>0)) max(y)*1.1]);
    end

end

function y = phase2_close_form(param, x)
    %% p = a * x ^ exponent
    a = param(1);
    exponent = param(2);

    y = a * (x.^exponent);
    % y = y';
end

function y = phase2_close_form_log(param, x)
    y = log(phase2_close_form(param, x));
end


%% use iterative heuristic
function fit_phase1(x, y, L, exponent, DEBUG)

    l = find(x <= L);
    l = l(end);
    
    xseg = x(1:l);
    yseg = y(1:l);
    gamma = -exponent;
    p = gamma / (L + gamma);

    err = 10;
    thresh = 1;


    %% (1-p_used) * P_hat * p * (1-p)^(k-1) = pk
    % p_hat = y(1) / p / ((1-p)^(1-1));
    p_used = 0;
    cnt = 1;
    fit_y = [];
    for k = 1:l-1
        p_hat(k) = y(k) / p / ((1-p)^(k-k)) / (1-p_used);
        fprintf(' k=%d/%d, p_hat=%f\n', k, l, p_hat(k));

        this_fit_y = (1-p_used) * p_hat(k) * p * ((1-p).^([k:l]-k));
        remain_err = cal_log_err(this_fit_y(2:end)', y(k+1:l));
        
        if DEBUG, 
            fprintf('err = %f\n', remain_err);
            plot_fit(x, y, k, l, fit_y, this_fit_y); 
        end

        cnt = 1;
        direct = 0;
        prev_err = remain_err;
        speed = 0.02;
        while(remain_err > 0.1)
            if cnt == 1
                p_hat1 = p_hat(k) * (1-speed);
                this_fit_y1 = (1-p_used) * p_hat1 * p * ((1-p).^([k:l]-k));
                remain_err1 = cal_log_err(this_fit_y1(2:end)', y(k+1:l));

                p_hat2 = p_hat(k) * (1+speed);
                this_fit_y2 = (1-p_used) * p_hat2 * p * ((1-p).^([k:l]-k));
                remain_err2 = cal_log_err(this_fit_y2(2:end)', y(k+1:l));

                if remain_err1 > remain_err2
                    direct = 1;
                end
            end

            if direct == 0
                this_p_hat = p_hat(k) * (1-speed);
            elseif direct == 1
                this_p_hat = p_hat(k) * (1+speed);
            end
            this_fit_y = (1-p_used) * this_p_hat * p * ((1-p).^([k:l]-k));
            remain_err = cal_log_err(this_fit_y(2:end)', y(k+1:l));

            if prev_err > remain_err
                prev_err = remain_err;
                p_hat(k) = this_p_hat;
            else
                break;
            end

            cnt = cnt + 1; 


            if DEBUG, 
                fprintf('err = %f\n', remain_err);
                plot_fit(x, y, k, l, fit_y, this_fit_y); 
            end
        end

        
        fit_y(k) = this_fit_y(1);
        p_used = p_used + fit_y(k);
        if p_used >= 1
            break;
        end

    end
end


%% solve a optimization problem with 2 geometric distribution
function [p, p_hat] = fit_phase1_v2(x, y, L, exponent, DEBUG)

    l = find(x <= L);
    l = l(end);
    
    xseg = x(1:l);
    yseg = y(1:l);

    gamma = -exponent;
    p = gamma / (L+gamma);
    p_hat = ones(1,2) * 0.1;

    % param = lsqcurvefit(@phase1_close_form_v2_log, [p 0.1], xseg, log(yseg));
    param = lsqcurvefit(@phase1_close_form_v3_log, [p 0.1], xseg, log(yseg));
    
    p = param(1);
    p_hat = param(2);

    if DEBUG
        fprintf('  phase1: p = %.4f, p_hat = ', param(1));
        fprintf('%.4f,', param(2:end));
        fprintf('\n');
    end

    if DEBUG
        fh = figure(1); clf;
        plot(x, y, 'bo');
        hold on;

        % plot(x, phase1_close_form_v2(param, x), '-g');
        plot(x, phase1_close_form_v3(param, x), '-g');

        set(gca, 'xscale', 'log');
        set(gca, 'yscale', 'log');
        set(gca, 'ylim', [min(y(y>0)) max(y)*1.1]);
    end
end


function y = phase1_close_form(param, x)
    %% p_hat = y(1) / p / ((1-p)^(1-1));
    %% p = p1_hat*p*(1-p)^(k-1) + (p2_hat)*p*(1-p)^(k-2) + (p3_hat*p*(1-p)^(k-3) + 
    %%     (1-p1_hat-p2_hat-p3_hat)*p*(1-p)^(k-4)
    p = param(1);
    p_hat = param(2:end);

    for k = 1:length(p_hat)
        y(k) = p_hat(k) * p;
    end 

    l = length(x);
    y(k+1:l) = p_hat(end) * p * ((1-p).^( x(k+1:l)-k));
    y = y';
end

function y = phase1_close_form_v2(param, x)
    %% p_hat = y(1) / p / ((1-p)^(1-1));
    %% p = p1_hat*p*(1-p)^(k-1) + (p2_hat)*p*(1-p)^(k-2) + (p3_hat*p*(1-p)^(k-3) + 
    %%     (1-p1_hat-p2_hat-p3_hat)*p*(1-p)^(k-4)
    p = param(1);
    p_hat = param(2);

    y(1) = p_hat * p;
    
    l = length(x);
    y(2:l) = (1-p_hat) * p * ((1-p).^( x(2:l)-2));
    y = y';
end

function y = phase1_close_form_v2_log(param, x)
    y = log(phase1_close_form_v2(param, x));
end

function y = phase1_close_form_v2_tail(param, x)
    %% p_hat = y(1) / p / ((1-p)^(1-1));
    %% p = p1_hat*p*(1-p)^(k-1) + (p2_hat)*p*(1-p)^(k-2) + (p3_hat*p*(1-p)^(k-3) + 
    %%     (1-p1_hat-p2_hat-p3_hat)*p*(1-p)^(k-4)
    p = param(1);
    p_hat = param(2:end);

    y = (1-p_hat) * p * ((1-p).^( x-2));
    % y = y';
end


function y = phase1_close_form_v3(param, x)
    %% p_hat = y(1) / p / ((1-p)^(1-1));
    p = param(1);
    p_hat = param(2);

    l = length(x);
    y = p_hat * p * ((1-p).^(x-1));
end

function y = phase1_close_form_v3_log(param, x)
    y = log(phase1_close_form_v3(param, x));
end

function y = phase1_close_form_v3_tail(param, x)
    %% p_hat = y(1) / p / ((1-p)^(1-1));
    %% p = p1_hat*p*(1-p)^(k-1) + (p2_hat)*p*(1-p)^(k-2) + (p3_hat*p*(1-p)^(k-3) + 
    %%     (1-p1_hat-p2_hat-p3_hat)*p*(1-p)^(k-4)
    p = param(1);
    p_hat = param(2);

    y = p_hat * p * ((1-p).^(x-1));
    % y = y';
end

function [p, c] = fit_phase3(x, y, U, exponent, DEBUG)

    u = find(x >= U);
    u = u(1);
    
    xseg = x(u:end);
    yseg = y(u:end);

    gamma = -exponent;
    p = gamma / (U+gamma);

    est_y = phase3_close_form([p 1], xseg);
    c = yseg(1) / est_y(1);
    est_y = c * est_y;

    if DEBUG
        fprintf('  phase3: p = %.4f, c = %.4f\n', p, c);
    end
    
    if DEBUG
        fh = figure(3); clf;
        plot(x, y, 'bo');
        hold on;
        plot(x, phase3_close_form([p c], x), '-g');
        % plot(xseg, est_y, '-g');
        set(gca, 'xscale', 'log');
        set(gca, 'yscale', 'log');
        set(gca, 'ylim', [min(y(y>0)) max(y)*1.1]);
    end
end

function y = phase3_close_form(param, x)
    %% p = c * p * (1-p)^(k-1)
    p = param(1);
    c = param(2);

    y = c * p * ((1-p).^(x-1));
    % y = y';
end

function y = phase3_close_form_log(param, x)
    y = log(phase3_close_form(param, x));
end

function [err] = cal_log_err(y_fit, y)
    % err = mean(sqrt((y - y_fit).^2));
    err = mean(sqrt((log(y) - log(y_fit)).^2));
end

function [err] = cal_err(y_fit, y)
    err = mean(sqrt((y - y_fit).^2));
    % err = mean(sqrt((log(y) - log(y_fit)).^2));
end

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


