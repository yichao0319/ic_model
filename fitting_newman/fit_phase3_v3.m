function [fit_data] = fit_phase3_v3(x, y, L, U, exponent, DEBUG)
    if nargin < 6, DEBUG = 0; end


    gamma = -exponent;

    %% phase 3 - seg 3
    xseg3 = [];
    yseg3 = [];
    idx = find(x>=U);
    alpha = 1;
    if length(idx) > 0
        xseg3 = x(idx);
        yseg3 = phase3_close_form_v2(xseg3, L, U, gamma-0.6);


        % norm_idx = round((idx(1) + idx(end))*3/5);
        norm_idx = idx(1);
        alpha = y(norm_idx) / yseg3(norm_idx-idx(1)+1);

        % lh(5) = plot(xseg3, alpha*yseg3, '-');
        % set(lh(5), 'Color', colors{4});
        % set(lh(5), 'LineWidth', 6);
    end

    %% phase 3 - seg 1
    xseg1 = [];
    yseg1 = [];
    idx = find(x>0 & x<=L);
    if length(idx) > 0
        xseg1 = x(idx);
        yseg1 = phase3_close_form_v2(xseg1, L, U, gamma-0.6);
        % yseg12 = phase3_close_form_v2(xseg12, L, U, gamma);

        % lh2 = plot(xseg1, alpha*yseg1, '--');
        % set(lh2, 'Color', colors{4});
        % set(lh2, 'LineWidth', 2);
    end

    %% phase 3 - seg 2
    xseg2 = [];
    yseg2 = [];
    idx = find(x>=L & x<=U);
    if length(idx) > 0
        xseg2 = x(idx);
        yseg2 = phase3_close_form_v2(xseg2, L, U, gamma-0.6);

        % lh3 = plot(xseg2, alpha*yseg2, '--');
        % set(lh3, 'Color', colors{4});
        % set(lh3, 'LineWidth', 2);
    end


    fit_data.xseg1 = xseg1;
    fit_data.xseg2 = xseg2;
    fit_data.xseg3 = xseg3;
    fit_data.est_yseg3 = yseg3;
    fit_data.est_yseg3_others = [yseg1; yseg2];

end