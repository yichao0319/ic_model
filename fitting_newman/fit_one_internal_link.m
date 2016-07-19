%% fit_one_internal_link('coauthor')
%% fit_one_internal_link('dblp')
%% fit_one_internal_link('coauthor_network')
%% fit_one_internal_link('dblp_network')
%% fit_one_internal_link('aps')
%% fit_one_internal_link('patent')
%% fit_one_internal_link('facebook')
%% fit_one_internal_link('twitter')
%% fit_one_internal_link('rome')
%% fit_one_internal_link('beijing')
%% fit_one_internal_link('sf')
%% fit_one_internal_link('sim', 30000, 2, 8, 1)
%% fit_one_internal_link('sim', 30000, 1, 100000, 1)
%% fit_one_internal_link('sim', 30000, 2, 8, 1)
%% fit_one_internal_link('sim', 30000, 3, 10, 1)
%% fit_one_internal_link('sim', 30000, 3, 100000, 1)
function [L, U, errs] = fit_one_internal_link(name, N, L, U, itvl)
    addpath('./old/');

    %% --------------------
    %% DEBUG
    %% --------------------
    DEBUG0 = 0;
    DEBUG1 = 1;
    DEBUG2 = 1;  %% progress
    DEBUG3 = 1;  %% verbose
    DEBUG4 = 1;  %% results


    %% --------------------
    %% Constant
    %% --------------------
    % input_dir = './data/';
    output_dir = '../../data/fitting_newman/';
    fig_dir = './fig/';
    font_size = 26;
    colors   = {'r', 'b', [0 0.8 0], 'm', [1 0.85 0], [0 0 0.47], [0.45 0.17 0.48], 'k'};


    %% --------------------
    %% Variable
    %% --------------------
    fig_idx = 0;


    %% --------------------
    %% Check input
    %% --------------------
    if nargin < 1, error('PARAMETERS: NAME, N, L, U, NSEED'); end
    if nargin < 2, N = 30000; end
    if N <= 0, N = 30000; end
    if nargin < 3, L = 5; end
    if nargin < 4, U = 10; end
    if nargin < 5, itvl = 1; end


    param.L = L;
    param.U = U;
    param.N = N;
    param.itvl = itvl;


    %% --------------------
    %% Main starts
    %% --------------------
    [data] = get_data_internal_link(name, param);
    data2 = data;
    config = get_config(name, param);
    % data = data2;

    %% --------------
    %% w/o 0s
    idx = find(data(:,1) > 0);
    data = data(idx,:);
    %% --------------

    nlinks = sum(data(:,1).*data(:,2))/2;
    param.lambda = N - 1; %% external edge arrival rate: # external edges
    param.eta    = nlinks - param.lambda; %% external edge arrival rate: # internal edges

    % param.lambda = 2;
    % param.eta    = 2;

    if DEBUG3
        fprintf('  data size=%dx%d, #nodes=%d, #links=%d, min/max degree=%d/%d, min/max prob=%g/%g\n', size(data), N, nlinks, min(data(:,1)), max(data(:,1)), min(data(find(data(:,2)>0),2)), max(data(:,2)));

        fprintf('    lambda=%f, eta=%f\n', param.lambda, param.eta);


        fprintf('  data2 size=%dx%d, min/max degree=%d/%d\n', size(data2), min(data2(:,1)), max(data2(:,1)));
    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    % orig_x = data(:,1);
    % data(:,1) = 1:size(data,1);
    % idx = find(data(:,2) > 0);
    % data = data(idx, :);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%

    fig_idx = fig_idx + 1;
    fh = figure(fig_idx); clf;
    plot(data(:,1), data(:,2), 'bo');
    set(gca, 'xscale', 'log');
    set(gca, 'yscale', 'log');
    title(name);


    x = data(:,1);
    y = data(:,2) / sum(data(:,2));

    fit_data = fit_3seg_curve_auto_sim_internal_link(x, y, param.L, param.U, param.N, param.lambda, param.eta, 0);


    fig_idx = fig_idx + 1;
    fh = figure(fig_idx); clf;
    plot(x, y, 'bo');
    hold on;
    lh = plot(fit_data.xseg1, fit_data.est_yseg1, '-g');
    set(lh, 'LineWidth', 3); set(lh, 'Color', colors{3});
    lh = plot([fit_data.xseg2; fit_data.xseg3], fit_data.est_yseg1_others, ':g');
    set(lh, 'LineWidth', 3); set(lh, 'Color', colors{3});
    lh = plot(fit_data.xseg2, fit_data.est_yseg2, '-r');
    set(lh, 'LineWidth', 3); set(lh, 'Color', colors{1});
    lh = plot([fit_data.xseg1; fit_data.xseg3], fit_data.est_yseg2_others, ':r');
    set(lh, 'LineWidth', 3); set(lh, 'Color', colors{1});
    lh = plot(fit_data.xseg3, fit_data.est_yseg3, '-y');
    set(lh, 'LineWidth', 3); set(lh, 'Color', colors{5});
    lh = plot([fit_data.xseg1; fit_data.xseg2], fit_data.est_yseg3_others, ':y');
    set(lh, 'LineWidth', 3); set(lh, 'Color', colors{5});
    set(gca, 'xscale', 'log');
    set(gca, 'yscale', 'log');
    % set(gca, 'ylim', [min(y(y>0)) max(y)*1.1]);
    set(gca, 'ylim', [min(y(y>0)) Inf]);
    title(name);

    % fit_data.xseg3'
    % fit_data.est_yseg3'
    return







    %% --------------------
    %% Find L and U
    %% --------------------
    if DEBUG2, fprintf('Find L and U\n'); end

    x_mins             = config.x_mins;
    default.x_max      = config.default_x_max;
    default.thresh_min = config.default_thresh_min;
    [x_min, x_max, Dmins, Dmaxs, x_mins, x_maxs] = find_mc_min_max(data, x_mins, config.x_maxs, default);

    L = x_min;
    U = x_max;


    if strcmp(name, 'sim')
        x_min = param.L;
        x_max = param.U;
    end

    idx = find(Dmaxs ~= Inf);
    Dmaxs  = Dmaxs(idx);
    x_maxs = x_maxs(idx);

    fig_idx = fig_idx + 1;
    fh = figure(fig_idx); clf;
    subplot(1,2,1);
    plot(x_mins, Dmins, '-b*');
    set(gca, 'yscale', 'log');
    title('D: find x_{min}');

    subplot(1,2,2);
    plot(x_maxs, Dmaxs, '-b*');
    set(gca, 'yscale', 'log');
    title('D: find x_{max}');


    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Convert x back
    % x_min = orig_x()
    %%%%%%%%%%%%%%%%%%%%%%%%%%%


    %% --------------------
    %% Plot Result
    %% --------------------
    if DEBUG2, fprintf('Plot L and U\n'); end

    idx_min = find(data(:,1) >= x_min);
    idx_min = idx_min(1);
    idx_max = find(data(:,1) <= x_max);
    idx_max = idx_max(end);

    emp_p  = cal_real_prob(data, x_min, x_max);
    emp_p2 = cal_real_prob(data2, 0, Inf);
    [est_p, exponent] = est_pl_prob(data, x_min, x_max);
    % [est_p, exponent] = est_pl_prob(data, 20, 100);

    p_x = data(:,2) / sum(data(:,2));
    ratio = p_x(1) / emp_p(1);
    est_p = est_p * ratio;
    emp_p = emp_p * ratio;

    fig_idx = fig_idx + 1;
    fh = figure(fig_idx); clf;
    plot(data(:,1), emp_p, 'bo');
    hold on;
    plot(data(idx_min:end,1), est_p(idx_min:end), '-r');
    plot(x_min, est_p(idx_min,1), 'go');
    plot(x_max, est_p(idx_max,1), 'go');
    set(gca, 'xscale', 'log');
    set(gca, 'yscale', 'log');
    title(sprintf('exponent=-%g', exponent))


    % logx = log10(data(:,1));
    % logy = log10(emp_p);
    % log_x_min = log10(x_min);
    % log_x_max = log10(x_max);
    % idx1 = find(logx == log_x_min);
    % idx2 = find(logx == log_x_max);
    % % [logx(idx1), logx(idx2)]
    % % [logy(idx1), logy(idx2)]
    % % logx(idx1:idx2)'
    % logy_est = interp1([logx(idx1), logx(idx2)], [logy(idx1), logy(idx2)], logx(idx1:idx2));
    % fig_idx = fig_idx + 1;
    % fh = figure(fig_idx); clf;
    % plot(logx, logy, 'bo');
    % hold on;
    % plot(logx(idx1:idx2), logy_est, '-r');
    % % plot(x_min, est_p(idx_min,1), 'go');
    % % plot(x_max, est_p(idx_max,1), 'go');
    % title(sprintf('exponent=-%g', exponent))


    %% --------------------
    %% Fitting
    %% --------------------
    if DEBUG2, fprintf('Fitting\n'); end

    x = data(:,1);
    y = emp_p;
    x2 = data2(:,1);
    y2 = emp_p2;
    % L = x_min;
    % U = x_max;
    if strcmp(name, 'sim')
        [fit_data, fit_param, fit_data2, fit_param2] = fit_3seg_curve_auto_sim_internal_link(x, y, x2, y2, x_min, x_max, param.N, 0);
    else
        [fit_data] = fit_3seg_curve_auto_exp(x, y, x_min, x_max, 0);
    end



    %% ----------------------
    %% Output Results
    %% ----------------------
    % if DEBUG2, fprintf('Output Results\n'); end

    % filename = [output_dir name];
    % if strcmp(name, 'sim')
    %     filename = sprintf('%ssim.N%d.L%d.U%d', output_dir, N, L, U);
    % end


    % if param.L~=param.U
    %     dlmwrite([filename '.emp.txt'], [x, y], 'delimiter', '\t');
    %     dlmwrite([filename '.Dmin.txt'], [x_mins', Dmins'], 'delimiter', '\t');
    %     dlmwrite([filename '.Dmax.txt'], [x_maxs', Dmaxs'], 'delimiter', '\t');


    %     if param.L == 1 & param.U == param.N
    %         dlmwrite([filename '.phase2-2.txt'], [x, fit_data.est_y], 'delimiter', '\t');
    %     elseif param.L > 1 & param.U == param.N
    %         dlmwrite([filename '.phase1-1.txt'], [fit_data.xseg1, fit_data.est_yseg1], 'delimiter', '\t');
    %         dlmwrite([filename '.phase1-2.txt'], [fit_data.xseg2, fit_data.est_yseg1_others], 'delimiter', '\t');
    %         dlmwrite([filename '.phase2-2.txt'], [fit_data.xseg2(2:end), fit_data.est_yseg2(2:end)], 'delimiter', '\t');
    %         dlmwrite([filename '.phase2-1.txt'], [fit_data.xseg1, fit_data.est_yseg2_others], 'delimiter', '\t');
    %     else
    %         dlmwrite([filename '.phase1-1.txt'], [fit_data.xseg1, fit_data.est_yseg1], 'delimiter', '\t');
    %         dlmwrite([filename '.phase1-23.txt'], [[fit_data.xseg2; fit_data.xseg3], fit_data.est_yseg1_others], 'delimiter', '\t');
    %         dlmwrite([filename '.phase2-2.txt'], [fit_data.xseg2(2:end), fit_data.est_yseg2(2:end)], 'delimiter', '\t');
    %         dlmwrite([filename '.phase2-13.txt'], [[fit_data.xseg1; fit_data.xseg3], fit_data.est_yseg2_others], 'delimiter', '\t');
    %         dlmwrite([filename '.phase3-3.txt'], [fit_data.xseg3, fit_data.est_yseg3], 'delimiter', '\t');
    %         dlmwrite([filename '.phase3-12.txt'], [[fit_data.xseg1; fit_data.xseg2], fit_data.est_yseg3_others], 'delimiter', '\t');
    %     end
    % else
    %     % [fit_data1] = fit_exp(data, L, U, N, fig_param);
    %     % plot_lognormal(data, L, U, N, fig_param);
    %     dlmwrite([filename '.exp.est.txt'], [x, fit_data.est_y], 'delimiter', '\t');
    %     dlmwrite([filename '.exp.emp.txt'], [x, y], 'delimiter', '\t');

    %     % fit_poisson(data2, L, U, N, fig_param);
    %     dlmwrite([filename '.poisson.est.txt'], [x2, fit_data2.est_y], 'delimiter', '\t');
    %     dlmwrite([filename '.poisson.emp.txt'], [x2, y2], 'delimiter', '\t');
    % end



    %% ----------------------
    %% Plot Results
    %% ----------------------
    if DEBUG2, fprintf('Plot Results\n'); end


    fig_idx = fig_idx + 1;
    fh = figure(fig_idx); clf;
    lh = plot(x, y, 'bo');
    set(lh, 'MarkerSize', 15);
    hold on;

    if param.L~=param.U
        if param.L == 1 & param.U == param.N
            lh = plot(x, fit_data.est_y, '-r');
            set(lh, 'LineWidth', 2);
        elseif param.L > 1 & param.U == param.N
            lh = plot(fit_data.xseg1, fit_data.est_yseg1, '-g');
            set(lh, 'LineWidth', 2);
            lh = plot(fit_data.xseg2, fit_data.est_yseg2, '-r');
            set(lh, 'LineWidth', 2);

            lh = plot(fit_data.xseg2, fit_data.est_yseg1_others, '--g');
            set(lh, 'LineWidth', 2);
            lh = plot(fit_data.xseg1, fit_data.est_yseg2_others, '--r');
            set(lh, 'LineWidth', 2);
        else
            lh = plot(fit_data.xseg1, fit_data.est_yseg1, '-g');
            set(lh, 'LineWidth', 2);
            lh = plot(fit_data.xseg2, fit_data.est_yseg2, '-r');
            set(lh, 'LineWidth', 2);
            lh = plot(fit_data.xseg3, fit_data.est_yseg3, '-m');
            set(lh, 'LineWidth', 2);

            lh = plot([fit_data.xseg2; fit_data.xseg3], fit_data.est_yseg1_others, '--g');
            set(lh, 'LineWidth', 2);
            lh = plot([fit_data.xseg1; fit_data.xseg3], fit_data.est_yseg2_others, '--r');
            set(lh, 'LineWidth', 2);
            lh = plot([fit_data.xseg1; fit_data.xseg2], fit_data.est_yseg3_others, '--m');
            set(lh, 'LineWidth', 2);
        end

        set(gca, 'xscale', 'log');
        set(gca, 'yscale', 'log');
    else
        fh = figure(fig_idx); clf;

        subplot(1,2,1)
        lh = plot(x, y, 'bo');
        set(lh, 'MarkerSize', 15);
        hold on;
        lh = plot(x, fit_data.est_y, '-r');
        set(lh, 'LineWidth', 2);
        set(gca, 'xscale', 'log');
        set(gca, 'yscale', 'log');

        subplot(1,2,2)
        lh = plot(x2, y2, 'bo');
        set(lh, 'MarkerSize', 15);
        hold on;
        lh = plot(x2, fit_data2.est_y, '-r');
        set(lh, 'LineWidth', 2);
    end

    set(gca, 'ylim', [min(y(y>0)) max(y)*1.1]);
    % waitforbuttonpress

    if strcmp(name, 'sim')
        return
    end


    %% ----------------------
    %% Fitting Error
    %% ----------------------
    if DEBUG2, fprintf('Fitting Error\n'); end

    %% our model
    midx = 1;
    models{midx} = 'IC';

    est_y = [fit_data.est_yseg1; fit_data.est_yseg2; fit_data.est_yseg3];
    est_y = est_y / sum(est_y);
    real_y = [fit_data.yseg1; fit_data.yseg2; fit_data.yseg3];
    real_y = real_y / sum(real_y);

    est_err(midx) = cal_err(est_y, real_y);
    % est_ks_err(midx) = max(abs(est_y - real_y));
    est_ks_err(midx) = ks_dist(est_y, real_y);
    k    = 3+1;
    n    = length(y);
    % logL = log10(mean(est_y.*real_y));
    logL = -log10(est_err(midx));
    [aics(midx), bics(midx)] = aicbic(logL, k, n);


    %% Power Law
    midx = midx + 1;
    models{midx} = 'PL';

    idx = 1:length(fit_data.xseg1);
    est_pl_y = [fit_data.est_yseg2_others(idx); fit_data.est_yseg2(2:(end-1)); fit_data.est_yseg2_others((length(idx)+1):end)];
    est_pl_y = est_pl_y / sum(est_pl_y);

    est_err(midx) = cal_err(est_pl_y, y);
    % est_ks_err(midx) = max(abs(est_pl_y - y));
    est_ks_err(midx) = ks_dist(est_pl_y, y);
    k    = 2+1;
    n    = length(real_y);
    % logL = log10(mean(est_pl_y.*y));
    logL = -log10(est_err(midx));
    [aics(midx), bics(midx)] = aicbic(logL, k, n);


    %% Power-Law with expotential cutoff
    midx = midx + 1;
    models{midx} = 'PLC';

    x_nz = x(find(y>0));
    y_nz = y(find(y>0));
    fit_param_plcut = fit_pl_cutoff_log(x_nz, y_nz);
    est_plcut_y = close_form_pl_cutoff(fit_param_plcut, x);
    est_plcut_y = est_plcut_y / sum(est_plcut_y);
    % fh = figure(4); clf;
    % plot(x, y, 'bo');
    % hold on;
    % plot(x, est_plcut_y, '-r');
    % set(gca, 'xscale', 'log');
    % set(gca, 'yscale', 'log');
    % set(gca, 'ylim', [min(y(y>0)) max(y)*1.1]);
    est_err(midx) = cal_err(est_plcut_y, y);
    % est_ks_err(midx) = max(abs(est_plcut_y - y));
    est_ks_err(midx) = ks_dist(est_plcut_y, y);
    k    = 3+1;
    n    = length(est_plcut_y);
    % logL = log10(mean(est_plcut_y.*y));
    logL = -log10(est_err(midx));
    [aics(midx), bics(midx)] = aicbic(logL, k, n);


    %% Power-Law latest literature
    midx = midx + 1;
    models{midx} = 'PLN';

    x_nz = x(find(y>0));
    y_nz = y(find(y>0));
    fit_param_plnew = fit_pl_new_log(x_nz, y_nz);
    est_plnew_y = close_form_pl_new(fit_param_plnew, x);
    est_plnew_y = est_plnew_y / sum(est_plnew_y);
    % fh = figure(4); clf;
    % plot(x, y, 'bo');
    % hold on;
    % plot(x, est_plnew_y, '-r');
    % set(gca, 'xscale', 'log');
    % set(gca, 'yscale', 'log');
    % set(gca, 'ylim', [min(y(y>0)) max(y)*1.1]);
    % pause
    est_err(midx) = cal_err(est_plnew_y, y);
    % est_ks_err(midx) = max(abs(est_plnew_y - y));
    est_ks_err(midx) = ks_dist(est_plnew_y, y);
    k    = 3+1;
    n    = length(est_plnew_y);
    % logL = log10(mean(est_plnew_y.*y));
    logL = -log10(est_err(midx));
    [aics(midx), bics(midx)] = aicbic(logL, k, n);


    for midx = 1:length(models)
        fprintf('  %s:\tErr=%.5f,\tKS Err=%.5f,\tAIC=%.5f,\tBIC=%.5f\n', char(models{midx}), est_err(midx), est_ks_err(midx), aics(midx), bics(midx));
    end

    dlmwrite([filename '.err.txt'], [est_err', est_ks_err', aics', bics'], 'delimiter', '\t');
    dlmwrite([filename '.LU.txt'], [L U], 'delimiter', '\t');

    errs = [est_err, est_ks_err, aics, bics];

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function config = get_config(name, para)
    if strcmp(name, 'sim')
        config.x_mins = [1:para.L+5];
        config.x_maxs = [];
        config.default_x_max = -1;
        config.default_thresh_min = -1;
    else
        if strcmp(name, 'coauthor')
            config.x_mins = [1:100];
            config.x_maxs = [];
            config.default_x_max = -1;
            config.default_thresh_min = -1;

        elseif strcmp(name, 'dblp')
            config.x_mins = [1:50];
            config.x_maxs = [];
            config.default_x_max = -1;
            config.default_thresh_min = -1;

        elseif strcmp(name, 'coauthor_network')
            config.x_mins = [1:20];
            config.x_maxs = [15:45];
            config.default_x_max = -1;
            config.default_thresh_min = -1;

        elseif strcmp(name, 'dblp_network')
            config.x_mins = [1:30];
            config.x_maxs = [19:35];
            config.default_x_max = -1;
            config.default_thresh_min = -1;

        elseif strcmp(name, 'aps')
            config.x_mins = [1:100];
            config.x_maxs = [];
            config.default_x_max = -1;
            config.default_thresh_min = -1;

        elseif strcmp(name, 'patent')
            config.x_mins = [1:30];
            config.x_maxs = [];
            config.default_x_max = -1;
            config.default_thresh_min = -1;

        elseif strcmp(name, 'facebook')
            config.x_mins = [1:19];
            config.x_maxs = [20:35];
            config.default_x_max = 20;
            config.default_thresh_min = 2e-2;

        elseif strcmp(name, 'twitter')
            config.x_mins = [1:50];
            config.x_maxs = [30:300];
            config.default_x_max = 70;
            config.default_thresh_min = 1e-3;

        elseif strcmp(name, 'rome')
            config.x_mins = [1:14];
            config.x_maxs = [15:50];
            config.default_x_max = 15;
            config.default_thresh_min = 1e-2;

        elseif strcmp(name, 'beijing')
            config.x_mins = [1:45];
            config.x_maxs = [];
            config.default_x_max = 50;
            config.default_thresh_min = -1;

        elseif strcmp(name, 'sf')
            config.x_mins = [1:50];
            config.x_maxs = [50:80];
            config.default_x_max = 60;
            config.default_thresh_min = -1;

        end

    end
end

