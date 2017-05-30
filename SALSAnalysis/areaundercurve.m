function [ area ] = areaundercurve( distribution )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

a=trapz(distribution);
area=a;
end

