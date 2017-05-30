function [ xRange, yRange ] = findRanges( sliceData )
xmin = min([sliceData(:).x]);
ymin = min([sliceData(:).y]);
xmax = max([sliceData(:).x]);
ymax = max([sliceData(:).y]);

xRange = abs(xmax-xmin);
yRange = abs(ymax-ymin);
end

