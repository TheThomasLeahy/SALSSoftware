function [ b ] = compute_bn(n, gamma, theta)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    sum = 0;
    for i=2:(length(theta))
       sum = sum + (1/2) * (gamma(i) * sin(n * theta(i)) + gamma(i-1)*sin(n*theta(i-1)))*(theta(i) - theta(i-1));
    end
    b = sum * 2;
end

