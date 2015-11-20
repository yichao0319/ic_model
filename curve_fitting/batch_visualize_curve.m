% visualize_curve('../../data/kddcup99/processed/', 'kddcup99.dl_byte', 100);
% visualize_curve('../../data/MovieTweetings/processed/', 'movietweetings.movie_rate_cnt', 1);
% visualize_curve('../../data/MovieTweetings/processed/', 'movietweetings.user_rate_cnt', 1);
% visualize_curve('../../data/NetflixPrize/processed/', 'qualifying.movie_rate_cnt', 1);


% visualize_curve('../../data/citation/processed/', 'publications.num_cite_all_papers', 1);
% visualize_curve('../../data/citation/processed/', 'ai.num_cite_all_papers', 1);
% visualize_curve('../../data/citation/processed/', 'database.num_cite_all_papers', 1);
% visualize_curve('../../data/citation/processed/', 'graphics.num_cite_all_papers', 1);
% visualize_curve('../../data/citation/processed/', 'hci.num_cite_all_papers', 1);
% visualize_curve('../../data/citation/processed/', 'hp_computing.num_cite_all_papers', 1);
% visualize_curve('../../data/citation/processed/', 'interdisciplinary.num_cite_all_papers', 1);
% visualize_curve('../../data/citation/processed/', 'networks.num_cite_all_papers', 1);
% visualize_curve('../../data/citation/processed/', 'security.num_cite_all_papers', 1);
% visualize_curve('../../data/citation/processed/', 'software_engineering.num_cite_all_papers', 1);
% visualize_curve('../../data/citation/processed/', 'theoretical.num_cite_all_papers', 1);


% visualize_curve('../../data/citation/processed/', 'publications.num_coauthor_all_authors', 1);
% visualize_curve('../../data/citation/processed/', 'ai.num_coauthor_all_authors', 1);
% visualize_curve('../../data/citation/processed/', 'database.num_coauthor_all_authors', 1);
% visualize_curve('../../data/citation/processed/', 'graphics.num_coauthor_all_authors', 1);
% visualize_curve('../../data/citation/processed/', 'hci.num_coauthor_all_authors', 1);
% visualize_curve('../../data/citation/processed/', 'hp_computing.num_coauthor_all_authors', 1);
% visualize_curve('../../data/citation/processed/', 'interdisciplinary.num_coauthor_all_authors', 1);
% visualize_curve('../../data/citation/processed/', 'networks.num_coauthor_all_authors', 1);
% visualize_curve('../../data/citation/processed/', 'security.num_coauthor_all_authors', 1);
% visualize_curve('../../data/citation/processed/', 'software_engineering.num_coauthor_all_authors', 1);
% visualize_curve('../../data/citation/processed/', 'theoretical.num_coauthor_all_authors', 1);


% visualize_curve('../../data/citation/processed/', 'publications.num_cite_one_author.Wei Wang', 1);
% visualize_curve('../../data/citation/processed/', 'publications.num_coauthor_times_one_author.Wei Wang', 1);


% visualize_curve('../../data/rome_taxi/processed/', 'range100.contact_dur', 100);
% visualize_curve('../../data/rome_taxi/processed/', 'range200.contact_dur', 100);


% visualize_curve('../../data/sigcomm09/processed/', 'proximity.num_seen', 150);

codes = {'shanghai_taxi' 'rome_taxi' 'sf_taxi' 'seattle_bus' 'beijing_taxi'};
% codes = {'shanghai_taxi' 'beijing_taxi'};
itvls = [10 60 120 300 600];
ranges = [100 500 1000 5000 10000];

for ci = 1:length(codes)
    code = char(codes{ci});

    for ii = 1:length(itvls)
        itvl = itvls(ii);

        for ri = 1:length(ranges)
            range = ranges(ri);

            dirname = sprintf('../../data/%s/processed/', code);
            filename = sprintf('counts.%d.%d', itvl, range);
            
            if exist([dirname filename '.txt'], 'file') == 2
                fprintf('%s%s.txt: exists\n', dirname, filename);
                visualize_curve(dirname, filename, 1);
            else
                fprintf('%s%s.txt: not exists\n', dirname, filename);
            end
        end
    end
end
