%Mass SALS Analysis
%Code by Thomas Leahy

clc; clear all;

%% Add required files to path
if(~isdeployed)
  cd(fileparts(which('MassSALSAnalysis.m')));
end
addpath('../SALSAnalysis');
addpath('../export_fig');

%% File Load: Load all SALS files

[foldername,SALSFiles] = loadSALSFiles();

a = [SALSFiles.name];
sectionNames = strsplit(a,'.txt');

imageFolder = strcat(foldername,'/../Images');
BWimageFolder = strcat(foldername,'/../BW_Images');
outputFolder = strcat(foldername,'/../SALSA OUT MAT/');
mkdir(imageFolder);
mkdir(outputFolder);
mkdir(BWimageFolder);

%% Analyze: Analyze all SALS files, stored in cell array
sectionData = cell(1,length(SALSFiles));
for i = 1:length(SALSFiles)
    Data = loadData(strcat(foldername,'/',SALSFiles(i).name));
    h = waitbar(0,strcat('SALS Analysis: Section number ' ,num2str(i)));
    for x = 1:length(Data)
        waitbar(x/length(Data))
        Data(x).x = round(Data(x).x,2);
        Data(x).y = round(Data(x).y,2);
        Data(x) = Data(x).Normalize;
        Data(x) = Data(x).GenerateFourier(14);
        Data(x) = Data(x).ComputeStats;
    end
    close(h);
    sectionData{i} = Data;
end
%% Visualize and edit.

%this.Figure = guihandles(MegaSalsaGUI);
sectionData = MegaSalsaGUI(sectionData, imageFolder, sectionNames);

%% Build and store BinaryImages

for x=1:length(sectionData)
    thisData = sectionData{x};
    xVals = sort(unique([thisData(:).x]));
    yVals = sort(unique([thisData(:).y]));
    
    data = zeros(length(yVals),length(xVals));
    index = 1;
    
    for j = 1:length(yVals)
        for i = 1:length(xVals)
            data(i,j) = thisData(index).tissue_flag;
            index = index + 1;
        end
    end
    
    %fig = figure;
    image = im2bw(data);
    image = flipud(image);
    imageBig = imresize(image,[500,500]);
    %thisPic = imshow(imageBig);
    %set(gca,'YDir','normal');
    sectionName = sectionNames(x);
    C = {BWimageFolder,'/',sectionName{1},'.tif'};
    imwrite(imageBig,strjoin(C,''));
    
end

%% Save SALSA Images

%Fix xy issue

for i =1:length(sectionData)
    thisData = sectionData{i};
    for j = 1:length(thisData)
        xTemp = thisData(j).x;
        thisData(j).x = thisData(j).y;
        thisData(j).y = xTemp;
    end
    sectionData{i} = thisData;
end


choice = saveText();
if isequal(choice, 'Yes')
    textFolder = strcat(foldername,'/../SALSA OUT TXT/');
    mkdir(textFolder);
    for i =1:length(sectionData)
        Section = sectionData{i};
        
        % TXT file
        sectionName = sectionNames(i);
        C = {textFolder,sectionName{1},'_SALSA','.txt'};
        fileID = fopen(strjoin(C,''),'w');
        fprintf(fileID, data_point.header('\t'));
        for d = 1:length(Section)
            mDataPoint = Section(d);
            fprintf(fileID, '\n');
            fprintf(fileID, mDataPoint.print('\t'));
        end
        fclose(fileID);
        
    end
    
end

%Save files
for i =1:length(sectionData)
    Section = sectionData{i};
    
    sectionName = sectionNames(i);
    C = {outputFolder,sectionName{1},'.mat'};

    % Matlab file
    save(strjoin(C,''),'Section');
end

