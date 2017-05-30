function [ a ] = compute_an(n, gamma, theta)

    sum = 0;
    for i=2:(length(theta))
       sum = sum + (1/2) * (gamma(i) * cos(n * theta(i)) + gamma(i-1)*cos(n*theta(i-1)))*(theta(i) - theta(i-1));
    end
    a = sum * 2;
end

