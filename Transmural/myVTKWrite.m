function [ ] = myVTKWrite(dataPoints, Elements)

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


%% POINTS
numPoints = length(dataPoints);
fprintf(fid, ['POINTS ' num2str(numPoints) ' FLOAT\n']);

for i = 1:numPoints
    this(i,:) = [dataPoints(i).x dataPoints(i).y dataPoints(i).z];
    fprintf(fid, [num2str(dataPoints(i).x) ' ' num2str(dataPoints(i).y) ' ' num2str(dataPoints(i).z) '\n']);
end
fprintf(fid, '\n');


%% Cell Data
numCells = length(Elements);
numBlock = numCells * 9;

fprintf(fid, ['CELLS ' num2str(numCells) ' ' num2str(numBlock) '\n']);

for i = 1:length(Elements)
    theseIDs = [Elements(i).nodes(:).ID];
    string = [num2str(theseIDs(1))];
    for x = 2:length(theseIDs)
        string = [string ' ' num2str(theseIDs(x))];
    end
    
    idString = ['8 ' string '\n'];
    
    fprintf(fid, idString);
end
fprintf(fid, '\n');
fprintf(fid, ['CELL_TYPES ' num2str(numCells) '\n']);
%Cell type 11 is a voxel (what we want)
base = ' 11';
baseRep = repmat(base, [1,(numCells-1)]);
finalString = ['11' baseRep '\n'];
fprintf(fid, finalString);
fprintf(fid, '\n');



%% Point Data Sets
%Here is where we want to output the point data

fprintf(fid, ['POINT_DATA ' num2str(numPoints) '\n']);


%PrefD_Vector
fprintf(fid, 'VECTORS PreferredDirectionVector float\n');
for i = 1:numPoints
    Vector = dataPoints(i).PrefDVector;
   % this(i,:) = Vector;
    PrefDVOutput = [num2str(Vector(1)) ' ' num2str(Vector(2)) ' 0\n'];
    fprintf(fid, PrefDVOutput);
end
fprintf(fid, '\n');

%Preferred Direction Angle
fprintf(fid, 'SCALARS PreferredDirectionAngle float\n');
fprintf(fid, 'LOOKUP_TABLE default\n');
for i = 1:numPoints
    PrefDAOutput = [num2str(dataPoints(i).PrefDAngle) '\n'];
    fprintf(fid, PrefDAOutput);
end
fprintf(fid, '\n');

%NOI
fprintf(fid, 'SCALARS OrientationIndex float\n');
fprintf(fid, 'LOOKUP_TABLE default\n');
for i = 1:numPoints
    
    if imag(dataPoints(i).oi_odf) ~= 0
        disp(i);
        dataPoints(i).oi_odf = 0;
    end
    
    NOIOutput = [num2str(dataPoints(i).oi_odf) '\n'];
    fprintf(fid, NOIOutput);
end
fprintf(fid, '\n');

%Skew
fprintf(fid, 'SCALARS Skew float\n');
fprintf(fid, 'LOOKUP_TABLE default\n');
for i = 1:numPoints
    SkewOutput = [num2str(dataPoints(i).skew_odf) '\n'];
    fprintf(fid, SkewOutput);
end
fprintf(fid, '\n');

%Kurtosis
fprintf(fid, 'SCALARS Kurtosis float\n');
fprintf(fid, 'LOOKUP_TABLE default\n');
for i = 1:numPoints
    KurtosisOutput = [num2str(dataPoints(i).kurtosis_odf) '\n'];
    fprintf(fid, KurtosisOutput);
end
fprintf(fid, '\n');



%% Cell Data Sets
%Here we output the cell data
fprintf(fid, ['CELL_DATA ' num2str(numCells) '\n']);

%{
%Region
fprintf(fid, 'SCALARS Region float\n');
fprintf(fid, 'LOOKUP_TABLE default\n');
for i = 1:numCells
    PrefDVOutput = [num2str(Elements(i).Region) '\n'];
    fprintf(fid, PrefDVOutput);
end
fprintf(fid, '\n');
%}

%MeanPrefDV
fprintf(fid, 'VECTORS MeanPreferredDirectionVector float\n');
for i = 1:numCells
    Vector = Elements(i).PrefDV_Mean;
    PrefDVOutput = [num2str(Vector(1)) ' ' num2str(Vector(2)) ' 0\n'];
    fprintf(fid, PrefDVOutput);
end
fprintf(fid, '\n');
%}

