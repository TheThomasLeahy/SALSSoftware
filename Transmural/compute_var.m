function [ var ] = compute_var( gamma, theta, mean )
    
    var = 0;
    var1 = 0;
    for i=2:length(theta)
       var = var + (1/2) * (gamma(i)*(theta(i) - mean)^2 + gamma(i-1)*(theta(i-1) - mean)^2)*(theta(i)-theta(i-1));
    end
    
    %{
    for i =1:length(theta)
        var1 = var1 + gamma(i)*(theta(i) - mean)^2;
    end
    %}
    %var =  sum(gamma.*(theta-mean).^2);
end
