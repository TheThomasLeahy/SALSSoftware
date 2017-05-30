function [ T ] = translateMatrices(sliceData, transformMatrix, imageSize)
%translates matrix to T, the matrix in terms of mm
T = transformMatrix;

%Find Range
[xRange, yRange] = findRanges(sliceData);

%Translate tx, ty to mm from pixels
T(1,3)=transformMatrix(1,3)*(xRange/imageSize(1));
T(2,3)=transformMatrix(2,3)*(yRange/imageSize(2));

%T(2,1) = transformMatrix(1,2);
%T(1,2) = transformMatrix(2,1);

end

