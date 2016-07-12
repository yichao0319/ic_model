%% get_data
function [data, data2] = get_data(name, para)
    if strcmp(name, 'sim')
        [data, data2] = get_sim_data(para.L, para.U, para.N, para.nseed);
    else
        [data, data2] = get_exp_data(name);
    end
end


function [data, data2] = get_sim_data(L, U, N, nseed)
    input_dir = '../plot/nature_comm/data/sim/';

    max_x = 100000;
    data = zeros(max_x, 2);
    data(:,1) = 1:max_x;
    data2 = zeros(max_x+1, 2); %% start from 0
    data2(:,1) = 0:max_x;
    for seed = [1:nseed]
        filename = sprintf('L%dU%dN%d.seed%d', L, U, N, seed);

        fullfilename = [input_dir filename '.txt'];
        if exist(fullfilename, 'file') == 2
            % fprintf('  file: %s\n', fullfilename);
            tmp = load(fullfilename);

            data(tmp(:,1), 2) = data(tmp(:,1), 2) + tmp(:,2);
        else
            error('  file not exists: %s', fullfilename);
        end

        %% Poisson files
        filename = sprintf('L%dU%dN%d.seed%d.poisson', L, U, N, seed);
        fullfilename = [input_dir filename '.txt'];
        if exist(fullfilename, 'file') == 2
            tmp = load(fullfilename);

            data2(tmp(:,1)+1, 2) = data2(tmp(:,1)+1, 2) + tmp(:,2);
        end
    end

    max_x = find(data(:,2) > 0);
    max_x = max_x(end);
    data = data(1:max_x, :);
    % size(data)
    % data
    % return
    if data2(1,2) > 0
        max_x2 = find(data2(:,2) > 0);
        max_x2 = max_x2(end);
        data2 = data2(1:max_x2, :);
    end
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
