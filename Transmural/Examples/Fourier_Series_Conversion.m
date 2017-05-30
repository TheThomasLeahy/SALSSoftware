%Fourier Fit Code

%% Load data set
clear all
close all
clc

addpath(genpath('..'));

%% Data set informaton
theta = 1:1:180;
theta360 = 1:1:360;
data_raw = [27 33 40 48 58 70 84 101 121 144 171 203 240 283 333 392 459 537 626 728 845 978 1129 1300 1494 1712 1957 2231 2538 2879 3258 3678 4142 4653 5213 5827 6496 7224 8014 8868 9788 10777 11836 12967 14170 15447 16796 18218 19710 21272 22900 24591 26341 28145 29998 31893 33822 35779 37755 39740 41726 43701 45655 47578 49458 51283 53044 54727 56324 57822 59211 60483 61628 62637 63505 64223 64788 65194 65439 65520 65439 65194 64788 64223 63505 62637 61628 60483 59211 57822 56324 54727 53044 51283 49458 47578 45655 43701 41726 39740 37755 35779 33822 31893 29998 28145 26341 24591 22900 21272 19710 18218 16796 15447 14170 12967 11836 10777 9788 8868 8014 7224 6496 5827 5213 4653 4142 3678 3258 2879 2538 2231 1957 1712 1494 1300 1129 978 845 728 626 537 459 392 334 283 240 203 171 144 121 101 84 70 58 48 40 33 27 22 18 15 12 10 8 7 6 5 4 3 4 5 6 7 8 10 12 15 18 22 27 33 40 48 58 70 84 101 121 144 171 203 240 283 334 392 459 537 626 728 845 978 1129 1300 1494 1712 1957 2231 2538 2879 3258 3678 4142 4653 5213 5827 6496 7224 8014 8868 9788 10777 11836 12967 14170 15447 16796 18218 19710 21272 22900 24591 26341 28145 29998 31893 33822 35779 37755 39740 41726 43701 45655 47578 49458 51283 53044 54727 56324 57822 59211 60483 61628 62637 63505 64223 64788 65194 65439 65520 65439 65194 64788 64223 63505 62637 61628 60483 59211 57822 56324 54727 53044 51283 49458 47578 45655 43701 41726 39740 37755 35779 33822 31893 29998 28145 26341 24591 22900 21272 19710 18218 16796 15447 14170 12967 11836 10777 9788 8868 8014 7224 6496 5827 5213 4653 4142 3678 3258 2879 2538 2231 1957 1712 1494 1300 1129 978 845 728 626 537 459 392 334 283 240 203 171 144 121 101 84 70 58 48 40 33 27 22 18 15 12 10 8 7 6 5 4 3 4 5 6 7 8 10 12 15 18 22];
data_avg = (data_raw(1:180) + data_raw(181:360))/2;
ndata = data_avg/sum(data_avg);
figure;
hold on

plot(theta,ndata);
data_raw2 = circshift(data_raw', 90)';
data_avg2 = (data_raw2(1:180) + data_raw2(181:360))/2;
ndata_shifted = data_avg2/sum(data_avg2);
plot(theta,ndata_shifted);

ndata_avg60 = data_raw/sum(data_raw);

% raw data average
data_raw3 = (data_raw + data_raw2)/2;
data_avg3 = (data_raw3(1:180) + data_raw3(181:360))/2;
ndata_avg = data_avg3/sum(data_avg3);
plot(theta,ndata_avg);

hold off

%% Fit data to model
fs_order = 10;

% fit data 1
asd = fitToFourierModel(fs_order,theta',ndata');

[myfit, G] = fitToFourierModel(fs_order,theta',ndata');
% fit data 2, shifted data
[myfit_shifted, G] = fitToFourierModel(fs_order,theta',ndata_shifted');
% fit data 3, 360 data
[myfit360, G] = fitToFourierModel(fs_order, theta360',ndata_avg60');


figure
hold on
plot(myfit,theta,ndata)
plot(myfit_shifted,theta,ndata_shifted)
plot(myfit360,theta360,ndata_avg60)
hold off

%% Compare 360 and 180 coefficients
fourier_180 = coeffvalues(myfit);
an180 = fourier_180(1:2:length(fourier_180));
bn180 = fourier_180(2:2:length(fourier_180));
fourier_360 = coeffvalues(myfit360);
an360 = fourier_360(1:2:length(fourier_360));
bn360 = fourier_360(2:2:length(fourier_360));

figure
hold on
plot(myfit,theta,ndata)
plot(myfit360,theta360,ndata_avg60)
hold off


%% Average fourier coefficients between reg and shifted data
fouier_coeffs_avg = (coeffvalues(myfit) + coeffvalues(myfit_shifted))/2;
C_avg = (myfit.C + myfit_shifted.C)/2;
data1_reconstruct = evalFourier(coeffvalues(myfit), myfit.C, 1:180);
data_fourier_avg_reconstruct = evalFourier(fouier_coeffs_avg, C_avg, 1:180);

figure
hold on 
plot(myfit,theta,ndata)
plot(myfit_shifted,theta,ndata_shifted)
plot(theta,data_fourier_avg_reconstruct, 'DisplayName', 'data_fourier_avg_reconstruct');
legend('show');
hold off

%%
figure
hold on
bar([1:length(bn180) bn180; 1:length(bn180), bn360]);
hold off

%% 

fourier_coeff = coeffvalues(myfit)';
an = fourier_coeff(1:2:length(fourier_coeff));
bn = fourier_coeff(2:2:length(fourier_coeff));

a2 = an(1);
b2 = bn(1);
a4 = an(2);
a6 = an(3);
a4 = an(4);

D_ij = [a2 b2; b2 -a2];

[v, d] = eig(D_ij);

primary = atan(v(2,1)/v(1,1)) * (180/pi) + 90
cross = atan(v(2,2)/v(1,2)) * (180/pi) + 90

%% R^2 Value 
fprintf('The R-Squared value is %f \n', G.rsquare);

%% Generate Tensors
ranks = [2 4];
tensors = cell(1,length(ranks));
for r = 1:length(ranks);
    rank = ranks(r);
    aVal = an(rank/2);
    bVal = bn(rank/2);
    tensor = [];
    
    indices = permn([1 2], rank)
    for i = 1:length(indices)
       index = indices(i,:);
       k = sum(index ==2);
       if mod(k,2) == 0
            val = ((-1)^(k/2))*aVal;
        else
            val = ((-1)^((k-1)/2))*bVal;
       end
       s = mat2str(index);
       s = strrep(s, ' ',',');
       s = strrep(s, '[','');
       s = strrep(s, ']','');
       s = strcat('tensor(',s);
       s = strcat(s, ') = val;');
       eval(s);
    end
    tensors{r} = tensor;
end
