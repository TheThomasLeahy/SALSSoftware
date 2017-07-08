function [ Gamma ] = computeBeta(mean, sd, theta )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
mu = (mean+(pi/2))/pi;
sigma = sd/pi;
gamma = ((mu^2)-(mu^3)-((sigma^2)*mu))/(sigma^2);
delta = gamma*(1-mu)/mu;
y = (theta+(pi/2))/pi;

dist = makedist('Beta','a', gamma , 'b', delta);

Gamma = pdf(dist, y)/pi;

end

