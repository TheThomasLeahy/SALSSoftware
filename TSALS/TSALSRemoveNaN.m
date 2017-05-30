clear all; clc;
filename = '/Users/ccsmacmini/Documents/SALS Files/Transmural SALS Files/Bovine Pericardium/yourTecplotfile.plt';
delimiter = '\t';
startRow = 3;
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
Node = dataArray{:, 1}; Node(isnan(Node))=0;
XPos = dataArray{:, 2}; XPos(isnan(XPos))=0;
YPos = dataArray{:, 3}; YPos(isnan(YPos))=0;
ZPos = dataArray{:, 4}; ZPos(isnan(ZPos))=0;
Bit = dataArray{:, 5}; Bit(isnan(Bit))=0;
OI = dataArray{:, 6}; OI(isnan(OI))=0;
BL = dataArray{:, 7}; BL(isnan(BL))=0;
MaxI = dataArray{:, 8}; MaxI(isnan(MaxI))=0;
PrefD = dataArray{:, 9}; PrefD(isnan(PrefD))=0;
Skew = dataArray{:, 10}; Skew(isnan(Skew))=0;
Kurtosis = dataArray{:, 11}; Kurtosis(isnan(Kurtosis))=0;
H1111 = dataArray{:, 12}; H1111(isnan(H1111))=0;
H2211 = dataArray{:, 13}; H2211(isnan(H2211))=0;
H1112 = dataArray{:, 14}; H1112(isnan(H1112))=0;
H2212 = dataArray{:, 15}; H2212(isnan(H2212))=0;
H1122 = dataArray{:, 16}; H1122(isnan(H1122))=0;
H2222 = dataArray{:, 17}; H2222(isnan(H2222))=0;
Xn = dataArray{:, 18}; Xn(isnan(Xn))=0;
Yn = dataArray{:, 19}; Yn(isnan(Yn))=0;
H1n = dataArray{:, 20}; H1n(isnan(H1n))=0;
H2n = dataArray{:, 21}; H2n(isnan(H2n))=0;
H3n = dataArray{:, 22}; H3n(isnan(H3n))=0;
H4n = dataArray{:, 23}; H4n(isnan(H4n))=0;
H5n = dataArray{:, 24}; H5n(isnan(H5n))=0;
H6n = dataArray{:, 25}; H6n(isnan(H6n))=0;
allData = [Node XPos YPos ZPos Bit OI BL MaxI PrefD Skew Kurtosis H1111 H2211 H1112 H2212 H1122 H2222 Xn Yn H1n H2n H3n H4n H5n H6n];

%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;
                    
                    
                variable={'Node#','Xpos','Ypos','Zpos','Bit','OI','BL','MaxI','PrefD','Skew','Kurtosis','H1111','H2211','H1112','H2212','H1122','H2222','Xn','Yn','H1n','H2n','H3n','H4n','H5n','H6n'};
                zcoord = allData(:,length(variable));      %  To get the section number
                tranSALoutfolder = uigetdir('output');
                tranSALoutfile = 'yournewTecplotfile.plt';
                f=fopen((strcat(tranSALoutfolder,'/',tranSALoutfile)),'w'); %Need to write a variable output name
                fprintf(f,'TITLE= "FE-Volume_Brick_Data" \n');
                fprintf(f,strcat('VARIABLES = ','"',strjoin(variable(1,1:end),'", "'),'"')); 
                fprintf(f,'ZONE I= 120, J= 120, K=41, DATAPACKING=POINT \n');
                dlmwrite ((strcat(tranSALoutfolder,'/',tranSALoutfile)), allData, 'delimiter','\t', '-append');  % All the sections are in the file with consecutive ID number            
                disp('doneeeee')
                
