function [ GammaHalf ] = computeGammaHalf( mean1, sd1, mean2, sd2, d, theta )

Gamma1 = computeBeta(mean1,sd1,theta);
Gamma2 = computeBeta(mean2, sd2, theta);

GammaHalf = d*(Gamma1+Gamma2)+(1-d)/pi;

end

