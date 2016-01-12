% Generate 300,000 points
% Focus on 1 particular node * among the 300,000 points

%% sim_ic_model_v2: function description
function sim_ic_model_v3_poisson(N, seed)
    % N = 100000;
    % N = 1000;
    if nargin < 1, N = 100000; end
    if nargin < 2, seed = 1; end

    rng(seed);

    
    L = 1;
    U = 1;

    % output_dir = './data/';
    output_dir = '../../data/sim/data/';
    % fig_dir = './fig/';
    % font_size = 18;
    
    star = round(N*rand); %a random index of 300,000
    A = randperm(N);
    k = zeros(1, N);
    k_hat = zeros(1, N);

    N2 = round(N/2);


    for i = N2+1:N
        % fprintf('%d / %d\n', i, N);
        show_progress(i-N2, N-N2, 1);

        k(A(i)) = 1;
        
        idx = round(rand * (i-2)) + 1;
        k(A(idx)) = k(A(idx)) + 1;
    end

    %% only see the first N2 nodes
    k = k(A(1:N2));
    % K(sim) = k(star);
    x = [min(k):max(k)]';
    y = histc(k, x)';



    %% --------------------
    %% save values
    %% --------------------
    dlmwrite(sprintf('%sL%dU%dN%d.seed%d.poisson.txt', output_dir, L, U, N, seed), [x, y], 'delimiter', '\t');
end



