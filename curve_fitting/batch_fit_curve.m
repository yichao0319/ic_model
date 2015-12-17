
function batch_fit_curve
    
    di = 0;

    di = di + 1;
    name{di} = 'DBLP Citations';
    [rmse_our(di), rmse_pl(di), p(di), exponent(di), slope(di)] = fit_curve_manual('../../data/citation/processed/', 'publications.num_cite_all_papers', 1);

    di = di + 1;
    name{di} = 'DBLP Networking Citations';
    [rmse_our(di), rmse_pl(di), p(di), exponent(di), slope(di)] = fit_curve_manual('../../data/citation/processed/', 'networks.num_cite_all_papers', 1);

    di = di + 1;
    name{di} = 'DBLP Coauthorship';
    [rmse_our(di), rmse_pl(di), p(di), exponent(di), slope(di)] = fit_curve_manual('../../data/citation/processed/', 'publications.num_coauthor_all_authors', 1);

    di = di + 1;
    name{di} = 'DBLP Networking Coauthorship';
    [rmse_our(di), rmse_pl(di), p(di), exponent(di), slope(di)] = fit_curve_manual('../../data/citation/processed/', 'networks.num_coauthor_all_authors', 1);

    di = di + 1;
    name{di} = 'Facebook';
    [rmse_our(di), rmse_pl(di), p(di), exponent(di), slope(di)] = fit_curve_manual('../../data/facebook/processed/', 'facebook_combined', 3);

    di = di + 1;
    name{di} = 'Twitter';
    [rmse_our(di), rmse_pl(di), p(di), exponent(di), slope(di)] = fit_curve_manual('../../data/twitter/processed/', 'twitter_combined', 2);

    di = di + 1;
    name{di} = 'US Patent Citations';
    [rmse_our(di), rmse_pl(di), p(di), exponent(di), slope(di)] = fit_curve_manual('../../data/us_patent_cit/processed/', 'cit-Patents', 2);

    di = di + 1;
    name{di} = 'APS Citations';
    [rmse_our(di), rmse_pl(di), p(di), exponent(di), slope(di)] = fit_curve_manual('../../data/aps_citation/processed/', 'aps-dataset-citations-2013', 1);

    di = di + 1;
    name{di} = 'Rome Taxi Contact Counts';
    [rmse_our(di), rmse_pl(di), p(di), exponent(di), slope(di)] = fit_curve_manual('../../data/rome_taxi/processed/', 'counts.120.1000', 1);

    di = di + 1;
    name{di} = 'SF Contact Counts';
    [rmse_our(di), rmse_pl(di), p(di), exponent(di), slope(di)] = fit_curve_manual('../../data/sf_taxi/processed/', 'counts.120.1000', 1);

    di = di + 1;
    name{di} = 'Beijing Contact Counts';
    [rmse_our(di), rmse_pl(di), p(di), exponent(di), slope(di)] = fit_curve_manual('../../data/beijing_taxi/processed/', 'counts.300.1000', 1);

    % di = di + 1;
    % name{di} = 'Rome Contact Time R=100m';
    % [rmse_our(di), rmse_pl(di), p(di), exponent(di), slope(di)] = fit_curve_manual('../../data/rome_taxi/processed/', 'range100.contact_dur', 100);

    % di = di + 1;
    % name{di} = 'Rome Contact Time R=200m';
    % [rmse_our(di), rmse_pl(di), p(di), exponent(di), slope(di)] = fit_curve_manual('../../data/rome_taxi/processed/', 'range200.contact_dur', 100);

    %% -----------------
    %% rank
    di = di + 1;
    name{di} = 'DBLP Citation-Rank';
    [rmse_our(di), rmse_pl(di), p(di), exponent(di), slope(di)] = fit_rank_value_manual('../../data/citation/processed/', 'publications.num_cite_all_papers');
    
    di = di + 1;
    name{di} = 'DBLP Coauthroship-Rank';
    [rmse_our(di), rmse_pl(di), p(di), exponent(di), slope(di)] = fit_rank_value_manual('../../data/citation/processed/', 'publications.num_coauthor_all_authors');

    %% -----------------
    %% Output results
    fileID = fopen(['../../data/curve_fitting/visualize_manual_results.txt'], 'w');
    fprintf(fileID, 'Dataset, p (Geometric), exponent (Power-Law), slope, RMSE: Ours, RMSE: Power-Law, Improvement\n');
    for di = 1:length(name)
        di
        name{di}
        p(di)
        fprintf(fileID, '%s, %f, %f, %f, %f, %f, %f\n', name{di}, p(di), exponent(di), slope(di), rmse_our(di), rmse_pl(di), (rmse_pl(di)-rmse_our(di))/rmse_pl(di));
    end
    fclose(fileID);
end