%% sim_ic_model_internal_link_v4(2, 8, 1, 1, 2)
%% sim_ic_model_internal_link_v4(3, 10, 1, 1, 2)
%% sim_ic_model_internal_link_v4(1, 1, 1, 1, 2)
%% sim_ic_model_internal_link_v4(1, 100000, 1, 1, 2)
%% sim_ic_model_internal_link_v4(3, 100000, 1, 1, 2)

function sim_ic_model_internal_link_v4(L, U, lambda, eta, seed)
    DEBUG3 = 0;

    if nargin < 1, L = 1; end
    if nargin < 2, U = 1000000; end
    if nargin < 3, lambda = 1; end
    if nargin < 4, eta = 1; end
    if nargin < 5, seed = 1; end

    rng(seed);
    sel_type = 'cal';

    output_dir = './data/';
    fig_dir = './fig/';
    font_size = 18;
    total_sim = 1000;


    Ns = [1:3] * 10000;
    % Ns = [1:10] * 100;
    maxN = max(Ns);


    %% ---------------------
    %% poisson arrival of external and internal links
    %% ---------------------
    est_num_int = ceil(eta / lambda * maxN * 1.2);

    ext_itvl = exprnd(1/lambda, est_num_int, 1);
    int_itvl = exprnd(1/eta, est_num_int, 1);
    % fprintf('  external link arrival time: mean=%.2f, var=%.2f\n', mean(ext_itvl), var(ext_itvl));
    % fprintf('  internal link arrival time: mean=%.2f, var=%.2f\n', mean(int_itvl), var(int_itvl));

    arr_ext = cumsum(ext_itvl);
    arr_int = cumsum(int_itvl);

    n_init1s = 3;
    arrival = ones(1, n_init1s);
    ptr1 = 1;
    ptr2 = 1;
    while(ptr1 <= (maxN-n_init1s))
        % fprintf('ptr1=%d, ptr2=%d, num=%d\n', ptr1, ptr2, est_num_int)
        if arr_ext(ptr1) < arr_int(ptr2)
            arrival = [arrival 1];
            ptr1 = ptr1 + 1;
        else
            arrival = [arrival 2];
            ptr2 = ptr2 + 1;
        end
    end
    narr = length(arrival);

    %% ---------------------
    %% Simulate the generation process
    %% ---------------------
    k = zeros(1, maxN);
    k_hat = zeros(1, maxN);
    topo = zeros(maxN, maxN);


    % for i = 1:maxN
    k(1) = 1;
    k(2) = 1;
    i = 2;
    for j = 3:narr
        % fprintf('%d / %d\n', i, N);
        show_progress(i, narr, 1);


        %% =====================
        %% External Link
        %% =====================
        if arrival(j) == 1
            i = i + 1;

            %% ---------------------
            %% calculate node degree
            %% ---------------------
            k(i) = 1;
            %% find phase1 nodes
            idx = find(k(1:i) <= L);
            k_hat(idx) = L;
            %% find phase2 nodes
            idx = find(k(1:i) > L & k(1:i) <= U);
            k_hat(idx) = k(idx);
            %% find phase3 nodes
            idx = find(k(1:i) > U);
            k_hat(idx) = U;


            %% ---------------------
            %% attach to a node
            %% ---------------------
            prob = k_hat(1:(i-1)) / sum(k_hat(1:(i-1)));
            cdf = cumsum(prob);

            realized = rand;
            idx = find(cdf > realized);
            idx = idx(1);
            k(idx) = k(idx) + 1;

            topo(i, idx) = topo(i, idx) + 1;
            topo(idx, i) = topo(idx, i) + 1;


            %% ---------------------
            %% Save the current results
            %% ---------------------
            for N = Ns
                if N == i
                    x = [min(k(1:i)):max(k(1:i))]';
                    y = histc(k(1:i), x)';

                    %% --------------------
                    %% save values
                    %% --------------------
                    xx = [0; x];
                    yy = [N; y];
                    dlmwrite(sprintf('%sL%dU%dN%d.internal_link_v4.l%.2f.e%.2f.%s.txt', output_dir, L, U, N, lambda, eta, sel_type), [xx, yy], 'delimiter', '\t');
                    dlmwrite(sprintf('%sL%dU%dN%d.internal_link_v4.l%.2f.e%.2f.%s.topo.txt', output_dir, L, U, N, lambda, eta, sel_type), [topo], 'delimiter', '\t');
                    break;
                end
            end

            if DEBUG3
                fprintf('ext: i=%d, j=%d\n', i, j);
                k(1:i)
            end


        %% =====================
        %% Internal Link
        %% =====================
        else
            %% ---------------------
            %% select an existing node to attach to others
            %% ---------------------
            %% select an existing node
            if strcmp(sel_type, 'mc')
                realized = rand;
                idx = find(cdf > realized);
                idx = idx(1);
            elseif strcmp(sel_type, 'rand')
                idx = round(rand * (i-2)) + 1;
            elseif strcmp(sel_type, 'cal')
                if DEBUG3
                    fprintf('int: i=%d, j=%d\n', i, j);
                    k(1:i)
                end

                kk = cal_k(k(1:i));
                p  = cal_p(k(1:i), kk);
                pp = cal_pp(p);
                % sum(pp)/2 == 1
                [idx1, idx2] = select_link(pp);
            else
                error('wrong selection type');
            end

            %% attach to the selected nodes
            if strcmp(sel_type, 'cal')
                k(idx1) = k(idx1) + 1;
                k(idx2) = k(idx2) + 1;

                topo(idx1, idx2) = topo(idx1, idx2) + 1;
                topo(idx2, idx1) = topo(idx2, idx1) + 1;
            else
                k(idx) = k(idx) + 1;

                %% attach to another node
                idx2 = idx;
                while(idx2 == idx)
                    realized = rand;
                    idx2 = find(cdf > realized);
                    idx2 = idx2(1);
                end
                k(idx2) = k(idx2) + 1;
            end

            if DEBUG3
                fprintf('int--after: i=%d, j=%d\n', i, j);
                k(1:i)
            end

        end

    end

