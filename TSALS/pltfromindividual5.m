% This code takes a folder of TSALS files for each slice and produces a
% .plt
clear all; clc;
foldername = uigetdir('source');
allData = [];
t = input('thickness (mm)\n');
xdist = input('x length (mm)\n');
ydist = input('y length (mm)\n');
slices = 0;
for i=1:6
    j = 5+(i-1)*10
    if i == 1;
        filename = strcat('/','PAV2_2_0',num2str(j),'trans_8.txt_TSALS.txt');
    else
        filename = strcat('/','PAV2_2_',num2str(j),'trans_8.txt_TSALS.txt');
    end
    file = strcat(foldername,filename);
    if  exist(file,'file');
        slices = slices+1;
        delimiter = '\t';
        startRow = 3;
        formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
        fileID = fopen(file,'r');
        dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,0,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
        fclose(fileID);
        Node = dataArray{:, 1}+(xdist*ydist)*(slices-1);
        XPos = dataArray{:, 2};
        YPos = dataArray{:, 3}; 
        Bit = dataArray{:, 4}; 
        OI = dataArray{:, 5}; 
        BL = dataArray{:, 6}; 
        MaxI = dataArray{:, 7};
        PrefD = dataArray{:, 8}; 
        Skew = dataArray{:, 9}; 
        Kurtosis = dataArray{:, 10};
        H1111 = dataArray{:, 11}; 
        H2211 = dataArray{:, 12}; 
        H1112 = dataArray{:, 13}; 
        H2212 = dataArray{:, 14}; 
        H1122 = dataArray{:, 15}; 
        H2222 = dataArray{:, 16}; 
        Xn = dataArray{:, 17}; 
        Yn = dataArray{:, 18}; 
        H1n = dataArray{:, 19};
        H2n = dataArray{:, 20}; 
        H3n = dataArray{:, 21}; 
        H4n = dataArray{:, 22}; 
        H5n = dataArray{:, 23}; 
        H6n = dataArray{:, 24}; 
        ZPos = 0.*XPos+(t*(slices-1));
        allData = [allData ; Node XPos YPos ZPos Bit OI BL MaxI PrefD Skew Kurtosis H1111 H2211 H1112 H2212 H1122 H2222 Xn Yn H1n H2n H3n H4n H5n H6n];
    end
end
%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;
                    
                    
                variable={'Node#','Xpos','Ypos','Zpos','Bit','OI','BL','MaxI','PrefD','Skew','Kurtosis','H1111','H2211','H1112','H2212','H1122','H2222','Xn','Yn','H1n','H2n','H3n','H4n','H5n','H6n'};
                zcoord = allData(:,length(variable));      %  To get the section number
                tranSALoutfolder = uigetdir('output');
                tranSALoutfile = 'yournewTecplotfile.plt';
                f=fopen((strcat(tranSALoutfolder,'/',tranSALoutfile)),'w'); %Need to write a variable output name
                fprintf(f,'TITLE= "FE-Volume_Brick_Data" \n');
                fprintf(f,strcat('VARIABLES = ','"',strjoin(variable(1,1:end),'", "'),'"')); 
                fprintf(f,strcat('ZONE I= ',num2str(xdist*10),' J= ',num2str(ydist*10),' K=',num2str(slices)', ' DATAPACKING=POINT \n'));
                dlmwrite ((strcat(tranSALoutfolder,'/',tranSALoutfile)), allData, 'delimiter','\t', '-append');  % All the sections are in the file with consecutive ID number            
                disp('doneeeee')
                
