% Generate 300,000 points
% Focus on 1 particular node * among the 300,000 points

N = 30000;
total_sim = 1000;

star = round(N*rand); %a random index of 300,000

A = randperm(N);

k = zeros(1, N);


for sim = 1: total_sim

    for i = 1:N

        fprintf('%d / %d\n', i, N);

        k(A(i)) = 1;
        total_deg = sum(k(A(1:i)));
        
        prob = zeros(1, i);
        cdf = zeros(1, i);

        for j = 1:i
        
            prob(j) = k(A(j))/total_deg;
        
            if(j == 1)
                cdf(j) = prob(j);
            else
                cdf(j) = cdf(j-1) + prob(j);
            end

        end

        realized = rand;
        join = zeros(1, i);
    
        % prob of attaching the node is k/sum(k);

        for j = 1:i
            if (realized < cdf(j))
                join(j) = 1;
                break;
            end
        end
       
        for j2 = 1:i
            k(A(j2)) = k(A(j2)) + join(j2);
        end

    end

    K(sim) = k(star);

    %histogram(k);
    ret = histc(k, min(k):max(k));
    size(ret)
    k
    plot(ret, '-r.')
    set(gca, 'XScale', 'log')
    set(gca, 'YScale', 'log')

    break;

end
%histogram(K)







