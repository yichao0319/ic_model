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

