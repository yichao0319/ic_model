function [fit_curve, ok, xseg, yseg, rmse] = fit_3seg_curve(x, y, L, U)
    ok = [0, 0, 0];

    min_cnt = 3;

    idx = find(x <= L);
    rmse = 0;
    len = 0;
    if length(idx) > min_cnt
        ok(1) = 1;
        xseg{1} = x(idx);
        yseg{1} = y(idx);

        % [fit_curve{1}, gof{1}] = fit(xseg{1}, yseg{1}, 'exp1', 'Robust', 'Bisquare');
        [fit_curve{1}, gof{1}] = fit(xseg{1}, yseg{1}, 'a*p*((1-p)^(x-1))');
        % f = ezfit(xseg{1}, yseg{1}, 'a*((1-p)^x)*p');
        % fit_curve{1} = cfit(fittype(f.eq), f.m(1), f.m(2), f.m(3));
        % gof{1}.rmse = mean((fit_curve{1}(xseg{1}) - yseg{1}).^2);

        fprintf('  Error1:\n');
        fit_curve{1}
        gof{1}
        rmse = rmse + (gof{1}.rmse ^ 2) * length(xseg{1});
        len = len + length(xseg{1});
    end

    idx = find(x > L & x <= U);
    if length(idx) > min_cnt
        ok(2) = 1;
        xseg{2} = x(idx);
        yseg{2} = y(idx);

        [fit_curve{2}, gof{2}] = fit(xseg{2}, yseg{2}, 'power1');
        % f = ezfit(xseg{2}, yseg{2}, 'a*x^n;log');
        % fit_curve{2} = cfit(fittype(f.eq), f.m(1), f.m(2));
        % gof{2}.rmse = mean((fit_curve{2}(xseg{2}) - yseg{2}).^2);

        fprintf('  Error2:\n');
        fit_curve{2}
        gof{2}
        rmse = rmse + (gof{2}.rmse ^ 2) * length(xseg{2});
        len = len + length(xseg{2});
    end

    idx = find(x > U);
    if length(idx) > min_cnt
        ok(3) = 1;
        xseg{3} = x(idx);
        yseg{3} = y(idx);

        [fit_curve{3}, gof{3}] = fit(xseg{3}, yseg{3}, 'exp1');
        % [fit_curve{3}, gof{3}] = fit(xseg{3}, yseg{3}, 'a*p*((1-p)^(x-1))+c');
        % f = ezfit(xseg{3}, yseg{3}, 'a*p*((1-p)^(x-1))+w');
        % fit_curve{3} = cfit(fittype(f.eq), f.m(1), f.m(2), f.m(3));
        % gof{3}.rmse = mean((fit_curve{3}(xseg{3}) - yseg{3}).^2);

        fprintf('  Error3:\n');
        fit_curve{3}
        gof{3}
        rmse = rmse + (gof{3}.rmse ^ 2) * length(xseg{3});
        len = len + length(xseg{3});
    end

    rmse = sqrt(rmse / len);
    fprintf('  Avg RMSE = %f\n', rmse);
end