%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Yi-Chao Chen @ Huawei
%%
%% - Input:
%%
%%
%% - Output:
%%
%%
%% example:
%%  fit_curve_manual('../../data/citation/processed/', 'publications.num_cite_all_papers', 1);
%%  fit_curve_manual('../../data/citation/processed/', 'ai.num_cite_all_papers', 1);
%%  fit_curve_manual('../../data/citation/processed/', 'networks.num_cite_all_papers', 1);
%%
%%  fit_curve_manual('../../data/citation/processed/', 'publications.num_coauthor_all_authors', 1);
%%  fit_curve_manual('../../data/citation/processed/', 'ai.num_coauthor_all_authors', 1);
%%  fit_curve_manual('../../data/citation/processed/', 'networks.num_coauthor_all_authors', 1);
%%
%%  fit_curve_manual('../../data/rome_taxi/processed/', 'range100.contact_dur', 100);
%%  fit_curve_manual('../../data/rome_taxi/processed/', 'range200.contact_dur', 100);
%%
%%  fit_curve_manual('../../data/rome_taxi/processed/', 'counts.60.100', 1);
%%
%%  fit_curve_manual('../../data/shanghai_bus/processed/', 'range100.contact_dur', 2000);
%%  fit_curve_manual('../../data/shanghai_bus/processed/', 'range200.contact_dur', 6000);
%%     
%%  fit_curve_manual('../../data/shanghai_taxi/processed/', 'range100.contact_dur', 1);
%%  fit_curve_manual('../../data/shanghai_taxi/processed/', 'range200.contact_dur', 1);
%%
%%  fit_curve_manual('../../data/facebook/processed/', 'facebook_combined', 3);
%%  fit_curve_manual('../../data/twitter/processed/', 'twitter_combined', 2);
%%  fit_curve_manual('../../data/us_patent_cit/processed/', 'cit-Patents', 2);
%%
%%  fit_curve_manual('../../data/beijing_taxi/processed/', 'counts.300.1000', 1);
%%  fit_curve_manual('../../data/sf_taxi/processed/', 'counts.120.1000', 1);
%%  fit_curve_manual('../../data/rome_taxi/processed/', 'counts.120.1000', 1);
%%
%%  fit_curve_manual('../../data/aps_citation/processed/', 'aps-dataset-citations-2013', 1);
%%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function fit_curve_auto(input_dir, filename, binsize, ranked)
    
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
    output_dir = './tmp/';
    font_size = 18;


    %% --------------------
    %% Variable
    %% --------------------
    fig_idx = 0;
    

    %% --------------------
    %% Check input
    %% --------------------
    if nargin < 1, input_dir = '../../data/kddcup99/processed/'; end
    if nargin < 2, filename = 'kddcup99.dl_byte'; end
    if nargin < 3, binsize = 1; end
    if nargin < 4, ranked = 0; end

    [L, U] = get_properties(filename, input_dir, ranked);
    L
    U
    input('')


    %% --------------------
    %% Main starts
    %% --------------------
    
    %% --------------------
    %% Read data
    %% --------------------
    if DEBUG2, fprintf('Read Data\n'); end

    data = load([input_dir filename '.txt']);
    fprintf('  size = %dx%d\n', size(data));
    fprintf('  L = %f, U = %f\n', L, U);

    if findstr(filename, 'contact')
        data = data - min(data);
        data = data(data > 0);
    end

    if ranked
        %% --------------------
        %% ranking
        %% --------------------
        if DEBUG2, fprintf('Ranking\n'); end

        rank_cnt = sort((data), 'descend');
        
        y = rank_cnt / sum(rank_cnt);
        x = [1:length(y)]';
    else
        %% --------------------
        %% Put to bins
        %% --------------------
        if DEBUG2, fprintf('Put to bins\n'); end

        x = [min(data):binsize:max(data)+1]';
        y = histc(data, x);
        % if x(1) == 0
        %     x = x + 1;
        % end
        if length(findstr(input_dir, 'rome_taxi'))>0 & length(findstr(filename, 'contact_dur'))>0
            y = y(2:end);
            x = x(2:end);
        end
        idx = find(x > 0);
        x = x(idx);
        y = y(idx);
        y = y / sum(y);
    end
    


    %% ----------------------
    %% Fitting
    %% ----------------------
    if DEBUG2, fprintf('Fitting\n'); end

    [L, U, p1, p_hat, pl_curve, p3, c] = fit_3seg_curve_auto(x, y, L, U, DEBUG4);
    alpha = pl_curve.a;
    exponent = pl_curve.b;


    %% ----------------------
    %% Fitting Error
    %% ----------------------
    if DEBUG2, fprintf('Fitting Error\n'); end

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
    % est_yseg1

    % est_yseg1_others = phase1_close_form_v2_tail([p1, p_hat], [xseg2; xseg3]);
    est_yseg1_others = phase1_close_form_v3_tail([p1, p_hat], [xseg2; xseg3]);
    est_yseg2_others = pl_curve([xseg1; xseg3]);
    est_yseg3_others = phase3_close_form([p3 c], [xseg1; xseg2]);

    %% our model
    est_err1 = cal_err(est_yseg1, yseg1);
    est_err2 = cal_err(est_yseg2, yseg2);
    est_err3 = cal_err(est_yseg3, yseg3);
    est_err = (est_err1*length(xseg1) + est_err2*length(xseg2) + est_err3*length(xseg3)) / (length(xseg1)+length(xseg2)+length(xseg3));

    est_pl_y = pl_curve(x);
    est_pl_err = cal_err(est_pl_y, y);

    fprintf('  Error: ours=%f, pl=%f\n', est_err, est_pl_err);

    %% KS test
    gen_orig_data = randpdf(y, x, [10000,1]);
    gen_our_data  = randpdf([est_yseg1(1:end-1); est_yseg2; est_yseg3(2:end)], x, [10000,1]);
    gen_pl_data   = randpdf(est_pl_y, x, [10000,1]);

    [h1, pvalue1, ks2stat1] = kstest2(gen_orig_data, gen_our_data);
    [h2, pvalue2, ks2stat2] = kstest2(gen_orig_data, gen_pl_data);

    fprintf('  KS test: ours=%E, pl=%E (better: %d)\n', pvalue1, pvalue2, pvalue1>pvalue2);
    

    %% ---------------------
    %% Output files
    %% ---------------------
    if DEBUG2, fprintf('Output files\n'); end

    outfilename = get_output_filename(filename, input_dir, ranked);
    dlmwrite([output_dir 'fit_auto.' outfilename '.data.txt'], [x y], 'delimiter', '\t');
    dlmwrite([output_dir 'fit_auto.' outfilename '.phase1.a.txt'], [xseg1 est_yseg1], 'delimiter', '\t');
    dlmwrite([output_dir 'fit_auto.' outfilename '.phase1.bc.txt'], [[xseg2; xseg3] est_yseg1_others], 'delimiter', '\t');
    dlmwrite([output_dir 'fit_auto.' outfilename '.phase2.b.txt'], [xseg2 est_yseg2], 'delimiter', '\t');
    dlmwrite([output_dir 'fit_auto.' outfilename '.phase2.ac.txt'], [[xseg1; xseg3] est_yseg2_others], 'delimiter', '\t');
    dlmwrite([output_dir 'fit_auto.' outfilename '.phase3.c.txt'], [xseg3 est_yseg3], 'delimiter', '\t');
    dlmwrite([output_dir 'fit_auto.' outfilename '.phase3.ab.txt'], [[xseg1; xseg2] est_yseg3_others], 'delimiter', '\t');

    fileID = fopen([output_dir 'fit_auto.' outfilename '.param_and_err.txt'],'w');
    fprintf(fileID, '%f\n%f\n%f\n%f\n%f\n%f\n%f\n%f\n', L, U, p1, p_hat, alpha, exponent, p3, c);
    fprintf(fileID, '%f\n%f\n', est_err, est_pl_err);
    fprintf(fileID, '%E\n%E\n', pvalue1, pvalue2);
    fclose(fileID);
        
