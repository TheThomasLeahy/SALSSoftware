function [ data_out ] = evalFourierRad( an, bn , C, theta )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    %% Reconstruct data from series
    data_out = [];
    for idx=1:length(theta)
        ang = theta(idx);
        v = 0;
        for j = 1:length(an)
            v = v + an(j) * cos(ang*2*j);
            v = v + bn(j) * sin(ang*2*j);
        end
        v = (v+1)*(C)/(2*pi);
        data_out(idx) = v;
    end
end
