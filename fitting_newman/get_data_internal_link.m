%% get_data
function [data] = get_data_internal_link(name, para)
    if strcmp(name, 'sim')
        [data] = get_sim_data(para.L, para.U, para.N, para.lambda, para.eta);
    else
        [data] = get_exp_data(name);
    end
end


function [data] = get_sim_data(L, U, N, lambda, eta)
    input_dir = '../sim/data/';

    % data = load(sprintf('%sL%dU%dN%d.internal_link_v3.itvl%d.cal.txt', input_dir, L, U, N, itvl));
    data = load(sprintf('%sL%dU%dN%d.internal_link_v4.l%.2f.e%.2f.cal.txt', input_dir, L, U, N, lambda, eta));
end


function [data, data2] = get_exp_data(name)
    % input_dir = '../plot/nature_comm/data/exp/';

    if strcmp(name, 'coauthor')
        input_dir = '../../data/citation/processed/';
        filename = 'publications.num_coauthor_all_authors';
        binsize = 1;

    elseif strcmp(name, 'dblp')
        input_dir = '../../data/citation/processed/';
        filename = 'publications.num_cite_all_papers';
        binsize = 1;

    elseif strcmp(name, 'coauthor_network')
        input_dir = '../../data/citation/processed/';
        filename = 'networks.num_coauthor_all_authors';
        binsize = 1;

    elseif strcmp(name, 'dblp_network')
        input_dir = '../../data/citation/processed/';
        filename = 'networks.num_cite_all_papers';
        binsize = 1;

    elseif strcmp(name, 'aps')
        input_dir = '../../data/aps_citation/processed/';
        filename = 'aps-dataset-citations-2013';
        binsize = 1;

    elseif strcmp(name, 'patent')
        input_dir = '../../data/us_patent_cit/processed/';
        filename = 'cit-Patents';
        binsize = 1;

    elseif strcmp(name, 'facebook')
        input_dir = '../../data/facebook/processed/';
        filename = 'facebook_combined';
        binsize = 3;
        % binsize = 1;

    elseif strcmp(name, 'twitter')
        input_dir = '../../data/twitter/processed/';
        filename = 'twitter_combined';
        % binsize = 2;
        binsize = 1;

    elseif strcmp(name, 'rome')
        input_dir = '../../data/rome_taxi/processed/';
        filename = 'counts.120.1000';
        binsize = 1;

    elseif strcmp(name, 'beijing')
        input_dir = '../../data/beijing_taxi/processed/';
        filename = 'counts.300.1000';
        binsize = 1;

    elseif strcmp(name, 'sf')
        input_dir = '../../data/sf_taxi/processed/';
        filename = 'counts.120.1000';
        binsize = 1;

    end


    tmp = load([input_dir filename '.txt']);
    x_max = max(tmp);

    x = [min(tmp):binsize:max(tmp)+1]';
    h = histogram(tmp, x);
    y = h.Values';

    if binsize == 1
        data = [x(1:(end-1)) y];
        data2 = data;

    else
        xstd = min(tmp) + binsize/2;
        xend = x(end-1) + binsize/2;
        x = [xstd:binsize:xend]';
        data = [x y];

        x = [min(tmp):max(tmp)+1]';
        h = histogram(tmp, x);
        y = h.Values';

        data2 = [x(1:(end-1)) y];
    end

end
