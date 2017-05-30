function [ mean ] = compute_mean( gamma, theta )
    mean = 0;
    gamma = gamma./(sum(gamma));
    for i=2:length(theta)
       %mean = mean + (1/2) * (theta(i)*gamma(i)+theta(i-1)*gamma(i-1))*(theta(i)-theta(i-1));
       mean = mean + theta(i)*gamma(i);
    end 
    
end

