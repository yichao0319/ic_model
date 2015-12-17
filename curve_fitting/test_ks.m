function test_ks    
    x1 = normrnd(10, 10, 10000,1);

    px1 = [min(x1):max(x1)]';
    py1 = histc(x1, px1);
    py1 = py1 / sum(py1);

    % x2 = randpdf(py1, px1, size(x1));
    % x2 = normrnd(10, 2, 100000,1);
    % pdfs = PDFsampler(x1);
    % for i = 1:length(x1)
    %     x2(i) = pdfs.nextRandom;
    % end
    x2 = my_randpdf2(py1, px1, length(x1));

    px2 = [min(x2):max(x2)]';
    py2 = histc(x2, px2);
    py2 = py2 / sum(py2);

    [h, p] = kstest2(x1(randi(length(x1), 1, min(length(x1),1000))), ...
                     x2(randi(length(x1), 1, min(length(x1),1000))))

    
    fh = figure(1); clf;
    plot(px1, py1, '-b.');
    hold on;
    plot(px2, py2, '-r.');
    hold on;

    fh = figure(2); clf;
    plot(sort(x1), '-b.');
    hold on;
    plot(sort(x2), '-r.');
    
end


%% my_pdf_rand
% function [ret] = my_randpdf(py, px, m)
%     scale = 10*m;

%     min_px = min(px);
%     max_px = max(px);
%     itvl = (max_px-min_px) / length(px) / 100;
%     px2 = min_px:itvl:max_px;
%     py2 = interp1(px, py, px2);

%     fh = figure(3); clf;
%     plot(px2, py2, '-r.');
%     hold on;
%     plot(px, py, '-b.');
    

%     pool = [];
%     for i = 1:length(px2)
%         num = round(scale * py2(i));
%         pool = [pool ones(1,num)*px2(i)];
%     end

%     idx = randperm(length(pool), m);
%     ret = pool(idx);
% end

function [ret] = my_randpdf2(py, px, m)
    scale = 10*m;

    pycdf = cumsum(py);

    min_px = min(px);
    max_px = max(px);
    itvl = (max_px-min_px) / length(px) / 100;
    px2 = min_px:itvl:max_px;
    pycdf2 = interp1(px, pycdf, px2);

    fh = figure(3); clf;
    plot(px2, pycdf2, '-r.');
    hold on;
    plot(px, pycdf, '-b.');
    

    % ret_idx = rand(1,m);
    ret_idx = unifrnd(0,1, 1,m);
    idx = [];
    for i = 1:length(ret_idx)
        this_idx = find(pycdf2 > ret_idx(i));
        idx = [idx this_idx(1)];
    end
    ret = px2(idx);
end
