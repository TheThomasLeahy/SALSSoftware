%Transmural Analysis Code
%Written by Jordan Graves and Thomas Leahy
%October 7th, 2016

clc;  clear all;

% Change the current folder to the folder of this m-file.
if(~isdeployed)
  cd(fileparts(which('TransmuralAnalysis.m')));
end

%% UI/Load All Data

%TSALS loads a stack of .m files containing all slice data computed by
%SALSA
%TSALS also loads a .xml file containing all transformation matrices and
%pixel sizes to convert tx,ty from pixels to mm

%Loads all data from SALSA calculations
data = loadMFiles();

%Rows of matrices contain the matrix for each image
%imageSize rows contain width, height for each image
[transformMatrices, imageSize] = loadMatrices();

%% 3D Reconstruction

slice_thickness_str = inputdlg('Enter a section thickness (mm)', 'Section Thickness',1,{'1'});
section_thickness = str2double(slice_thickness_str{1});

for i = 1:length(data)
    %Find data for this section
    thisSlice = data{i};
    names = fieldnames(thisSlice);
    sliceData = eval(strcat('thisSlice.',names{1}));
    
    %Remove bogus data - Still not sure why this is necessary
    x = 1;
    for j = 1:length(sliceData)
        if ~isempty(sliceData(j).x)
            thisData(x) = sliceData(j);
            %xVal = thisData(x).x;
            %thisData(x).x = thisData(x).y;
            %thisData(x).y = xVal;
            
            x = x + 1;
        end
    end
    sliceData = thisData;
    
    %Adjust for the weird thing SALS does
    for x = 1:length(sliceData)
        sliceData(x).x = round(sliceData(x).x,2);
        sliceData(x).y = round(sliceData(x).y,2);
    end
    
    % Translate transformMatrices from pixels to mms
    T = translateMatrices(sliceData, transformMatrices{i}, imageSize);
    
    %Translate xy coordinates to Fiji coordinates
    %Might not need to do this, hopefully
    [sliceData, yRange] = translateToFijiCoordinates(sliceData);
    
    
    h = waitbar(0, sprintf('Generating Tensors and Rotating for section %d', i));
    for i_dp=1:length(sliceData)
        if mod(length(sliceData), i_dp) == 0
        waitbar(i_dp/length(sliceData),h)
        end
        sliceData(i_dp).z = (i-1)*section_thickness;
        %sliceData(i_dp) = sliceData(i_dp).GenerateTensors;
        sliceData(i_dp) = sliceData(i_dp).ApplyTransformation2(T);
        %sliceData(i_dp) = sliceData(i_dp).ComputeStats;

        
    end
    close(h)
    
    %Translate back to SALS Coordinates
    sliceData = translateToSalsCoordinates(sliceData, yRange);

    
    %Interpolation
    if i == 1
        %The X,Y values for this slice will be our master grid
        
        xMasterGrid = [sliceData(:).x];
        yMasterGrid = [sliceData(:).y];
        xUnique = sort(unique(xMasterGrid));
        yUnique = sort(unique(yMasterGrid));
        
        xStepSize = xUnique(2)-xUnique(1);
        yStepSize = yUnique(2)-yUnique(1);
        
        [X1,Y1] = ndgrid(xUnique, yUnique);
        
    else
        %Interpolate data points on this slice to the master grid
        [sliceData, X1, Y1] = interpolate(sliceData, X1, Y1, xStepSize, yStepSize); 
    end
    
    
    
    finalData{i} = sliceData;
end


%% 3D Analysis

%Here is where we make elements and gradients, yo

[PointData, ElementData] = TFA3DAnalysis(finalData);


%% Write data file (paraview)

myVTKWrite(PointData, ElementData);
