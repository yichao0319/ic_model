function [err] = cal_log_err(y_fit, y)
    % err = mean(sqrt((y - y_fit).^2));
    err = mean(sqrt((log(y) - log(y_fit)).^2));
end