function [ r_squared ] = compute_r_squared( raw_data, modelled_data)

    raw_data_mean = mean(raw_data);

    ss_res = 0;
    ss_tol = 0;
    for i = 1:length(raw_data)
        ss_tol = ss_tol + (raw_data(i) - raw_data_mean)^2;
        ss_res = ss_res + (raw_data(i) - modelled_data(i))^2;
    end

    r_squared = 1 - ss_res/ss_tol;
end

