%% sim_ic_model_internal_link_v2(100000, 2, 8, 1, 'cal')
%% sim_ic_model_internal_link_v2(100000, 3, 10, 1, 'cal')
%% sim_ic_model_internal_link_v2(100000, 1, 1, 1, 'cal')
%% sim_ic_model_internal_link_v2(100000, 1, 100000, 1, 'cal')
%% sim_ic_model_internal_link_v2(100000, 3, 100000, 1, 'cal')
%% sim_ic_model_internal_link_v2(100000, 1, 10, 1, 'cal')

function test_sim_ic_model_internal_link_v2()
    N = 100;
    L = 2;
    U = 8;
    itvl = 1;
    sel_type = 'cal';

    for seed = 1:100000
        sim_ic_model_internal_link_v2(N, L, U, itvl, sel_type, seed);
    end
end