end

function [k] = cal_k(K)
    DEBUG3 = 0;

    epsilon = 0.00001;
    c = sum(K) / 2;
    n = length(K);

    % prev_a = 0;
    % prev_dif = 0;
    prev_a_pos = 0;
    prev_dif_pos = -1;
    prev_a_neg = 0;
    prev_dif_neg = 1;

    a = 0;
    dif = cal_dif(a, K, c, n);

    cnt = 0;
    while abs(dif) > epsilon
        cnt = cnt + 1;

        if DEBUG3,
            fprintf('iter %d:\n', cnt);
            fprintf('  a = %f, dif = %f = %f-%f\n', a, dif, sum(sqrt(1 - a*K/2/c)), n-2);
        end

        %% update prev info
        if dif > 0 & (a > prev_a_pos | prev_dif_pos < 0)
            prev_dif_pos = dif;
            prev_a_pos   = a;

            if DEBUG3, fprintf('  new pos a = %f\n', prev_a_pos); end

        elseif dif < 0 & (a < prev_a_neg | prev_dif_neg > 0)
            prev_dif_neg = dif;
            prev_a_neg   = a;

            if DEBUG3, fprintf('  new neg a = %f\n', prev_a_pos); end
        end


        %% move "a" a bit
        if dif > 0
            if prev_dif_neg > 0
                %% no negative dif before
                a = 2*c/max(K);
                dif = cal_dif(a, K, c, n);

                if dif > 0, error('should be negative'); end
            else
                a = (a + prev_a_neg) / 2;
                dif = cal_dif(a, K, c, n);
            end
        else
            if prev_dif_pos < 0, error('pos diff should already here'); end

            a = (a + prev_a_pos) / 2;
            dif = cal_dif(a, K, c, n);
        end

        % input('')
    end

    k = 8/a - 2;

    if DEBUG3, fprintf('  final: a = %f, dif = %f, k = %f\n', a, dif, k); end
end


function [dif] = cal_dif(a, K, c, n)
    dif = sum(sqrt(1 - a*K/2/c)) - (n-2);
end

function [p] = cal_p(K, k)
    c = sum(K) / 2;
    p = (sqrt(2+k) - sqrt(2+k-4*K/c)) / 2;
end

function [pp] = cal_pp(p)
    n = length(p);
    pp = p' * p;
    self_idx = find(eye(n) > 0);
    pp(self_idx) = 0;
    pp = reshape(pp, [], 1);
end

function [n1, n2] = select_link(pp)
    DEBUG3 = 0;

    n = sqrt(length(pp));

    cdf = cumsum(pp);

    realized = rand * 2;
    idx = find(cdf > realized);
    idx = idx(1);
    if(pp(idx) == 0)
        idx = idx + 1;
    end

    n1 = mod(idx-1, n) + 1;
    n2 = floor((idx-1)/n) + 1;
    if DEBUG3, fprintf('  idx=%d, n=%d, n1=%d, n2=%d\n', idx, n, n1, n2); end

    if n1 == n2, error('should not select the same node'); end
end
