%%GradientVisual3
%Confirming that the gradients are calculated correctly
clear all; close all; clc;

%%Set up distribution

mean1 = 5*pi/180;
sd1 = 10*pi/180;
mean2 = mean1;
sd2 = 10*pi/180;
theta = linspace(-pi/2,pi/2,181);
d =1;
GammaHalf = computeGammaHalf(mean1, sd1, mean2, sd2, d, theta);
Gamma = [GammaHalf(92:180) GammaHalf GammaHalf(2:91)];
Gamma1 = [Gamma(181:end) Gamma(1:180)];

mean1 = 5*pi/180;
sd1 = 15*pi/180;
mean2 = mean1;
sd2 = 15*pi/180;
theta = linspace(-pi/2,pi/2,181);
d =1;
GammaHalf = computeGammaHalf(mean1, sd1, mean2, sd2, d, theta);
Gamma = [GammaHalf(92:180) GammaHalf GammaHalf(2:91)];
Gamma = [Gamma(181:end) Gamma(1:180)];
Gamma235 = circshift(Gamma, 30);

mean1 = 5*pi/180;
sd1 = 20*pi/180;
mean2 = mean1;
sd2 = 20*pi/180;
theta = linspace(-pi/2,pi/2,181);
d =1;
GammaHalf = computeGammaHalf(mean1, sd1, mean2, sd2, d, theta);
Gamma = [GammaHalf(92:180) GammaHalf GammaHalf(2:91)];
Gamma = [Gamma(181:end) Gamma(1:180)];
Gamma467 = circshift(Gamma, 60);

mean1 = 5*pi/180;
sd1 = 25*pi/180;
mean2 = mean1;
sd2 = 25*pi/180;
theta = linspace(-pi/2,pi/2,181);
d =1;
GammaHalf = computeGammaHalf(mean1, sd1, mean2, sd2, d, theta);
Gamma = [GammaHalf(92:180) GammaHalf GammaHalf(2:91)];
Gamma = [Gamma(181:end) Gamma(1:180)];
Gamma8 = circshift(Gamma,90);

figure; plot(Gamma1); hold on; plot(Gamma235); plot(Gamma467); plot(Gamma8); hold off;

%% Set up data points

datapoint = data_point;
datapoint(1).intensity_data = Gamma1;
datapoint(2).intensity_data = Gamma235;
datapoint(3).intensity_data = Gamma235;
datapoint(4).intensity_data = Gamma467;
datapoint(5).intensity_data = Gamma235;
datapoint(6).intensity_data = Gamma467;
datapoint(7).intensity_data = Gamma467;
datapoint(8).intensity_data = Gamma8;


%% Do Analysis

datapoint(1).x = 0; datapoint(1).y = 0; datapoint(1).z = 0;
datapoint(2).x = 1; datapoint(2).y = 0; datapoint(2).z = 0;
datapoint(3).x = 0; datapoint(3).y = 1; datapoint(3).z = 0;
datapoint(4).x = 1; datapoint(4).y = 1; datapoint(4).z = 0;
datapoint(5).x = 0; datapoint(5).y = 0; datapoint(5).z = 1;
datapoint(6).x = 1; datapoint(6).y = 0; datapoint(6).z = 1;
datapoint(7).x = 0; datapoint(7).y = 1; datapoint(7).z = 1;
datapoint(8).x = 1; datapoint(8).y = 1; datapoint(8).z = 1;

for i = 1:length(datapoint)
    datapoint(i) = datapoint(i).Normalize;
    datapoint(i) = datapoint(i).GenerateFourier(14);
    datapoint(i) = datapoint(i).ComputeStats;
end

data{1} = datapoint;

[PointData, ElementData] = TFA3DAnalysis(data);

%% Print out this shiz

myVTKWrite(PointData, ElementData);



