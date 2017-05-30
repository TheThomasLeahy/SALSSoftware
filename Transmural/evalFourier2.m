function [ data_out ] = evalFourier2( coeffs, theta )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%% Reconstruct data from series
C = coeffs(end);
coeffs = coeffs(1:end-1);
data_out = [];
for idx=1:length(theta)
    ang = theta(idx);
    v = 0;
    for a_i = 1:length(coeffs)/2
        v = v + coeffs(a_i*2 - 1) * cosd(ang*2*a_i);
    end
    for b_i = 1:length(coeffs)/2
        v = v + coeffs(b_i*2) * sind(ang*2*b_i);
    end
    v = (v+1)*(C)/(2*pi);
    data_out(idx) = v;
end

end
