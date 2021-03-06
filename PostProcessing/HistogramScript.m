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

%% Full

figure;

[f,x] = hist(PrefD,nBins);
bar(x,f/sum(f));
xlim([-90,90]);
xlabel('Preferred Direction (Degrees)');
ylabel('Frequency');
title('Preferred Direction', 'FontSize', 18);


figure;
[f,x] = hist(NOI,nBins);
bar(x,f/sum(f));
xlim([0,20]);
xlabel('Normalized Orientation Index');
ylabel('Frequency');
title('Normalized Orientation Index', 'FontSize', 18);

PrefD_Section = cell(1,length(finalData));
NOI_Section = cell(1,length(finalData));


for i = 1:length(PointData)
    ind = round(PointData(i).z/zStep)+1;
    
    if isempty(PrefD_Section)
        PrefD_Section{ind} = (PointData(i).PrefDAngle*180/pi);
    else
        PrefD_Section{ind} = [PrefD_Section{ind} (PointData(i).PrefDAngle*180/pi)];
    end
    
    if isempty(NOI_Section{ind})
        NOI_Section{ind} = (PointData(i).oi_odf);
    else
        NOI_Section{ind} = [NOI_Section{ind} (PointData(i).oi_odf)];
    end
end

for i = 1:length(PrefD_Section)
   
    meanPD(i) = mean(PrefD_Section{i});
    stdPD(i) = std(PrefD_Section{i});
    
    meanNOI(i) = mean(NOI_Section{i});
    stdNOI(i) = std(NOI_Section{i});
end

ind = 1:length(PrefD_Section);

figure;
errorbar(ind,meanPD,stdPD);
title('Preferred Direction', 'FontSize', 18);
xlabel('Section Index', 'FontSize', 18);
ylabel('Preferred Direction (Degrees)', 'FontSize', 18);

figure;
errorbar(ind,meanNOI,stdNOI);
title('NOI', 'FontSize', 18);
xlabel('Section Index', 'FontSize', 18);
ylabel('NOI', 'FontSize', 18);


%{
%Layer Specific NOI

zVals = [PointData(:).z];
maxZ = max(zVals); minZ = min(zVals);
zDist = maxZ-minZ;

Array1 = []; Array2 = []; Array3 = []; Array4 = []; Array5 = [];

for i = 1:length(ElementData)
    zVal = mean([ElementData(i).nodes(1).z ElementData(i).nodes(8).z])*10;
    if (zVal < (zDist*0.2))
        Array1 = [Array1 NOI(i)];
    elseif ( zVal <(zDist*0.4))
        Array2 = [Array2 NOI(i)];
    elseif (zVal < (zDist*0.6))
        Array3 = [Array3 NOI(i)];
    elseif (zVal < (zDist*0.8))
        Array4 = [Array4 NOI(i)];
    else
        Array5 = [Array5 NOI(i)];
    end
end

[f1,x1] = hist(Array1,nBins);
[f2,x2] = hist(Array2,nBins);
[f3,x3] = hist(Array3,nBins);
[f4,x4] = hist(Array4,nBins);
[f5,x5] = hist(Array5,nBins);

figure;
subplot(5,1,1);
bar(x1,f1/sum(f1));
xlim([0,40]);
ylim([0 0.25]);
xlabel('Normalized Orientation Index (\nu)', 'FontSize', 24);
ylabel('Frequency', 'FontSize', 24);
title('0%-20%', 'FontSize', 24);
subplot(5,1,2);
bar(x2,f2/sum(f2));
xlim([0,40]);
ylim([0 0.25]);
xlabel('Normalized Orientation Index (\nu)', 'FontSize', 24);
ylabel('Frequency', 'FontSize', 24);
title('20%-40%', 'FontSize', 24);
subplot(5,1,3);
bar(x3,f3/sum(f3));
xlim([0,40]);
ylim([0 0.25]);
xlabel('Normalized Orientation Index (\nu)', 'FontSize', 24);
ylabel('Frequency', 'FontSize', 24);
title('40%-60%', 'FontSize', 24);
subplot(5,1,4);
bar(x4,f4/sum(f4));
xlim([0,40]);
ylim([0 0.25]);
xlabel('Normalized Orientation Index (\nu)', 'FontSize', 24);
ylabel('Frequency', 'FontSize', 24);
title('60%-80%', 'FontSize', 24);
subplot(5,1,5);
bar(x5,f5/sum(f5));
xlim([0,40]);
ylim([0 0.25]);
xlabel('Normalized Orientation Index (\nu)', 'FontSize', 24);
ylabel('Frequency', 'FontSize', 24);
title('80%-100%', 'FontSize', 24);



%}














%% PrefD Histograms

%{
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

%}

%% NOI Histograms
%{
figure;
[f,x] = hist(NOI,nBins);
%{
subplot(1,3,1);
this = bar(x,f);
xlim([0,70]);
xlabel('NOI');
ylabel('Bin Count');
title('Bin Count', 'FontSize', 18);
subplot(1,3,2);
%}
bar(x,f/sum(f));
xlim([0,70]);
xlabel('Normalized Orientation Index (');
ylabel('Frequency');
title('Full PAVL NOI', 'FontSize', 18);
%{
subplot(1,3,3);
bar(x,(f*VoxelVolume));
xlim([0,70]);
xlabel('NOI');
ylabel('Volume (mm^3)');
title('Volumetric', 'FontSize', 18);
%}
%}


%{
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

%}