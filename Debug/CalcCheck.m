%Calc Check

%This program was written on 4/27/2017
%This program confirms that the computation of the preferred direction, NOI
%Skew and Kurtosis is correct

close all;

%% Data Construction

%Circular Distribution - Expected NOI of 0
CircData = ones(1,360);

CircDataPoint = data_point;
CircDataPoint.intensity_data = CircData;
CircDataPoint = CircDataPoint.Normalize;
CircDataPoint = CircDataPoint.GenerateFourier(14);
CircDataPoint = CircDataPoint.ComputeStats;


%Gaussian PDF
x = 1:180;
mu = 90;
sigma = 5;
PDFData = normpdf(x,mu,sigma);
PDFData = [PDFData PDFData];

PDFDataPoint = data_point;
PDFDataPoint.intensity_data = PDFData;
PDFDataPoint = PDFDataPoint.Normalize;
PDFDataPoint = PDFDataPoint.GenerateFourier(14);
PDFDataPoint = PDFDataPoint.ComputeStats;




%Delta Function - Expected NOI of 1
DeltaData = [1 zeros([1,179])];
DeltaData = [DeltaData DeltaData];

DeltaDataPoint = data_point;
DeltaDataPoint.intensity_data = DeltaData;
DeltaDataPoint = DeltaDataPoint.Normalize;
DeltaDataPoint = DeltaDataPoint.GenerateFourier(14);
DeltaDataPoint = DeltaDataPoint.ComputeStats;

%Bovine Tendon Data - Make sure to have it loaded in.
%Current calculation says NOI of 54.983
BTData = [PointData(668).intensity_data];

BTDataPoint = data_point;
BTDataPoint.intensity_data = BTData;
BTDataPoint = BTDataPoint.Normalize;
BTDataPoint = BTDataPoint.GenerateFourier(14);
BTDataPoint = BTDataPoint.ComputeStats;


%Plot

figure;
polarplot(PDFDataPoint.odd);
hold on;
polarplot(CircDataPoint.odd);
%polarplot(DeltaDataPoint.odd);
polarplot(BTDataPoint.odd);
hold off;
title('ODF Data');
string1 = strcat('PDFDataPoint oi = ', num2str(PDFDataPoint.oi_odd));
string2 = strcat('CircDataPoint oi = ', num2str(CircDataPoint.oi_odd));
string3 = strcat('DeltaDataPoint oi = ', num2str(DeltaDataPoint.oi_odd));
string4 = strcat('BTDataPoint oi = ', num2str(BTDataPoint.oi_odd));
%legend(string1, string2, string3, string4);
legend(string1, string2, string4);


figure;
polarplot(PDFDataPoint.odf);
hold on;
polarplot(CircDataPoint.odf);
polarplot(DeltaDataPoint.odf);
polarplot(BTDataPoint.odf);
hold off;
title('Fourier Series representation of the ODF');
string1 = strcat('PDFDataPoint oi = ', num2str(PDFDataPoint.oi_odf));
string2 = strcat('CircDataPoint oi = ', num2str(CircDataPoint.oi_odf));
string3 = strcat('DeltaDataPoint oi = ', num2str(DeltaDataPoint.oi_odf));
string4 = strcat('BTDataPoint oi = ', num2str(BTDataPoint.oi_odf));
legend(string1, string2, string3, string4);




figure;
subplot(1,2,1);
polarplot(DeltaDataPoint.odd);
string1 = strcat({'Delta Function ODF -> NOI = '}, num2str(DeltaDataPoint.oi_odd));
title(string1, 'FontSize', 16);
subplot(1,2,2);
polarplot(DeltaDataPoint.odf);
string2 = strcat({'Delta Function Fourier Series -> NOI = '}, num2str(DeltaDataPoint.oi_odf));
title(string2,'FontSize',16);

figure;
subplot(1,2,1);
polarplot(CircDataPoint.odd);
string1 = strcat({'Uniform Distribution ODF -> NOI = '}, num2str(CircDataPoint.oi_odd));
title(string1, 'FontSize', 16);
rlim([0,0.2]);
subplot(1,2,2);
polarplot(CircDataPoint.odf);
string2 = strcat({'Uniform Distribution Fourier Series -> NOI = '}, num2str(CircDataPoint.oi_odf));
title(string2,'FontSize',16);
rlim([0,0.2]);