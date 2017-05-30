function [ skew, kurtosis ] = computeSkewKurtosis(theta, prefD, sd)
%This function calculates the skew and kurtosis for a set of data

skew = ((sum(theta-prefD).^3)./length(theta))./(sd^3);
kurtosis = ((sum(theta-prefD).^4)./length(theta))./(sd^4);

end

