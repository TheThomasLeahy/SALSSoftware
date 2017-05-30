function [ sliceData ,yRange ] = translateToFijiCoordinates(sliceData)

%Make top left 0,0

[~, yRange] = findRanges(sliceData);

for i = 1:length(sliceData)
    sliceData(i).y = sliceData(i).y-yRange;
    sliceData(i).y = (-1)*sliceData(i).y;
end

end

