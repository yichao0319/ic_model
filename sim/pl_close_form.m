%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Yi-Chao Chen @ Huawei
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pl_close_form(L)
    
    %% --------------------
    %% Variable
    %% --------------------
    fig_idx = 0;
    font_size = 18;
    

    %% --------------------
    %% Main starts
    %% --------------------
    k_range = L+1:L+30;
    for k = k_range
        term1 = 0;
        for j = 2:L
            term1 = term1 + A_cap(j, k, L) / ((2*L)^j);
        end

        term2 = A_cap(1, k, L) / ((3*L)^j);
        
        term3 = 0;
        for i = [0:k-(L+1)]
            nom = (-1)^(k-i) * nchoosek(k-(L+1), i);
            denom = (k-L-i)^L * (2*L + (k-i));
            term3 = term3 - nom/denom;
        end
        
        p(k) = nchoosek(k-1,L) * L^(L+1) * (term1 + term2 + term3);

    end

    %% fit power-law
    [fit_curve, gof] = fit(k_range', p(k_range)', 'power1');
    fit_curve
    gof
    % rmse = rmse + (gof{2}.rmse ^ 2) * length(xseg{2});
    % len = len + length(xseg{2});

    %% plot
    fig_idx = fig_idx + 1;
    fh = figure(fig_idx); clf;
    plot(k_range, p(k_range), '-bo');
    hold on;
    plot(k_range, fit_curve(k_range), '-r.');
    set(gca, 'XScale', 'log');
    set(gca, 'YScale', 'log');
    set(gca, 'FontSize', font_size);
    xlabel('K', 'FontSize', font_size);
    ylabel('P(K)', 'FontSize', font_size);
end

function [val] = A_cap(j, k, L)
    val = 0;
    for i = [0:k-(L+1)]
        nom = (-1)^(k-j-1-i) * nchoosek(k-(L+1), i);
        denom = (k-L-i)^(L-j+1);
        val = val + nom/denom;
    end
end