end




%% get_properties
function [L, U] = get_properties(filename, input_dir, ranked)
    if nargin < 2, input_dir = './'; end

    L = 0;
    U = Inf;
    % minx = -Inf;
    % maxx = Inf;
    % miny = -Inf;
    % maxy = Inf;

    if strcmp(filename, 'publications.num_cite_all_papers') & ranked == 0
        % L = 20;
        % U = 60;
        L = 18;
        U = 50;
    elseif strcmp(filename, 'publications.num_cite_all_papers') & ranked == 1
        L = 50;
        U = 10000;
    elseif strcmp(filename, 'ai.num_cite_all_papers')
        L = 20;
        U = 45;
    elseif strcmp(filename, 'networks.num_cite_all_papers')
        L = 15;
        U = 32;
    elseif strcmp(filename, 'publications.num_coauthor_all_authors') & ranked == 0
        L = 15;
        U = 100;
    elseif strcmp(filename, 'publications.num_coauthor_all_authors') & ranked == 1
        L = 50;
        U = 10000;
    elseif strcmp(filename, 'ai.num_coauthor_all_authors')
        L = 6;
        U = 28;
    elseif strcmp(filename, 'networks.num_coauthor_all_authors')
        L = 7;
        U = 30;
    elseif strcmp(filename, 'range100.contact_dur') & length(findstr(input_dir, 'rome_taxi'))>0
        L = 900;
        U = 5000;
    elseif strcmp(filename, 'range200.contact_dur') & length(findstr(input_dir, 'rome_taxi'))>0
        L = 800;
        U = 5000;
    elseif strcmp(filename, 'range100.contact_dur') & length(findstr(input_dir, 'shanghai_bus'))>0
        L = 40000;
        U = 60000;
    elseif strcmp(filename, 'range200.contact_dur') & length(findstr(input_dir, 'shanghai_bus'))>0
        L = 40000;
        U = 80000;
    elseif strcmp(filename, 'facebook_combined')
        L = 20;
        U = 100;
    elseif strcmp(filename, 'twitter_combined')
        L = 40;
        U = 200;
    elseif strcmp(filename, 'cit-Patents')
        L = 15;
        U = 150;
    elseif strcmp(filename, 'aps-dataset-citations-2013')
        L = 20;
        U = 150;
    elseif length(findstr(input_dir, 'beijing_taxi'))>0 & length(findstr(filename, 'counts'))>0
        L = 0;
        U = 25;
        % L = 0;
        % U = 10;
    elseif length(findstr(input_dir, 'sf_taxi'))>0 & length(findstr(filename, 'counts'))>0
        L = 0;
        U = 100;
    elseif length(findstr(input_dir, 'rome_taxi'))>0 & length(findstr(filename, 'counts'))>0
        L = 0;
        U = 15;
    end