%MeanPrefDA
fprintf(fid, 'SCALARS MeanPreferredDirectionAngle float\n');
fprintf(fid, 'LOOKUP_TABLE default\n');
for i = 1:numCells
    PrefDVOutput = [num2str(Elements(i).PrefDA_Mean) '\n'];
    fprintf(fid, PrefDVOutput);
end
fprintf(fid, '\n');



%MeanNOI
fprintf(fid, 'SCALARS MeanNOI float\n');
fprintf(fid, 'LOOKUP_TABLE default\n');
for i = 1:numCells
    NOIOutput = [num2str(Elements(i).NOI_Mean) '\n'];
    fprintf(fid, NOIOutput);
end
fprintf(fid, '\n');


%MeanSkew
fprintf(fid, 'SCALARS MeanSKEW float\n');
fprintf(fid, 'LOOKUP_TABLE default\n');
for i = 1:numCells
    SkewOutput = [num2str(Elements(i).Skew_Mean) '\n'];
    fprintf(fid, SkewOutput);
end
fprintf(fid, '\n');

%MeanKurtosis
fprintf(fid, 'SCALARS MeanKurtosis float\n');
fprintf(fid, 'LOOKUP_TABLE default\n');
for i = 1:numCells
    KurtosisOutput = [num2str(Elements(i).Kurtosis_Mean) '\n'];
    fprintf(fid, KurtosisOutput);
end
fprintf(fid, '\n');

%% Close it on up
st = fclose(fid);


%% Print out alternate vtk

ind = strfind(filename, '.vtk');
fileID = [pathname filename(1:ind-1) '-Alt.vtk'];

%% Open File
fid = fopen(fileID, 'w'); 

%% Header
fprintf(fid, '# vtk DataFile Version 2.0\n');
fprintf(fid, 'Data printed from this dope TSALS Program\n');
fprintf(fid, 'ASCII\n');
fprintf(fid, 'DATASET UNSTRUCTURED_GRID\n');

%% Find points (center of the elements)

xVals = zeros(1,length(Elements));
yVals = zeros(1,length(Elements));
zVals = zeros(1,length(Elements));

for i = 1:length(Elements)
    xVals(i) = Elements(i).nodes(1).x + ((Elements(i).nodes(8).x - Elements(i).nodes(1).x)/2);
    yVals(i) = Elements(i).nodes(1).y + ((Elements(i).nodes(8).y - Elements(i).nodes(1).y)/2);
    zVals(i) = Elements(i).nodes(1).z + ((Elements(i).nodes(8).z - Elements(i).nodes(1).z)/2);
end


%% Print out points

numPoints = length(Elements);
fprintf(fid, ['POINTS ' num2str(numPoints) ' FLOAT\n']);

for i = 1:numPoints
    fprintf(fid, [num2str(xVals(i)) ' ' num2str(yVals(i)) ' ' num2str(zVals(i)) '\n']);
end
fprintf(fid, '\n');

%% PrefD Gradient Tensor

fprintf(fid, ['POINT_DATA ' num2str(numPoints) '\n']);

%MeanPrefDV
fprintf(fid, 'TENSORS PDGradient float\n');
for i = 1:numPoints
    %Vector = Elements(i).PrefDV_Mean;
    PrefDVOutput = [num2str(Elements(i).PrefDV_Gradient(1,1)) ' ' num2str(Elements(i).PrefDV_Gradient(1,2)) ' ' num2str(Elements(i).PrefDV_Gradient(1,3)) '\n'];
    fprintf(fid, PrefDVOutput);
    PrefDVOutput = [num2str(Elements(i).PrefDV_Gradient(2,1)) ' ' num2str(Elements(i).PrefDV_Gradient(2,2)) ' ' num2str(Elements(i).PrefDV_Gradient(2,3)) '\n'];
    fprintf(fid, PrefDVOutput);
    PrefDVOutput = ['0 0 0 \n'];
    fprintf(fid, PrefDVOutput);
end
fprintf(fid, '\n');

%% NOI Gradient Vector

fprintf(fid, 'VECTORS GradientNOI float\n');
for i = 1:numPoints
    string = num2str(Elements(i).NOI_Gradient(1));
    string = [string ' ' num2str(Elements(i).NOI_Gradient(2))];
    string = [string ' ' num2str(Elements(i).NOI_Gradient(3))];
    PrefDAOutput = [string '\n'];
    fprintf(fid, PrefDAOutput);
end
fprintf(fid, '\n');

%% Close it on up
st = fclose(fid);

if(st == 0)
    disp('Your vtk is printed! Enjoy');
else
    disp('Idk, there was an error');
end

end

