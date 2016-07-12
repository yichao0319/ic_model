function y = close_form_pl_cutoff_log(param, x)
    % y2 = close_form_pl_cutoff(param, x);
    % y  = y2;
    % idx1 = find(y2 == 0);
    % idx2 = find(y2 > 0);

    % y(idx1) = 0;
    % y(idx2) = log10(y2(idx2));
    y = log10(close_form_pl_cutoff(param, x));
end
