%Mass SALS Analysis
%Code by Thomas Leahy

clc; clear all; close all;

%% Add required files to path
addpath('../SALSAnalysis');
addpath('../export_fig');

%% File Load: Load all SALS files

imageFolder = uigetdir( '\*', 'Select where you want to save the image stack');
outputFolder = uigetdir('\*', 'Select where you want to save the SALSA files');

[foldername,SALSFiles] = loadSALSFiles();
disp('Stuff');


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
sectionData = MegaSalsaGUI(sectionData, imageFolder);

%% Build and store BinaryImages

for x =1:length(sectionData)
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
    string = strcat(imageFolder,'/Section',num2str(x),'.tif');
    imwrite(imageBig,string);
    
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


%Save files
for i =1:length(sectionData)
    Section = sectionData{i};
    
    % Matlab file
    string = strcat(outputFolder,'/Section',num2str(i),'.mat');
    save(string,'Section');
end


choice = saveText();
if isequal(choice, 'Yes')
    textFolder = uigetdir('\*', 'Select where you want to save the text files');
    
    for i =1:length(sectionData)
        Section = sectionData{i};
        
        % TXT file
        string = strcat(textFolder,'/Section',num2str(i),'.txt');
        fileID = fopen(string,'w');
        
        fprintf(fileID, data_point.header('\t'));
        for d = 1:length(Section)
            mDataPoint = Section(d);
            fprintf(fileID, '\n');
            fprintf(fileID, mDataPoint.print('\t'));
        end
        fclose(fileID);
        
    end
    
end