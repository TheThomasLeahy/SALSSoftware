
x1 = linspace(0,1,51);
x2 = linspace(0,1,51);
x3 = linspace(0,1,51);

small = 1/2;
big = sqrt(3)/2;

%PrefD1 = [0.816410109496494;0.866647320747295;0.819685732496813;0.895156473773306;0.994236448362540;0.999104642691669;0.999462065679575;0.996906928289383];
%PrefD2 = [-0.577472538837929;-0.498921257756708;-0.572813494901407;-0.445752047063993;-0.107209536644095;0.0423073628574550;-0.0327960251786176;0.0785911975263527];

PrefD1 = [1; big; big; small; big; small; small; 0];
PrefD2 = [0; small; small; big; small; big; big; 1];

PrefD = [PrefD1 PrefD2];

for i = 1:length(x1)
    for j = 1:length(x2)
        for k = 1:length(x3)
            GriddedData(i,j,k,1) = TrilinearInterpolation([x1(i) x2(j) x3(k)],PrefD1');
            GriddedData(i,j,k,2) = TrilinearInterpolation([x1(i) x2(j) x3(k)],PrefD2');
        end
    end
end

%% Find Gradient for the Preferred Direction Vector
E1= 0.5; E2 = 0.5; E3 = 0.5;
dE1dX = 1; dE2dY = 1; dE3dZ = 1;

PrefDV1 = PrefD1';
PrefDV2 = PrefD2';

%v1,E1
E1_High = 0.51;
E1_Low = 0.49;

PrefA_E1_High = TrilinearInterpolation([E1_High, E2, E3], PrefDV1);
PrefA_E1_Low = TrilinearInterpolation([E1_Low, E2, E3], PrefDV1);

dPrefDV1dX1 = (PrefA_E1_High-PrefA_E1_Low)/dE1dX;

%v1,E2 Direction
E2_High = 0.51;
E2_Low = 0.49;

PrefA_E2_High = TrilinearInterpolation([E1, E2_High, E3], PrefDV1);
PrefA_E2_Low = TrilinearInterpolation([E1, E2_Low, E3], PrefDV1);

dPrefDV1dX2 = (PrefA_E2_High-PrefA_E2_Low)/dE2dY;

%v1,e3 Direction
E3_High = 0.51;
E3_Low = 0.49;

PrefA_E3_High = TrilinearInterpolation([E1, E2, E3_High], PrefDV1);
PrefA_E3_Low = TrilinearInterpolation([E1, E2, E3_Low], PrefDV1);

dPrefDV1dX3 = (PrefA_E3_High-PrefA_E3_Low)/dE3dZ;

%v2,E1
PrefA_E1_High = TrilinearInterpolation([E1_High, E2, E3], PrefDV2);
PrefA_E1_Low = TrilinearInterpolation([E1_Low, E2, E3], PrefDV2);

dPrefDV2dX1 = (PrefA_E1_High-PrefA_E1_Low)/dE1dX;

%v2,E2 Direction
PrefA_E2_High = TrilinearInterpolation([E1, E2_High, E3], PrefDV2);
PrefA_E2_Low = TrilinearInterpolation([E1, E2_Low, E3], PrefDV2);

dPrefDV2dX2 = (PrefA_E2_High-PrefA_E2_Low)/dE2dY;

%v2,e3 Direction
PrefA_E3_High = TrilinearInterpolation([E1, E2, E3_High], PrefDV2);
PrefA_E3_Low = TrilinearInterpolation([E1, E2, E3_Low], PrefDV2);

dPrefDV2dX3 = (PrefA_E3_High-PrefA_E3_Low)/dE3dZ;

%Make Vector
PrefDV_Gradient = [dPrefDV1dX1, dPrefDV1dX2, dPrefDV1dX3;...
                   dPrefDV2dX1, dPrefDV2dX2, dPrefDV2dX3;...
                   0            0            0          ];
               
      
%% UI Get File Location
[filename, pathname] = uiputfile('*.vtk', 'Where do you want to save the .vtk?');
fileID = [pathname filename];

%% Open File
fid = fopen(fileID, 'w'); 

%% Header
fprintf(fid, '# vtk DataFile Version 2.0\n');
fprintf(fid, 'Data printed from this dope TSALS Program\n');
fprintf(fid, 'ASCII\n');
fprintf(fid, 'DATASET UNSTRUCTURED_GRID\n');

%%Point Data
numPoints = length(x1)*length(x2)*length(x3);
fprintf(fid, ['POINTS ' num2str(numPoints) ' FLOAT\n']);

x = 1;
indices = [];
this = ones(numPoints,3);
for i = 1:length(x1)
    for j = 1:length(x2)
        for k = 1:length(x3)
            this(x,:) = [x1(i) x2(j) x3(k)];
            if (this(x,1) == 0 ||(this(x,1) == 1)) &&(this(x,2) == 0 ||(this(x,2) == 1)) && (this(x,3) == 0 ||(this(x,3) == 1))
                indices = [indices x];
            end
            fprintf(fid, [num2str(x1(i)) ' ' num2str(x2(j)) ' ' num2str(x3(k)) '\n']);
            x = x+1;
        end
    end
end
fprintf(fid, '\n');


%% Cell Data
numCells = 1;
numBlock = numCells * 9;

fprintf(fid, ['CELLS ' num2str(numCells) ' ' num2str(numBlock) '\n']);

for i = 1:numCells
    %theseIDs = [Elements(i).nodes(:).ID];
    string = [num2str(indices(1))];
    for x = 2:length(indices)
        string = [string ' ' num2str(indices(x))];
    end
    
    idString = ['8 ' string '\n'];
    
    fprintf(fid, idString);
end
fprintf(fid, '\n');
fprintf(fid, ['CELL_TYPES ' num2str(numCells) '\n']);
%Cell type 11 is a voxel (what we want)
%base = ' 11';
%baseRep = repmat(base, [1,(numCells-1)]);
finalString = ['11 \n'];
fprintf(fid, finalString);
fprintf(fid, '\n');



fprintf(fid, ['POINT_DATA ' num2str(numPoints) '\n']);


fprintf(fid, 'VECTORS PDVector float\n');
for i = 1:length(x1)
    for j = 1:length(x2)
        for k = 1:length(x3)
            PrefDAOutput = [num2str(GriddedData(i,j,k,1)) ' ' num2str(GriddedData(i,j,k,2)) ' 0\n'];
            fprintf(fid, PrefDAOutput);
        end
    end
end
fprintf(fid, '\n');

fprintf(fid, ['CELL_DATA ' num2str(numCells) '\n']);


%MeanPrefDV
fprintf(fid, 'TENSORS PDGradient float\n');
for i = 1:numCells
    %Vector = Elements(i).PrefDV_Mean;
    PrefDVOutput = [num2str(PrefDV_Gradient(1,1)) ' ' num2str(PrefDV_Gradient(1,2)) ' ' num2str(PrefDV_Gradient(1,3)) '\n'];
    fprintf(fid, PrefDVOutput);
    PrefDVOutput = [num2str(PrefDV_Gradient(2,1)) ' ' num2str(PrefDV_Gradient(2,2)) ' ' num2str(PrefDV_Gradient(2,3)) '\n'];
    fprintf(fid, PrefDVOutput);
    PrefDVOutput = ['0 0 0 \n'];
    fprintf(fid, PrefDVOutput);
end
fprintf(fid, '\n');

st = fclose(fid);
if(st == 0)
    disp('Your vtk is printed! Enjoy');
else
    disp('Idk, there was an error');
end

%}
                   
this = ones(numPoints,3);
for i = 1:length(x1)
    for j = 1:length(x2)
        for k = 1:length(x3)
            this(x,:) = [x1(i) x2(j) x3(k)];
            if (this(x,1) == 0 ||(this(x,1) == 1)) &&(this(x,2) == 0 ||(this(x,2) == 1)) && (this(x,3) == 0 ||(this(x,3) == 1))
                indices = [indices x];
            end
            x = x+1;
        end
    end
end
             
%{
%% UI Get File Location
[filename, pathname] = uiputfile('*.vtk', 'Where do you want to save the .vtk?');
fileID = [pathname filename];

%% Open File
fid = fopen(fileID, 'w'); 

%% Header
fprintf(fid, '# vtk DataFile Version 2.0\n');
fprintf(fid, 'Data printed from this dope TSALS Program\n');
fprintf(fid, 'ASCII\n');
fprintf(fid, 'DATASET UNSTRUCTURED_GRID\n');

%%Point Data
numPoints = length(x1)*length(x2)*length(x3);
fprintf(fid, ['POINTS ' num2str(8) ' FLOAT\n']);

x = 1;
indices = [];
this = ones(numPoints,3);
for i = 1:length(indices)
    
    fprintf(fid, [num2str(x1(indices(i))) ' ' num2str(x2(indices(i))) ' ' num2str(x3(indices(i))) '\n']);
    x = x+1;
    
end
fprintf(fid, '\n');


%% Cell Data
numCells = 1;
numBlock = numCells * 9;

fprintf(fid, ['CELLS ' num2str(numCells) ' ' num2str(numBlock) '\n']);

for i = 1:numCells
    %theseIDs = [Elements(i).nodes(:).ID];
    string = ['1 2 3 4 5 6 7 8'];
    for x = 2:length(indices)
        string = [string ' ' num2str(indices(x))];
    end
    
    idString = ['8 ' string '\n'];
    
    fprintf(fid, idString);
end
fprintf(fid, '\n');
fprintf(fid, ['CELL_TYPES ' num2str(numCells) '\n']);
%Cell type 11 is a voxel (what we want)
%base = ' 11';
%baseRep = repmat(base, [1,(numCells-1)]);
finalString = ['11 \n'];
fprintf(fid, finalString);
fprintf(fid, '\n');



fprintf(fid, ['POINT_DATA ' num2str(numPoints) '\n']);


fprintf(fid, 'VECTORS PDVector float\n');
x = 1;
for i = 1:length(x1)
    for j = 1:length(x2)
        for k = 1:length(x3)
            if ~isempty(find(x ==indices))
            PrefDAOutput = [num2str(GriddedData(i,j,k,1)) ' ' num2str(GriddedData(i,j,k,2)) ' 0\n'];
            fprintf(fid, PrefDAOutput);
            end
            x = x + 1;
        end
    end
end
fprintf(fid, '\n');

fprintf(fid, ['CELL_DATA ' num2str(numCells) '\n']);


%MeanPrefDV
fprintf(fid, 'TENSORS PDGradient float\n');
for i = 1:numCells
    %Vector = Elements(i).PrefDV_Mean;
    PrefDVOutput = [num2str(PrefDV_Gradient(1,1)) ' ' num2str(PrefDV_Gradient(1,2)) ' ' num2str(PrefDV_Gradient(1,3)) '\n'];
    fprintf(fid, PrefDVOutput);
    PrefDVOutput = [num2str(PrefDV_Gradient(2,1)) ' ' num2str(PrefDV_Gradient(2,2)) ' ' num2str(PrefDV_Gradient(2,3)) '\n'];
    fprintf(fid, PrefDVOutput);
    PrefDVOutput = ['0 0 0 \n'];
    fprintf(fid, PrefDVOutput);
end
fprintf(fid, '\n');

st = fclose(fid);
if(st == 0)
    disp('Your vtk is printed! Enjoy');
else
    disp('Idk, there was an error');
end

%}