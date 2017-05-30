


NOI = [0.7, 0.67, 0.67, 0.63, 0.67, 0.63, 0.63, 0.6];

x1 = linspace(0,1,101);
x2 = linspace(0,1,101);
x3 = linspace(0,1,101);


for i = 1:length(x1)
    for j = 1:length(x2)
        for k = 1:length(x3)
            GriddedData(i,j,k) = TrilinearInterpolation([x1(i) x2(j) x3(k)],NOI);
        end
    end
end

E1= 0.5; E2 = 0.5; E3 = 0.5;
dE1dX = 1; dE2dY = 1; dE3dZ = 1;
%E1 Direction
            E1_High = 0.51;
            E1_Low = 0.49;
            
            PrefA_E1_High = TrilinearInterpolation([E1_High, E2, E3], NOI);
            PrefA_E1_Low = TrilinearInterpolation([E1_Low, E2, E3], NOI);
            
            dPrefAdX1 = (PrefA_E1_High-PrefA_E1_Low)/dE1dX;
            
            %E1 Direction
            E2_High = 0.51;
            E2_Low = 0.49;
            
            PrefA_E2_High = TrilinearInterpolation([E1, E2_High, E3], NOI);
            PrefA_E2_Low = TrilinearInterpolation([E1, E2_Low, E3], NOI);
            
            dPrefAdX2 = (PrefA_E2_High-PrefA_E2_Low)/dE2dY;
            
            %E1 Direction
            E3_High = 0.51;
            E3_Low = 0.49;
            
            PrefA_E3_High = TrilinearInterpolation([E1, E2, E3_High], NOI);
            PrefA_E3_Low = TrilinearInterpolation([E1, E2, E3_Low], NOI);
            
            dPrefAdX3 = (PrefA_E3_High-PrefA_E3_Low)/dE3dZ;
            
            %Make Vector
            NOI_Gradient = [dPrefAdX1 dPrefAdX2 dPrefAdX3];



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
numPoints = 101*101*101;
fprintf(fid, ['POINTS ' num2str(numPoints) ' FLOAT\n']);

x = 1;
indices = [];
this = ones(101*101*101,3);
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


fprintf(fid, 'SCALARS NOIValue float\n');
fprintf(fid, 'LOOKUP_TABLE default\n');
for i = 1:length(x1)
    for j = 1:length(x2)
        for k = 1:length(x3)
            PrefDAOutput = [num2str(GriddedData(i,j,k)) '\n'];
            fprintf(fid, PrefDAOutput);
        end
    end
end
fprintf(fid, '\n');

fprintf(fid, ['CELL_DATA ' num2str(numCells) '\n']);


%MeanPrefDV
fprintf(fid, 'VECTORS NOIGradient float\n');
for i = 1:numCells
    %Vector = Elements(i).PrefDV_Mean;
    PrefDVOutput = [num2str(NOI_Gradient(1)) ' ' num2str(NOI_Gradient(2)) ' ' num2str(NOI_Gradient(3)) '\n'];
    fprintf(fid, PrefDVOutput);
end
fprintf(fid, '\n');

st = fclose(fid);
if(st == 0)
    disp('Your vtk is printed! Enjoy');
else
    disp('Idk, there was an error');
end

