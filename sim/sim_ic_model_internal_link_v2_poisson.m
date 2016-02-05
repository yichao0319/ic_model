function [a, exponent] = sim_ic_model_internal_link_v2_poisson(N, itvl)
    % N = 100000;
    % N = 1000;
    if nargin < 1, N = 100000; end

    L = 1;
    U = 1;

    output_dir = './data/';
    fig_dir = './fig/';
    font_size = 18;

    star = round(N*rand); %a random index of 300,000
    A = randperm(N);
    k = zeros(1, N);

    N2 = round(N/2);


    for i = N2+1:N
        % fprintf('%d / %d\n', i, N);
        show_progress(i-N2, N-N2, 1);

        %% ---------------------
        %% new node
        %% ---------------------
        k(A(i)) = 1;


        %% ---------------------
        %% attach to a node
        %% ---------------------
        idx = round(rand * (i-2)) + 1;
        k(A(idx)) = k(A(idx)) + 1;


        %% ---------------------
        %% select an existing node to attach to others
        %% ---------------------
        if i > N2+10 & mod(i,itvl) == 0
            %% select an existing node
            idx = round(rand * (i-2)) + 1;
            k(A(idx)) = k(A(idx)) + 1;

            %% attach to another node
            idx2 = idx;
            while(idx2 == idx)
                idx2 = round(rand * (i-2)) + 1;
            end
            k(A(idx2)) = k(A(idx2)) + 1;
        end
    end

    %% only see the first N2 nodes
    k = k(A(1:N2));
    % K(sim) = k(star);
    x = [min(k):max(k)]';
    y = histc(k, x)';



    %% --------------------
    %% save values
    %% --------------------
    dlmwrite(sprintf('%sL%dU%dN%d.internal_link_v2.itvl%d.poisson.txt', output_dir, L, U, N, itvl), [x, y], 'delimiter', '\t');
end


