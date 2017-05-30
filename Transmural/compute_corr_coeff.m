function [ r ] = compute_corr_coeff( x, y )

    x_avg = mean(x);
    y_avg = mean(y);

    top = 0;
    bot = 0;
    for i = 1:length(x)
       top = top + (x(i) - x_avg) * (y(i) - y_avg);
       bot = bot + sqrt((x(i) - x_avg)^2) * sqrt((y(i) - y_avg)^2);
    end

    r = top/bot;
    
end