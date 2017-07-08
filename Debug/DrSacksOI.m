%clc; clear all; close all;

%% RUN THIS JORDAN IF YOU WANT TO SEE WHAT I DONE DID



mean1 = 5*pi/180;
sd1 = 30*pi/180;
mean2 = mean1;
sd2 = 30*pi/180;
theta = linspace(-pi/2,pi/2,181);
d =1;

%% Beta dist

GammaHalf = computeGammaHalf(mean1, sd1, mean2, sd2, d, theta);

theta = linspace(-180, 180, 361);
Gamma = [GammaHalf(91:180) GammaHalf GammaHalf(2:91)];

figure; plot(theta, Gamma); title('This looks like his!!!');

datapoint = data_point;

Gamma = [GammaHalf(92:180) GammaHalf GammaHalf(2:91)];
Gamma = [Gamma(181:end) Gamma(1:180)];

datapoint.intensity_data = Gamma;
datapoint = datapoint.Normalize;
datapoint = datapoint.GenerateFourier(14);
datapoint = datapoint.ComputeStats;

[thetaI, thetaII] = datapoint.ComputeSymAngles();
            
interval = pi/180;
halftheta = thetaII:interval:thetaII + pi - pi/180;
odf_FS_fit = evalFourierRad(datapoint.an, datapoint.bn, 2,  halftheta);

figure; plot(halftheta,odf_FS_fit); title('This also looks like his!');

otherint = (1/3)*(((pi/2)^3) - ((-pi/2)^3));
sdMax = sqrt((1/pi)*otherint);

disp('Results');
disp(['Mean is ' num2str(rad2deg(datapoint.mean_odf))]);
disp(['SD is ' num2str(rad2deg(datapoint.sd_odf))]);
disp(['Mean is ' num2str(datapoint.oi_odf)]);


