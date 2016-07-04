%% sim_ic_model_internal_link_v3(2, 8, 1)
%% sim_ic_model_internal_link_v3(3, 10, 1)
%% sim_ic_model_internal_link_v3(1, 1, 1)
%% sim_ic_model_internal_link_v3(1, 100000, 1)
%% sim_ic_model_internal_link_v3(3, 100000, 1)

function sim_ic_model_internal_link_v3(L, U, itvl, seed)
    DEBUG3 = 0;

    if nargin < 1, L = 1; end
    if nargin < 2, U = 1000000; end
    if nargin < 3, itvl = 1; end
    if nargin < 4, seed = 1; end

    % Ns = [1:10] * 10000;
    Ns = [1:4] * 2000;

    rng(seed);
    sel_type = 'cal';

    output_dir = './data/';
    fig_dir = './fig/';
    font_size = 18;
    total_sim = 1000;


    maxN = max(Ns);
    k = zeros(1, maxN);
    k_hat = zeros(1, maxN);


    for i = 1:maxN
        % fprintf('%d / %d\n', i, N);
        show_progress(i, maxN, 1);

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
        prob = k_hat(1:i) / sum(k_hat(1:i));
        cdf = cumsum(prob);

        realized = rand;
        idx = find(cdf > realized);
        idx = idx(1);
        k(idx) = k(idx) + 1;


        %% ---------------------
        %% select an existing node to attach to others
        %% ---------------------
        if i > 50 & mod(i,itvl) == 0
            %% select an existing node
            if strcmp(sel_type, 'mc')
                realized = rand;
                idx = find(cdf > realized);
                idx = idx(1);
            elseif strcmp(sel_type, 'rand')
                idx = round(rand * (i-2)) + 1;
            elseif strcmp(sel_type, 'cal')
                kk = cal_k(k(1:i));
                p  = cal_p(k(1:i), kk);
                pp = cal_pp(p);
                % sum(pp)/2 == 1
                [idx1, idx2] = select_link(pp);
            else
                error('wrong selection type');
            end

            if strcmp(sel_type, 'cal')
                k(idx1) = k(idx1) + 1;
                k(idx2) = k(idx2) + 1;
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
        end


        for N = Ns
            if N == i
                x = [min(k(1:i)):max(k(1:i))]';
                y = histc(k(1:i), x)';

                %% --------------------
                %% save values
                %% --------------------
                xx = [0; x];
                yy = [N; y];
                dlmwrite(sprintf('%sL%dU%dN%d.internal_link_v3.itvl%d.%s.txt', output_dir, L, U, N, itvl, sel_type), [xx, yy], 'delimiter', '\t');
                break;
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
