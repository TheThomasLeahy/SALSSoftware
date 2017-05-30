function [ skewness kurtosis ] = compute_skewness( mean, data, theta )

    sum = 0;
    for i = 2:length(theta)
        v = (1/2) * (theta(i)*gamma(i)+theta(i-1)*gamma(i-1))*(theta(i)-theta(i-1)) - mean;
        sum = sum + v;
    end
    
    m3 = (sum^3)/180;
    m4 = (sum^4)/180;
    s1 = (1/(1-180)*sum^2)^(3/2);
    s2 = (1/(1-180)*sum^2)^2;
    
    skewness = m3/s1^3;
    kurtosis = m4/s2;
end