end


%% get_figname
function filename = get_output_filename(filename, input_dir, ranked)
    suffix = '';
    if ranked, suffix = '.rank'; end

    if findstr(input_dir, 'rome_taxi')
        filename = ['rome_taxi.' filename];
    elseif findstr(input_dir, 'shanghai_bus')
        filename = ['shanghai_bus.' filename];
    elseif findstr(input_dir, 'shanghai_taxi')
        filename = ['shanghai_taxi.' filename];
    elseif findstr(input_dir, 'beijing_taxi')
        filename = ['beijing_taxi.' filename];
    elseif findstr(input_dir, 'sf_taxi')
        filename = ['sf_taxi.' filename];
    elseif findstr(input_dir, 'seattle_bus')
        filename = ['seattle_bus.' filename];
    else
        filename = [filename];
    end

    filename = [filename suffix];
end


%% get_plot_param
% function [x_ticks, y_ticks, x_label, y_label] = get_plot_param(filename, input_dir)
%     if nargin < 2, input_dir = './'; end

%     x_ticks = [];
%     y_ticks = [];
%     x_label = '';
%     y_label = '';
    

%     if strcmp(filename, 'publications.num_cite_all_papers')
%         % y_ticks = 10 .^ [0:5];
%         x_label = 'Citation Count x';
%         y_label = 'Number of Papers';
%     elseif strcmp(filename, 'ai.num_cite_all_papers')
%         x_label = 'Citation Count x';
%         y_label = 'Number of Papers';
%     elseif strcmp(filename, 'networks.num_cite_all_papers')
%         x_label = 'Citation Count x';
%         y_label = 'Number of Papers';
%     elseif strcmp(filename, 'publications.num_coauthor_all_authors')
%         % x_ticks = 10 .^ [0:3];
%         % y_ticks = 10 .^ [0:7];
%         x_label = 'Coauthor Count x';
%         y_label = 'Nummber of Scientists';
%     elseif strcmp(filename, 'ai.num_coauthor_all_authors')
%         x_label = 'Coauthor Count x';
%         y_label = 'Nummber of Scientists';
%     elseif strcmp(filename, 'networks.num_coauthor_all_authors')
%         x_label = 'Coauthor Count x';
%         y_label = 'Nummber of Scientists';
%     elseif strcmp(filename, 'range100.contact_dur') & length(findstr(input_dir, 'rome_taxi'))>0
%         x_label = 'Contact Duration (s)';
%         y_label = 'Number of Contacts';
%     elseif strcmp(filename, 'range200.contact_dur') & length(findstr(input_dir, 'rome_taxi'))>0
%         x_label = 'Contact Duration (s)';
%         y_label = 'Number of Contacts';
%     elseif strcmp(filename, 'range100.contact_dur') & length(findstr(input_dir, 'shanghai_bus'))>0
%         x_label = 'Contact Duration (s)';
%         y_label = 'Number of Contacts';
%     elseif strcmp(filename, 'range200.contact_dur') & length(findstr(input_dir, 'shanghai_bus'))>0
%         x_label = 'Contact Duration (s)';
%         y_label = 'Number of Contacts';
%     elseif strcmp(filename, 'facebook_combined')
%         x_label = 'Friend Count x';
%         y_label = 'Number of Users';
%     elseif strcmp(filename, 'twitter_combined')
%         x_label = 'Following People Count x';
%         y_label = 'Number of Users';
%     elseif strcmp(filename, 'cit-Patents')
%         x_label = 'Citation Count x';
%         y_label = 'Number of Patents';
%     elseif strcmp(filename, 'aps-dataset-citations-2013')
%         x_label = 'Citation Count x';
%         y_label = 'Number of Papers';
%     elseif length(findstr(input_dir, 'beijing_taxi'))>0 & length(findstr(filename, 'counts'))>0
%         x_label = 'Contact Count x';
%         y_label = 'Number of Vehicles';
%     elseif length(findstr(input_dir, 'sf_taxi'))>0 & length(findstr(filename, 'counts'))>0
%         x_label = 'Contact Count x';
%         y_label = 'Number of Vehicles';
%     elseif length(findstr(input_dir, 'rome_taxi'))>0 & length(findstr(filename, 'counts'))>0
%         x_label = 'Contact Count x';
%         y_label = 'Number of Vehicles';
%     elseif length(findstr(input_dir, 'shanghai_taxi'))>0 & length(findstr(filename, 'counts'))>0
%         x_label = 'Contact Count x';
%         y_label = 'Number of Vehicles';
%     end
%     y_label = 'Frequency';
% end


function [err] = cal_err(y_fit, y)
    err = mean(sqrt((y - y_fit).^2));
    % err = mean(sqrt((log(y) - log(y_fit)).^2));
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

function y = phase1_close_form_v3_tail(param, x)
    %% p_hat = y(1) / p / ((1-p)^(1-1));
    %% p = p1_hat*p*(1-p)^(k-1) + (p2_hat)*p*(1-p)^(k-2) + (p3_hat*p*(1-p)^(k-3) + 
    %%     (1-p1_hat-p2_hat-p3_hat)*p*(1-p)^(k-4)
    p = param(1);
    p_hat = param(2);

    y = p_hat * p * ((1-p).^(x-1));
    % y = y';
end

function y = phase3_close_form(param, x)
    %% p = c * p * (1-p)^(k-1)
    p = param(1);
    c = param(2);
    y = c * p * ((1-p).^(x-1));
end

