function [ oi ] = getOrientationIndex( data, theta )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

mean = 0;
for i = 2:length(theta)
    value = (1/2)*(theta(i)*data(i)+theta(i-1)*data(i-1))*(theta(i)-theta(i-1));
    mean = mean + value;
end

stndev = sqrt(sum(data.*((theta-mean).^2)));

fun = @(x) ((x-mean).^2)/180;
stdMAX = sqrt(integral(fun, 1, 180));

oi = 100*(1-(stndev/stdMAX));

end

