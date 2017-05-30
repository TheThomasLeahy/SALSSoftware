function [ coefficients ] = getFourierCoeffients(tensor, rank)
%UNTITLED2 Summary of this function goes here
% rank is tensor order, 2, 4, ...etc
% there are 2*rank number ofcoefficients
    coefficients = [];    
    for i = 1:rank
       a = tensor(1); % first value of the tensor D(1,1,1,1....,1)
       b = tensor(2); % index with one 2 term
       coefficients = [coefficients a b];
    end
end
