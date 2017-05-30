%Histogram Generating script
%Requires that you have ElementData Loaded in
clc; close all; 

%% Collect Data
PrefD = [ElementData(:).PrefDA_Mean];
NOI = [ElementData(:).NOI_Mean];
Skew = [ElementData(:).Skew_Mean];
Kurtosis = [ElementData(:).Kurtosis_Mean];

xStep = ElementData(1).nodes(8).x-ElementData(1).nodes(1).x;
yStep = ElementData(1).nodes(8).y-ElementData(1).nodes(1).y;
zStep = ElementData(1).nodes(8).z-ElementData(1).nodes(1).z;
VoxelVolume = xStep*yStep*zStep;
TotalVolume = VoxelVolume*length(ElementData);

nBins = 15;

%% PrefD Histograms


figure;
[f,x] = hist(PrefD,nBins);
subplot(1,3,1);
this = bar(x,f); 
xlim([-90,90]);
xlabel('Preferred Direction (Degrees)'); 
ylabel('Bin Count');
title('Bin Count', 'FontSize', 18);
subplot(1,3,2);
bar(x,f/sum(f)); 
xlim([-90,90]);

xlabel('Preferred Direction (Degrees)'); 
ylabel('Normalized');
title('Normalized', 'FontSize', 18);
subplot(1,3,3);
bar(x,(f*VoxelVolume));
xlim([-90,90]);
xlabel('Preferred Direction (Degrees)'); 
ylabel('Volume (mm^3)');
title('Volumetric', 'FontSize', 18);


%% NOI Histograms
figure;
[f,x] = hist(NOI,nBins);
subplot(1,3,1);
this = bar(x,f); 
xlim([0,70]);
xlabel('NOI'); 
ylabel('Bin Count');
title('Bin Count', 'FontSize', 18);
subplot(1,3,2);
bar(x,f/sum(f)); 
xlim([0,70]);
xlabel('NOI'); 
ylabel('Normalized');
title('Normalized', 'FontSize', 18);
subplot(1,3,3);
bar(x,(f*VoxelVolume));
xlim([0,70]);
xlabel('NOI'); 
ylabel('Volume (mm^3)');
title('Volumetric', 'FontSize', 18);

%% Skew Histograms
figure;
[f,x] = hist(Skew,nBins);
subplot(1,3,1);
bar(x,f); 
xlim([-0.0075,0.00075]);
xlabel('Skew'); 
ylabel('Bin Count');
title('Bin Count', 'FontSize', 18);
subplot(1,3,2);
bar(x,f/sum(f)); 
xlim([-0.0075,0.00075]);
xlabel('Skew'); 
ylabel('Normalized');
title('Normalized', 'FontSize', 18);
subplot(1,3,3);
bar(x,(f*VoxelVolume));
xlim([-0.0075,0.00075]);
xlabel('Skew'); 
ylabel('Volume (mm^3)');
title('Volumetric', 'FontSize', 18);

%% Kurtosis
figure;
[f,x] = hist(Kurtosis,nBins);
subplot(1,3,1);
this = bar(x,f); 
xlim([-0.00075,0.00075]);
xlabel('Kurtosis'); 
ylabel('Bin Count');
title('Bin Count', 'FontSize', 18);
subplot(1,3,2);
bar(x,f/sum(f)); 
xlim([-0.00075,0.00075]);
xlabel('Kurtosis'); 
ylabel('Normalized');
title('Normalized', 'FontSize', 18);
subplot(1,3,3);
bar(x,(f*VoxelVolume));
xlim([-0.00075,0.00075]);
xlabel('Kurtosis'); 
ylabel('Volume (mm^3)');
title('Volumetric', 'FontSize', 18);
